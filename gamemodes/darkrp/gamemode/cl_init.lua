include 'sh_init.lua'

surface.CreateFont('3d2d',{font = 'Montserrat',size = 130,weight = 1700,shadow = true, antialias = true})
surface.CreateFont('Trebuchet22', {size = 22,weight = 500,antialias = true,shadow = false,font = 'roboto'})
surface.CreateFont('PrinterSmall', {font = 'roboto', size = 50, weight = 500,})

hook('InitPostEntity', function()
    local c = LocalPlayer()
    c:ConCommand('stopsound')
end)

do
	local IsExists, CreateDir, cachedMats, Fetch, CRC, Write, Read, format, sub = file.Exists, file.CreateDir, {}, http.Fetch, util.CRC, file.Write, file.Read, string.format, string.sub

	local _PATH, PATH, Material = 'data/surfTextures/%s.png', 'GAME', Material
	local ERROR = Material 'error'

	CreateDir 'surfTextures'

	local function checkRel(link, aSum)
		local uName = format(_PATH, aSum)
		local dat = Read(uName, PATH) or ''
		cachedMats[link] = ERROR
		Fetch(link, function(res)
			local crcRes = CRC(res)
			local oldRes = CRC(dat)
			if crcRes ~= oldRes then
				Write( sub(uName,6), res)
				print( format('EM > CheckSum Updated (%s, %s)', crcRes, oldRes) )
			end
			local mat = Material(uName)
			cachedMats[link] = mat
			return mat
		end)
	end

	function surface.GetWeb( link )
		if cachedMats[link] then return cachedMats[link] end

		local checkSum = CRC(link)
		return checkRel(link, checkSum) or ERROR
	end

	function surface.GetWebCache()
		return cachedMats
	end
end