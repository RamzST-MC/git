local putItemForSale, getItemFromSale, deleteItemFromSale do -- эти функцию стоит переписать для работы с SQL
	local ITEMS_FOR_SALE = util.JSONToTable( file.Read("igs_demo_auctiond.dat") or "[]" )

	-- sale_lot_dat obj: {owner_s64, item_uid, price}
	function putItemForSale(sale_lot_dat, fCallback)
		-- if math.random(3) == 1 then fCallback(false, "Ошибка добавления в базу данных, хотя покупка удалена в IGS") return end -- чисто для примера
		local sale_uid = table.insert(ITEMS_FOR_SALE, sale_lot_dat)
		file.Write("igs_demo_auction.dat", util.TableToJSON(ITEMS_FOR_SALE))
		fCallback(true, sale_uid) -- sale_uid может быть любым значением. Как числом, так и uuid
	end

	-- должен возвращать (true, nil) если лот не найден.
	-- (true, {owner_s64, item_uid, price}), если лот найден по ид
	-- (false, "message"), если ошибка
	function getItemFromSale(sale_uid, fCallback)
		local sale_item = ITEMS_FOR_SALE[sale_uid]
		fCallback(true, sale_item) --> nil or {owner_s64, item_uid, price}
	end

	function deleteItemFromSale(sale_uid, fCallback)
		ITEMS_FOR_SALE[sale_uid] = nil
		file.Write("igs_demo_auction.dat", util.TableToJSON(ITEMS_FOR_SALE))
		if fCallback then fCallback(true) end
	end
end

-- SV
local playerRequestedItemSale do
	-- Удаляет самую старую покупку с указанным item_uid
	local function _disablePurchaseByUID(s64, item_uid, fCallback)
		IGS.GetPlayerPurchases(s64, function(tPurchases) -- list of {`ID`,`Server`,`Item`,`Purchase`,`Expire`(таймштамп),`SteamID`, `Nick`}
			local found_purchase = nil
			for _,tPurchase in ipairs(tPurchases) do
				if tPurchase.Item == item_uid then
					found_purchase = tPurchase
					break
				end
			end

			if not found_purchase then
				fCallback(false, "У вас уже нет предмета, который вы хотели выставить на продажу") -- race condition, rare case
				return
			end

			local purchase_id = found_purchase.ID
			IGS.DisablePurchase(purchase_id, function(bDisabled)
				if not bDisabled then
					fCallback(false, "Донат предмет не удалось отключить для последующей продажи") -- anti race condition
					return
				end

				fCallback(true)
			end)
		end)
	end

	playerRequestedItemSale = function(pl, item_uid, price, fCallback)
		local purchases_amount = pl:HasPurchase(item_uid)
		if not purchases_amount then
			fCallback(false, "У вас нет предмета, который вы хотите выставить на продажу")
			return
		end

		local ITEM = IGS.GetItemByUID(item_uid)
		if not ITEM:GetMeta("for_sale") then
			fCallback(false, "Этот предмет нельзя выставить на продажу")
			return
		end

		if price <= 0 then
			fCallback(false, "Цена не может быть отрицательной")
			return
		end

		if pl.block_race_condition then
			fCallback(false, "Запрос в процессе выполнения #1")
			return
		end
		pl.block_race_condition = true

		local s64 = pl:SteamID64()
		_disablePurchaseByUID(s64, item_uid, function(bOk, sError)
			if not bOk then
				pl.block_race_condition = nil
				fCallback(false, sError)
				return
			end

			if IsValid(pl) then -- не вышел с сервера в процессе операции
				IGS.LoadPlayerPurchases(pl, function() -- перезагрузка донат предметов, чтобы услуга тут же снялась
					IGS.Notify(pl, "Покупки перезагружены") -- уведомление в чат игроку
				end)
			end

			local sale_lot_dat = {s64, item_uid, price}
			putItemForSale(sale_lot_dat, function(bOk2, sErr_Or_Id)
				pl.block_race_condition = nil
				fCallback(bOk2, sErr_Or_Id)
			end)
		end)
	end
end

-- SV
local playerRequestedItemPurchase do
	playerRequestedItemPurchase = function(pl, sale_uid, fCallback)
		getItemFromSale(sale_uid, function(ok, sale_lot_dat) -- nil or {owner_s64, item_uid, price}
			if not ok then fCallback(false, sale_lot_dat) return end

			if ok and not sale_lot_dat then -- ок, но предмета нет
				fCallback(false, "Предмет уже продан или указан несуществующий id лота")
				return
			end

			local owner_s64, item_uid, price = unpack(sale_lot_dat)
			if not IGS.CanAfford(pl, price) then
				fCallback(false, "У вас недостаточно средств")
				return
			end

			if pl.igs_unfinished_purchase then
				fCallback(false, "Запрос в процессе выполнения #2")
				return
			end
			pl.igs_unfinished_purchase = true -- название взято с igs-core. Не принципиально так то и можно было юзать block_race_condition

			IGS.PayP2P(pl:SteamID64(), owner_s64, price, "Аукцион " .. item_uid .. ". ID ордера " .. sale_uid, function()
				deleteItemFromSale(sale_uid, function(rem_ok, sMessage)
					if not rem_ok then pl.igs_unfinished_purchase = nil fCallback(false, sMessage) return end

					IGS.PlayerPurchasedItemByUID(pl, item_uid, function(purch_ok, iPurchOrInvId)
						pl.igs_unfinished_purchase = nil
						fCallback(purch_ok, iPurchOrInvId)
					end)
				end)
			end)
		end)
	end
end

concommand.Add("i_want_to_SELL_donate_item", function(pl, _, args)
	local item_uid, price = args[1], tonumber(args[2])
	if not item_uid then IGS.Notify(pl, "Укажите uid предмета после команды") return end
	if not price then IGS.Notify(pl, "Укажите цену предмета в руб после uid предмета, по которой вы хотите его продать") return end

	playerRequestedItemSale(pl, item_uid, price, function(bOk, sMessage)
		IGS.Notify(pl, bOk and ("Предмет выставлен на продажу. ID: " .. sMessage) or ("Ошибка. " .. sMessage))
	end)
end)

concommand.Add("i_want_to_BUY_donate_item", function(pl, _, args)
	local sale_uid = tonumber(args[1]) or args[1]
	if not sale_uid then IGS.Notify(pl, "Укажите ID лота после команды") return end

	playerRequestedItemPurchase(pl, sale_uid, function(bOk, sMessage)
		IGS.Notify(pl, bOk and ("Предмет успешно куплен! GMD inv or purch ID: " .. sMessage) or ("Ошибка. " .. sMessage))
	end)
end)