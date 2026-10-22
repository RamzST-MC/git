hook('InitPostEntity', function()
    local spawnlist     = {}
    spawnlist.name      = 'Mercury Whitelist'
    spawnlist.id        = math.random(1000, 9999)
    spawnlist.icon      = 'icon16/brick.png'
    spawnlist.parentid  = 0
    spawnlist.version   = 3
    spawnlist.contents  = {}
    for k, v in ipairs(whitelistprops) do
        if (mdl ~= '') then
            spawnlist.contents[#spawnlist.contents + 1] = {type = 'model', model = v}
        end
    end
    spawnmenu.AddPropCategory('', spawnlist.name, spawnlist.contents, spawnlist.icon, spawnlist.id, 0)
    RunConsoleCommand('spawnmenu_reload')
end)