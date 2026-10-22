-- ItsNoctarius

if not CLIENT then return end

VPNShield = VPNShield or {}
VPNShield.Config = VPNShield.Config or {}

include("vpn_shield/config.lua")

local container
local toastCount = 0

local function jsString(value)
	return string.JavascriptSafe(tostring(value or ""))
end

local function ensureContainer()
	if IsValid(container) then return container end

	container = vgui.Create("DHTML")
	if not IsValid(container) then return nil end

	container:SetSize(ScrW(), ScrH())
	container:SetPos(0, 0)
	container:SetMouseInputEnabled(false)
	container:SetKeyboardInputEnabled(false)
	container:SetZPos(32767)

	local html = [[
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
html, body {
	margin: 0;
	padding: 0;
	width: 100%;
	height: 100%;
	background: transparent;
	overflow: hidden;
}
#stack {
	position: fixed;
	left: 50%;
	bottom: 64px;
	transform: translateX(-50%);
	display: flex;
	flex-direction: column-reverse;
	gap: 12px;
}
.toast {
	position: relative;
	width: 460px;
	min-height: 74px;
	box-sizing: border-box;
	color: #e6eef7;
	border-radius: 12px;
	border: 1px solid rgba(255,255,255,0.08);
	backdrop-filter: blur(5px);
	background: linear-gradient(90deg, rgba(13,18,32,0.94), rgba(15,18,30,0.92));
	box-shadow: 0 10px 22px rgba(0,0,0,0.42);
	padding: 12px 14px 12px 18px;
	font-family: Segoe UI, Tahoma, sans-serif;
	transform: translateY(16px);
	opacity: 0;
	transition: transform 170ms ease, opacity 170ms ease;
}
.toast.show {
	transform: translateY(0);
	opacity: 1;
}
.toast.hide {
	transform: translateY(14px);
	opacity: 0;
}
.accent {
	position: absolute;
	left: 8px;
	top: 8px;
	bottom: 8px;
	width: 4px;
	border-radius: 4px;
}
.title {
	font-size: 22px;
	font-weight: 650;
	margin-left: 6px;
	line-height: 1.1;
	letter-spacing: 0.2px;
}
.text {
	margin-top: 5px;
	margin-left: 6px;
	font-size: 18px;
	line-height: 1.2;
	color: rgba(226,235,247,0.84);
}
</style>
</head>
<body>
	<div id="stack"></div>
	<script>
		window.vpnshieldNotify = function(title, text, variant, lifeMs) {
			const stack = document.getElementById("stack");
			const toast = document.createElement("div");
			toast.className = "toast";
			const accentColor = variant === "danger" ? "#f03f4d" : (variant === "ok" ? "#25c26e" : "#258cff");
			toast.innerHTML = '<div class="accent" style="background:' + accentColor + ';"></div>' +
				'<div class="title">' + title + '</div>' +
				'<div class="text">' + text + '</div>';
			stack.appendChild(toast);
			requestAnimationFrame(() => toast.classList.add("show"));

			setTimeout(() => {
				toast.classList.remove("show");
				toast.classList.add("hide");
				setTimeout(() => toast.remove(), 220);
			}, Math.max(1200, lifeMs));
		};
		window.vpnshieldSetLayout = function(bottom, gap, width, height) {
			const stack = document.getElementById("stack");
			stack.style.bottom = String(bottom) + "px";
			stack.style.gap = String(gap) + "px";
			const css = document.createElement("style");
			css.textContent = ".toast{width:" + String(width) + "px;min-height:" + String(height) + "px;}";
			document.head.appendChild(css);
		};
	</script>
</body>
</html>
]]

	container:SetHTML(html)
	return container
end

local function showNotify(title, text, variant, life)
	local pnl = ensureContainer()
	if not IsValid(pnl) then return end

	local notifyCfg = VPNShield.Config.Notify or {}
	local bottom = tonumber(notifyCfg.BottomMargin) or 64
	local gap = tonumber(notifyCfg.Gap) or 12
	local width = tonumber(notifyCfg.Width) or 520
	local height = tonumber(notifyCfg.Height) or 74
	local lifeMs = math.floor((tonumber(life) or tonumber(notifyCfg.LifeTime) or 6) * 1000)

	pnl:QueueJavascript(string.format(
		"vpnshieldSetLayout(%d,%d,%d,%d); vpnshieldNotify('%s','%s','%s',%d);",
		bottom,
		gap,
		width,
		height,
		jsString(title),
		jsString(text),
		jsString(variant),
		lifeMs
	))

	toastCount = toastCount + 1
	local removeAfter = (lifeMs / 1000) + 0.5
	timer.Simple(removeAfter, function()
		toastCount = math.max(0, toastCount - 1)
		if toastCount == 0 and IsValid(container) then
			container:Remove()
			container = nil
		end
	end)
end

net.Receive("vpnshield_notify", function()
	local title = net.ReadString()
	local text = net.ReadString()
	local variant = net.ReadString()
	local life = net.ReadFloat()

	if VPNShield.Config.Notify and VPNShield.Config.Notify.Enabled == false then return end
	showNotify(title, text, variant, life)
end)
