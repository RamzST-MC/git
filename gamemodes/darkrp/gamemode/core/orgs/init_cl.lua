-- ухади ишак ибаный, эти орги всё равно у тебя не встанут
rp.orgs = rp.orgs or {}
rp.orgs.Banners = rp.orgs.Banners or {}
local a = 'За '
local b = [[, вы можете создать организацию, охватывающую все наши серверы DarkRP.
Членство в организации дает вам несколько преимуществ. Развивайтесь вместе с ролевой семьей, демонстрируйте свои нашивки с помощью пользовательского баннера вашей группы, помогайте друг другу, используя общий банк, или уничтожайте базы других организаций как единое целое.
Используйте богатую MoTD и глубокую иерархическую структуру для организации ваших участников. Легко приглашайте, продвигайте или удаляйте игроков. Журналы аудита отслеживают каждое действие, выполненное в вашей организации.
Внимательно выбирайте имя, потому что переименования стоят ]]
local c = '!'
local d
local e
local f
net('rp.OrgsMenu', function()
if !IsValid(e) then return end
e:Clear()
 local g = net.ReadBool()
 if !g then 
     e.IsLoaded = true
     local h = math.Clamp(ScrW() / 3840, 0.5, 1)
     local i = 'ui.' .. math.floor(h * 40)
     e.InviteSection = ui.Create('ui_scrollpanel', e)
     e.InviteSection:SetPadding(-1)
     e.InviteSection.Paint = function(j, k, l)
         draw.Outline(0, 0, k, l, ui.col.Outline)
     end
     e.InviteSection:SetPos(0, 0)
     e.InviteSection:SetSize(h * 516, e:GetTall())
     e.InviteSection:AddItem(ui.Create('ui_button', function(j)
         j:SetText('Ожидающие приглашения')
         j:SetTall(ui.SpacerHeight)
         j:SetDisabled(true)
     end))
     for n = 1, net.ReadUInt(4) do 
     --    local o = net.ReadUInt(14)
         local p = net.ReadString()
         e.InviteSection:AddItem(ui.Create('ui_panel', function(j)
             j:SetTall(h * 138)
             local q = ui.Create('DLabel', function(r)
                 r:SetText(p)
                 r:SetFont(i)
                 r:SizeToContents()
                 r:SetPos(h * 128 + 5, 5)
             end, j)
             local s = ui.Create('ui_panel', function(t)
                 t:SetSize(j:GetTall() - 10, j:GetTall() - 10)
                 t:SetPos(5, 5)
                 t.Paint = function(t, k, l)
                     local u = surface.GetWeb('https://i.imgur.com/' .. LocalPlayer():GetNetVar('OrgBanner'))
                     if u and (not u:IsError()) then 
                         surface.SetMaterial(u)
                         surface.SetDrawColor(255, 255, 255)
                         surface.DrawTexturedRect(0, 0, k, l)
                     end 
                 end 
             end, j)
             local v = (e.InviteSection:GetWide() - s:GetWide() - 20) * 0.5
             local w = ui.Create('ui_button', function(x)
                 x.fontset = true
                 x:SetFont(i)
                 x:SetText("Отклонить")
                 x:SetSize(v, j:GetTall() - 15 - q:GetTall())
                 x:SetPos(e.InviteSection:GetWide() - x:GetWide() - 5, j:GetTall() - x:GetTall() - 5)
                 x.DoClick = function()
                     j:Remove()
                     net.Start('rp.OrgInviteResponse')
                         net.WriteBool(false)
                     net.SendToServer()
                 end 
             end, j)
             local y = ui.Create('ui_button', function(x)
                 x.fontset = true
                 x:SetFont(i)
                 x:SetText("Принять")
                 x:SetSize(w:GetSize())
                 x:SetPos(e.InviteSection:GetWide() - x:GetWide() - w:GetWide() - 10, j:GetTall() - x:GetTall() - 5)
                 x.DoClick = function()
                     e.InviteSection:Reset()
                     net.Start('rp.OrgInviteResponse')
                         net.WriteString(p)
                         net.WriteBool(true)
                     net.SendToServer()
                 end 
             end, j)
         end))
     end
     e.CreateSection = ui.Create('ui_scrollpanel', e)
     e.CreateSection:SetPadding(-1)
     e.CreateSection.Paint = function(j, k, l)
         draw.Outline(0, 0, k, l, ui.col.Outline)
     end
     e.CreateSection:SetPos(e.InviteSection:GetWide() - 1, 0)
     e.CreateSection:SetSize(e:GetWide() - e.InviteSection:GetWide() + 1, e:GetTall())
     e.CreateSection:AddItem(ui.Create('ui_button', function(j)
         j:SetText('Создать новую организацию')
         j:SetTall(ui.SpacerHeight)
         j:SetDisabled(true)
     end))
     e.CreateSection:AddItem(ui.Create('Panel', function(z)
         z:SetTall(3)
     end))
     local A = string.Wrap('ui.24', a .. rp.FormatMoney(rp.cfg.OrgCost) .. b .. rp.FormatMoney(rp.cfg.OrgRenameCost) .. c, e.CreateSection:GetWide() * 0.85)
     for B, C in ipairs(A) do 
         e.CreateSection:AddItem(ui.Create('DLabel', function(D)
             D:SetText(C)
             D:SetFont('ui.24')
             D:SetContentAlignment(5)
             D:SetTall(27)
         end))
     end
     local E = ui.Create('ui_button', function(j)
         j:SetText('Создать!')
         j:SetSize(e.CreateSection:GetWide() - 10, 30)
         j:SetPos(5, e.CreateSection:GetTall() - 35)
         j.DoClick = function()
             ui.StringRequest('Создать организацию', 'Вы не состоите в организации. Вы хотите создать её за ' .. rp.FormatMoney(rp.cfg.OrgCost) .. '?\n Введите название вашей организации, чтобы продолжить.', '', function(F)
                 cmd.Run('createorg', F)
                 d:Close()
             end)
         end 
     end, e.CreateSection)
     return 
 end
 local k, l = ScrW() * 0.55, ScrH() * 0.525
 local G = LocalPlayer():GetOrgData()
 if !G then 
     rp.Notify(NOTIFY_ERROR, 'Unknown error.')
 end
 local H = G.Rank
 local I = G.MoTD
 local J = G.Perms
 f = ui.Create('DPanel', function(j)
     j:SetPos(5, 5)
     j:SetSize(e:GetWide() - 10, e:GetTall() - 10)
     j.Paint = function() end
     j.OrgMembers = {}
     j.OrgRanks = {}
     j.OrgRankRef = {}
     j.F4Frame = d -- комент строки
 end, e)
 local K = f.OrgMembers
 local L = f.OrgRanks
 local M = f.OrgRankRef
 local N = 0
 local data = net.ReadTable()
 for n = 1, #data do 
     local O = data[n].RankName
     local P = data[n].Weight
     local Q = data[n].Invite
     local R = data[n].Kick
     local H = data[n].Rank
     local I = data[n].MoTD
     local s = true
     -- local S = net.ReadBool()
     -- local T = net.ReadBool()
     -- local U = net.ReadBool()
     L[#L + 1] = {
         Name = O,
         Weight = P,
         Invite = Q,
         Kick = R,
         Rank = H,
         MoTD = I,
         Flag = s
     --    Withdraw = S,
     --    InvWithdraw = T,
     --    Manage = U
     }
     M[O] = L[#L]
 end
 table.SortByMember(L, 'Weight')
 local ttt = net.ReadTable()
 local seenSteamIDs = {} -- ИСПРАВЛЕНИЕ: проверка на дубликаты
 for n = 1, #ttt do 
     local V = ttt[n].SteamID
     
     -- ИСПРАВЛЕНИЕ: пропускаем дубликаты по SteamID
     if seenSteamIDs[V] then continue end
     seenSteamIDs[V] = true
     
     local p = ttt[n].Name
     local H = ttt[n].Rank
     -- онлайн ли участник. Раньше здесь вызывался player.GetBySteamID64(U) с несуществующей переменной U,
     -- а сама функция падает на клиентах без player.Iterator ("attempt to call field 'Iterator'")
     local W
     for _, onlinePl in ipairs(player.GetAll()) do
         if IsValid(onlinePl) and (onlinePl:SteamID64() == tostring(V)) then
             W = onlinePl
             break
         end
     end
     local X = os.time() - ttt[n].lastseen
     if X == os.time() then 
         X = 0 
     end
     if !M[H] then 
         print("Glitched member: " .. V .. " rank " .. H .. " doesnt exist! Assuming lowest")
         H = L[#L].Name 
     end
     if W then 
         N = N + 1 
     end
     local P = M[H].Weight
     K[#K + 1] = {
         SteamID = V,
         Name = p,
         Rank = H,
         Weight = P,
         IsOnline = W,
         LastConnect = X
     }
 end
 local Y = net.ReadUInt(32)
 local Z = net.ReadUInt(12)
 local _ = {}
 for n = 1, net.ReadUInt(8) do 
     _[net.ReadString()] = net.ReadUInt(12)
 end
 local Y = 1
 local Z = 1
 local _ = {}
 for n = 1, 1 do
     _['sd'] = 2
 end
 f.Perms = J
 f.MOTD = I
 f.Funds = Y
 f.InventorySpace = Z
 f.Inventory = _
 e.IsLoaded = true
 function f:NotifyRankRename(a0, a1)
     for _, member in ipairs(K) do 
         if member.Rank == a0 then 
             member.Rank = a1 
         end 
     end
     M[a1] = M[a0]
     M[a0] = nil
     self:PopulateMembers()
 end
 function f:NotifyRankRemoved(p)
     M[p] = nil
     local a2
     for rankIdx, rankData in ipairs(L) do 
         if rankData.Name == p then 
             a2 = L[rankIdx + 1]
             table.remove(L, rankIdx)
             break 
         end 
     end
     for _, member in ipairs(K) do 
         if member.Rank == p then 
             member.Rank = a2.Name 
         end 
     end
     f.PopulateMembers()
 end
 f.AddControls = function()
     if IsValid(f.btnQuit) then 
         f.btnQuit:Show()
         return 
     end
     f.btnQuit = ui.Create('ui_button', function(self)
         self:SetText(J.Owner and 'Распустить' or 'Выйти')
         self:SizeToContents()
         self:SetSize(self:GetWide() + 10, d.btnClose:GetTall())
         self:SetPos(d.btnClose.x - self:GetWide() + 1, 0)
         self.Corners = {true, false, true, false}
         self.DoClick = function(j)
             local a3 = J.Owner and 'Распустить организацию?' or 'Покинуть организацию?'
             local a4 = J.Owner and 'Вы уверены, что хотите распустить ' .. LocalPlayer():GetOrg() .. '?\nВведите DISBAND в поле ниже.' or 'Вы уверены, что хотите покинуть ' .. LocalPlayer():GetOrg() .. '?\nВведите QUIT в поле ниже.'
             ui.StringRequest(a3, a4, '', function(F)
                 local a5 = J.Owner and F:lower() == 'disband' or !J.Owner and F:lower() == 'quit'
                 if a5 then 
                     d:Close()
                     net.Ping('rp.QuitOrg')
                 end 
             end)
         end 
     end, d)
 end
 function f.HideControls()
     f.btnQuit:Hide()
 end
 f.AddControls()
 f.colLeft = ui.Create('Panel', function(self)
     self:SetWide(math.max(220, k * .2))
     self:Dock(LEFT)
 end, f)
 f.lblName = ui.Create('ui_button', function(self)
     self:SetText(LocalPlayer():GetOrg())
     self:SetTall(ui.SpacerHeight)
     self:Dock(TOP)
     self.Corners = {true, true, false, false}
     self:SetDisabled(true)
     self:SetCursor('arrow')
     if J.Owner then 
         self.btnRename = ui.Create('ui_button', function(x)
             x:Dock(RIGHT)
             x:DockMargin(0, 3, 3, 3)
             x:SetWide(30)
             x:SetFont('ForkAwesome')
             x:SetText(utf8.char(0xf040))
             x:SetTooltip'Переименовать Организацию'
             x:SetContentAlignment(4)
             x:SetTextInset(9, 1)
             x.DoClick = function(x)
                 if !LocalPlayer():CanAfford(rp.cfg.OrgRenameCost) then 
                     rp.Notify(NOTIFY_ERROR, term.GetString(term.Get("CannotAfford")))
                     return 
                 end
                 local a6, a7, a8
                 a6 = function(a9)
                     a9 = a9 and a9 .. "\n\n" or ""
                     ui.StringRequest('Переименовать ' .. LocalPlayer():GetOrg(), a9 .. 'Как бы вы хотели назвать свою организацию?\nЭто будет стоить ' .. rp.FormatMoney(rp.cfg.OrgRenameCost) .. ".", LocalPlayer():GetOrg(), function(F)
                         a7(F)
                     end)
                 end
                 a7 = function(p)
                     p = string.Trim(p)
                     a8 = p
                     if p == LocalPlayer():GetOrg() then 
                         a6("Это уже название вашей организации.")
                         return 
                     end
                     net.Start("rp.SetOrgName")
                         net.WriteString(p)
                     net.SendToServer()
                 end
                 a6()
                 net("rp.SetOrgNameResponse", function(aa)
                     if !IsValid(f) then return end
                     local ab = net.ReadBool()
                     local ac = net.ReadTerm()
                     if !ab then 
                         a6(ac)
                     else 
                         f.lblName:SetText(a8)
                     end
                     rp.Notify(NOTIFY_GENERIC, ac)
                 end)
             end 
         end, self)
     end 
 end, f.colLeft)
 f.pnlFlag = ui.Create('org_flag', function(self)
     self:Dock(TOP)
     self:SetPermissions(J)
 end, f.colLeft)
 f.bottomLeftContainer = ui.Create('Panel', function(self)
     self:Dock(FILL)
 end, f.colLeft)
 f.bottomLeftContainerLabels = ui.Create('Panel', function(self)
     self:Dock(TOP)
     self:SetTall(ui.SpacerHeight)
 end, f.bottomLeftContainer)
 f.lblRanks = ui.Create('ui_button', function(self)
     self:SetText("Ranks")
     self:SetDisabled(true)
     self:SetCursor('arrow')
     self:Dock(TOP)
     self:SetTall(ui.SpacerHeight)
     self.Corners = {true, true, false, false}
     if J.Owner then 
         self.btnAdd = ui.Create('ui_button', function(x)
             x:Dock(RIGHT)
             x:DockMargin(0, 3, 3, 3)
             x:SetWide(30)
             x:SetFont('ForkAwesome')
             x:SetText(utf8.char(0xf067))
             x:SetTooltip'Добавить Ранг'
             x:SetContentAlignment(4)
             x:SetTextInset(9, 2)
             x.DoClick = function(x, a9)
                 ui.StringRequest('Название Ранга', (a9 or '') .. ' Как бы вы хотели назвать этот ранг?', '', function(F)
                     F = string.Trim(F or '')
                     if #F == 0 then 
                         x:DoClick(term.GetString(term.Get('OrgRankNameLength')))
                     elseif M[F] != nil then 
                         x:DoClick(term.GetString(term.Get('OrgRankNameTaken')))
                     else 
                         local ad = {
                             Name            = F,
                             Weight          = 2,
                             Invite          = 0,
                             Kick            = 0,
                             Rank            = 0,
                             MoTD            = 0
                             -- Banner          = false,
                             -- Withdraw        = false,
                             -- InvWithdraw     = false,
                             -- Manage          = false
                         }
                         net.Start("rp.AddEditOrgRank")
                             net.WriteBool(true)
                             net.WriteTable(ad)
                         net.SendToServer()
                         if #L < rp.cfg.OrgMaxRanks then 
                             M[ad.Name] = L[table.insert(L, ad)]
                         end
                         f.ReorderRanks(ad.Name)
                     end 
                 end)
             end 
         end, self)
     end 
 end, f.bottomLeftContainerLabels)
 f.listRank = ui.Create('ui_scrollpanel', function(self)
     self:Dock(FILL)
     self:SetSpacing(1)
     self:SetPadding(0)
 end, f.bottomLeftContainer)
 f.colMid = ui.Create('Panel', function(self)
     self:SetWide(math.max(220, k * .35))
     self:DockMargin(5, 0, 5, 0)
     self:Dock(LEFT)
 end, f)
 f.colMidOptCont = ui.Create('Panel', function(self)
     self:Dock(TOP)
     self:SetTall(ui.SpacerHeight * 2)
     self.Paint = function(j, k, l)
         draw.RoundedBoxEx(4, 0, 0, k, l, ui.col.FlatBlack, true, true, false, false)
     end 
 end, f.colMid)
 f.lblMem = ui.Create('ui_button', function(self)
     self:SetText('Участники Онлайн: ' .. N .. '/' .. #K)
     self:SetTall(ui.SpacerHeight)
     self:SetDisabled(true)
     self:Dock(TOP)
     self:SetCursor('arrow')
     self.Corners = {true, true, false, false}
     if J.Invite then 
         self.btnAdd = ui.Create('ui_button', function(x)
             x:Dock(RIGHT)
             x:DockMargin(0, 3, 3, 3)
             x:SetWide(30)
             x:SetFont('ForkAwesome')
             x:SetText(utf8.char(0xf067))
             x:SetTooltip'Пригласить игроков'
             x:SetContentAlignment(4)
             x:SetTextInset(9,2)
             x.DoClick = function(x, a9)
                 if IsValid(f.overMemInv) then 
                     self:SetText('Участники Онлайн: ' .. N .. '/' .. #K)
                     x:SetText(utf8.char(0xf067))
                     x:SetTooltip'Пригласить игроков'
                     x:SetTextInset(9, 2)
                     x:SetBackgroundColor(nil)
                     f.overMemInv:Remove()
                 else 
                     self:SetText("Пригласить игроков (" .. rp.FormatMoney(rp.cfg.OrgInviteCost) .. ")")
                     x:SetText(utf8.char(0xf00d))
                     x:SetTooltip(nil)
                     x:SetTextInset(10, 1)
                     x:SetBackgroundColor(ui.col.Red)
                     f.overMemInv = ui.Create('ui_playerrequest', function(ae)
                         ae:SetPos(f.listMem.x, f.lblMem:GetTall())
                         ae:SetSize(f.listMem:GetSize())
                         ae:SetPlayers(table.Filter(player.GetAll(), function(C)
                             return !C:GetOrg()
                         end))
                         ae.OnSelection = function(self, af, ag)
                             if LocalPlayer():CanAfford(rp.cfg.OrgInviteCost) then 
                                 net.Start('rp.OrgInvite')
                                     net.WritePlayer(ag)
                                 net.SendToServer()
                                 af:Remove()
                             else 
                                 rp.Notify(NOTIFY_ERROR, term.GetString(term.Get('CannotAfford')))
                             end 
                         end
                         ae.Paint = function(ae, k, l)
                             surface.SetDrawColor(51, 51, 51)
                             surface.DrawRect(0, 0, k, l)
                             derma.SkinHook('Paint', 'Frame', self, k, l)
                         end 
                     end, f.colMid)
                 end 
             end 
         end, self)
     end 
 end, f.colMidOptCont)
 f.colMidOptFilterCont = ui.Create('Panel', function(self)
     self:Dock(TOP)
     self:SetTall(ui.ButtonHeight)
     self:DockMargin(5, 0, 5, 5)
 end, f.colMidOptCont)
 f.memFilter = ui.Create('DComboBox', function(self)
     self:SetSortItems(false)
     self:Dock(LEFT)
     self:DockMargin(0, 0, 5, 0)
     self:SetWide(100)
     self:AddChoice('Все', nil, true)
     for rankIdx, rankData in pairs(L) do 
         self:AddChoice(rankData.Name, rankData.Name)
     end
     self.OnSelect = function(j, ah, ai, aj)
         local ak = f.memSearch:GetValue()
         f.listMem:Search(ak == '' and 0 or ak)
     end 
 end, f.colMidOptFilterCont)
 f.memSearch = ui.Create('DTextEntry', function(self)
     self:SetPlaceholderText('Поиск...')
     self:Dock(FILL)
     self.OnChange = function(j)
         local ak = f.memSearch:GetValue()
         f.listMem:Search(ak == '' and 0 or ak)
     end 
 end, f.colMidOptFilterCont)
 f.listMem = ui.Create('ui_listview', function(self)
     self:Dock(FILL)
     self:SetSpacing(1)
     self:SetPadding(0)
     self.FilterSearchResult = function(j, af, ai)
         local al, am = f.memFilter:GetSelected()
         if ai == 0 then 
             return am == nil and true or af.Player != nil and af.Player.Rank == am 
         end
         ai = ai:lower()
         return af.Player != nil and (am == nil or af.Player.Rank == am) and (ai == 0 and af.Player.Name:lower():Contains(ai) or af.Player.SteamID:Contains(ai) or af.Player.SteamID32:Contains(ai))
     end 
 end, f.colMid)
 f.colRightTop = ui.Create('Panel', function(self)
     self:SetTall(ui.SpacerHeight)
     self:Dock(TOP)
     self.PerformLayout = function(self)
         local k = self:GetWide()
         local an = self:GetChildren()
         if #an == 0 then return end
         local ao = k - (#an - 1) * 5
         local ap = ao / #an
         for childIdx, child in ipairs(an) do 
             child:SetWide(ap)
             if childIdx < #an then 
                 child:DockMargin(0, 0, 5, 0)
             end 
         end 
     end 
 end, f)
 f.colRight = ui.Create('Panel', function(self)
     self:Dock(FILL)
 end, f)
 local aq = {
     {
         'MOTD',
         'org_motd'
     },
     {
        'Bank',
         'org_bank'
     },
     {
         'Audit Logs(Скоро)',
         'org_audit_log'
     },
     {
         'Настройки',
         'org_settings',
         'Owner'
     }
 }
 local ar = {}
 for tabIdx, tabData in ipairs(aq) do 
     if tabData[3] != nil and J[tabData[3]] != true then continue end
     tabData.Button = ui.Create('ui_button', function(self)
         self:SetText(tabData[1])
         self:Dock(LEFT)
         self:SetCursor('arrow')
         self.Corners = {true, true, false, false}
         self.DoClick = function(self)
             for n, D in ipairs(aq) do 
                 if D.Panel == nil then continue end
                 D.Panel:SetVisible(n == tabIdx)
                 D.Button:SetDisabled(n == tabIdx)
                 if n == tabIdx then 
                     D.Panel:OnOpen()
                 else 
                     D.Panel:OnClose()
                 end 
             end 
         end 
     end, f.colRightTop)
     tabData.Panel = ui.Create(tabData[2], function(self)
         self:SetOrgMenu(f)
         self:SetTabElement(tabData.Button)
         self:Dock(FILL)
         self:SetVisible(false)
     end, f.colRight)
     ar[tabData[1]] = tabData 
 end
 aq[1].Button:DoClick()
 local as = {}
 local at = {}
 f.CalculateMemberNumbers = function()
     table.SortByMember(K, 'Weight')
     table.Empty(as)
     table.Empty(at)
     local au = ''
     for _, member in ipairs(K) do 
         if member.Rank != au then 
             at[#at + 1] = {
                 Name = member.Rank,
                 Members = {}
             }
             au = member.Rank 
         end
         table.insert(at[#at].Members, member)
     end
     for _, rankGroup in ipairs(at) do 
         as[rankGroup.Name] = #rankGroup.Members 
     end 
 end
 f.PopulateMembers = function(av)
     f.CalculateMemberNumbers()
     f.listMem:Reset(true)
     for rankIdx, rankData in ipairs(at) do 
         local headerBtn = ui.Create('ui_button', function(x)
             x:SetTall(ui.SpacerHeight)
             x:SetCursor('arrow')
             x:SetText(rankData.Name)
             x:SetDisabled(true)
             f.listMem:AddCustomRow(x) -- f.listMem:AddItem(x)
         end)
         table.SortByMember(rankData.Members, 'Name', true)
         for memIdx, memberData in ipairs(rankData.Members) do 
             local memberEntry = ui.Create('org_member_entry', function(ax)
                 ax:SetOrgMenu(f)
                 ax:SetRanks(L)
                 ax:SetPermissions(J)
                 ax:SetPlayer(memberData)
                 f.listMem:AddCustomRow(ax) -- f.listMem:AddItem(ax)
             end)
         end 
     end 
 end
 f.PopulateMembers()
 f.ReorderRanks = function(ay)
     table.SortByMember(L, 'Weight')
     for rankIdx, rankData in ipairs(L) do 
         local az = rankIdx == 1 and 100 or rankIdx == #L and 1 or 100 - math.floor((rankIdx - 1) / (#L - 1) * 100)
         rankData.Weight = az 
     end
     f.PopulateRanks()
     if ay != nil then 
         timer.Simple(0, function()
             M[ay].Btn:Toggle()
         end)
     end 
 end
 f.PopulateRanks = function()
     f.CalculateMemberNumbers()
     f.listRank:Reset(true)
     for rankIdx, rankData in ipairs(L) do 
         local aA = ui.Create('org_rank_entry', function(self)
             self:SetOrgMenu(f)
             self:SetRank(rankData)
             self:SetRankReferences(M)
             self:SetPlayerCount(as[rankData.Name] or 0)
             f.listRank:AddItem(self)
         end, f.listRank)
         rankData.Btn = aA
         rankData.Number = rankIdx 
     end 
 end
 f.PopulateRanks()
 f.ReassignRankPlayerCounts = function()
     for rankIdx, rankData in ipairs(L) do 
         rankData.Btn:SetPlayerCount(as[rankData.Name] or 0)
     end 
 end
 f.PopulateMoTD = function(m)
     m = m or I
     aq[1].Panel:SetContent(m.Dark, m.Text)
 end
 f.PopulateMoTD()
 net('rp.OrgInventoryLiveUpdate', function(aa)
     f.InventorySpace = net.ReadUInt(12)
     f.Inventory = {}
     for n = 1, net.ReadUInt(8) do 
         f.Inventory[net.ReadString()] = net.ReadUInt(12)
     end
     ar['Bank'].Panel:UpdateOrgInventory()
 end)
end)
hook('F4TabChanged', function(aB)
if aB == e and IsValid(f) then
f.AddControls()
elseif IsValid(f) then
f.HideControls()
end
end)
hook('PopulateF4Tabs', function(aC, aD)
if F4Buttons and F4Buttons.Orgs and not F4Buttons.Orgs.enabled then return end
local x
x = aC:AddTab('Организации', function(self)
     if F4Buttons and F4Buttons.Orgs and F4Buttons.Orgs.disabled then return end
     d = aD
     e = ui.Create'DPanel'
     e.PaintOver = function(self, k, l)
         if not self.IsLoaded then
             local aE = SysTime() * 5
             draw.NoTexture()
             surface.SetDrawColor(255, 255, 255)
             surface.DrawArc(k * 0.5, l * 0.5, 41, 46, aE * 80, aE * 80 + 180, 20)
         end
     end
     net.Ping("rp.OrgsMenu")
     return e
 end)
 x:SetIcon('sup/gui/generic/group.png')
 if F4Buttons and F4Buttons.Orgs and F4Buttons.Orgs.disabled then x:SetAlpha(120) x:SetCursor('no') end
 -- Картинка организации скачивается с imgur асинхронно. Раньше сразу подставлялся материал "error"
 -- (фиолетово-чёрная клетка) и больше не обновлялся. Теперь стоит стандартная иконка группы,
 -- а когда картинка загрузилась - она подменяется на флаг организации.
 local oldThink = x.Think
 x.Think = function(s, ...)
     if oldThink then oldThink(s, ...) end
     local lp = LocalPlayer()
     if not IsValid(lp) or not lp:GetOrg() or not s.m_Image then return end
     local banner = lp:GetNetVar('OrgBanner')
     if not banner or banner == '' then return end
     local mat = surface.GetWeb('https://i.imgur.com/' .. banner)
     if mat and (not mat:IsError()) and (s.OrgIconMat ~= mat) then
         s.OrgIconMat = mat
         s.m_Image:SetMaterial(mat)
     end
 end
end)
function rp.orgs.GetBanner(s)
if isplayer(s) then
return surface.GetWeb('https://i.imgur.com/' .. s:GetNetVar('OrgBanner'))
else
for _, p in ipairs(player.GetAll()) do
if p:GetOrg() != nil and p:GetOrg() == s then
s = p
break
end
end
    return surface.GetWeb('https://i.imgur.com/' .. s:GetNetVar('OrgBanner') or '')
end
end
function rp.orgs.LoadBanner()
end
function rp.orgs.OrgRequest(aJ, aK)
if isfunction(aJ) then
aK = aJ
aJ = nil
end
local f = ui.Create('ui_frame', function(self)
     self:SetTitle('Выберите организацию')
     self:SetSize(.2, .3)
     self:Center()
     self:MakePopup()
 end)
 ui.Create('ui_playerrequest', function(self, z)
     self:DockToFrame()
     self.PlayerList.AddPlayers = function(j, aL)
         aL = aL and aL:Trim()
         j:Reset()
         local aM = 0
         for orgIdx, orgData in ipairs(aJ) do
             if not aL or aL and string.find(orgData.Name:lower(), aL:lower(), 1, true) then
                 local x = j:AddImageRow(orgData)
                 x:SetText(orgData.Name)
                 x:SetColor(orgData.Color)
                 x:SetMaterial(rp.orgs.GetBanner(orgData.Name))
                 x.DoClick = function(af)
                     self:OnSelection(af, orgData.Name)
                 end
                 aM = aM + 1
             end
         end
         if aM <= 0 then
             j:AddSpacer('Организации не найдены!')
         end
     end
     self.PlayerList:Reset()
     self.PlayerList:AddPlayers()
     self.OnSelection = function(self, af, ag)
         f:Close()
         aK(ag)
     end
 end, f)
 f:Focus()
 return m
end
net('rp.OrgBannerInvalidate', function(aa)
local aF = net.ReadString()
rp.orgs.Banners[aF] = nil
hook.Call('InvalidateOrgBanner', nil, aF)
end)