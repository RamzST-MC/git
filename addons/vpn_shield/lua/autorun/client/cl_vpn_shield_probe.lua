-- ItsNoctarius

if not CLIENT then return end

local function sendProbeResult(token, tbl)
	net.Start("vpnshield_probe_result")
		net.WriteString(token or "")
		net.WriteString(util.TableToJSON(tbl or {}, false) or "{}")
	net.SendToServer()
end

net.Receive("vpnshield_probe_request", function()
	local token = net.ReadString()
	if token == "" then return end

	local sent = false
	local function done(payload)
		if sent then return end
		sent = true
		sendProbeResult(token, payload)
	end

	local panel = vgui.Create("DHTML")
	if not IsValid(panel) then
		done({ok = false, error = "dhtml panel create failed"})
		return
	end

	panel:SetSize(0, 0)
	panel:SetAlpha(0)
	panel:SetMouseInputEnabled(false)
	panel:SetKeyboardInputEnabled(false)
	panel:SetVisible(false)

	panel:AddFunction("gmod", "SendResult", function(payloadJson)
		local parsed = util.JSONToTable(payloadJson or "")
		if not istable(parsed) then
			done({ok = false, error = "bad dhtml payload"})
		else
			done(parsed)
		end

		if IsValid(panel) then
			panel:Remove()
		end
	end)

	panel:SetHTML("<html><body></body></html>")

	timer.Simple(0.25, function()
		if not IsValid(panel) or sent then return end
		panel:QueueJavascript([[
			(async function() {
				try {
					const response = await fetch("https://api.ipify.org?format=json", { cache: "no-store" });
					const json = await response.json();
					gmod.SendResult(JSON.stringify({ ok: true, ip: (json && json.ip) ? String(json.ip) : "" }));
				} catch (e) {
					gmod.SendResult(JSON.stringify({ ok: false, error: String(e) }));
				}
			})();
		]])
	end)

	timer.Simple(8, function()
		if sent then return end
		done({ok = false, error = "dhtml timeout"})
		if IsValid(panel) then
			panel:Remove()
		end
	end)
end)
