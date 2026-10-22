-- "addons\\cosmic\\lua\\dash\\libraries\\client\\outline.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
outline = {}

outline.MODE_BOTH = 0
outline.MODE_NOTVISIBLE = 1
outline.MODE_VISIBLE = 2
outline.RENDERTYPE_BEFORE_VM = 0
outline.RENDERTYPE_BEFORE_EF = 1
outline.RENDERTYPE_AFTER_EF = 2

local istable = istable
local render = render
local Material = Material
local CreateMaterial = CreateMaterial
local hook = hook
local cam = cam
local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid
local surface = surface

local outlines, outlineCount = {}, 0
local currentEntity = NULL
local currentRenderType = outline.RENDERTYPE_AFTER_EF
local currentThickness = 1
local screenEffectTexture1 = render.GetScreenEffectTexture(0)
local screenEffectTexture2 = render.GetScreenEffectTexture(1)

local materialParams = {
    ["$basetexture"] = screenEffectTexture2:GetName(),
    ["$ignorez"] = 1,
    ["$alphatest"] = 1
}

local materialPPCopy = Material("pp/copy")
local materialOutline = CreateMaterial("outline", "UnlitGeneric", materialParams)
local renderOrderBeforeVM, renderOrderBeforeEF, renderOrderAfterEF = 1, 2, 3

function outline.Add(entities, color, mode)
    if outlineCount >= 255 then return end

    if not istable(entities) then
        entities = {entities}
    end

    if entities[1] == nil then return end

    if mode ~= outline.MODE_BOTH and mode ~= outline.MODE_NOTVISIBLE and mode ~= outline.MODE_VISIBLE then
        mode = outline.MODE_BOTH
    end

    local newOutline = {
        [renderOrderBeforeVM] = entities,
        [renderOrderBeforeEF] = color,
        [renderOrderAfterEF] = mode
    }

    outlineCount = outlineCount + 1
    outlines[outlineCount] = newOutline
end

function outline.RenderedEntity()
    return currentEntity
end

function outline.SetRenderType(renderType)
    if renderType ~= outline.RENDERTYPE_BEFORE_VM and renderType ~= outline.RENDERTYPE_BEFORE_EF and renderType ~= outline.RENDERTYPE_AFTER_EF then
        return
    end

    local previousRenderType = currentRenderType
    currentRenderType = renderType

    return previousRenderType
end

function outline.GetRenderType()
    return currentRenderType
end

function outline.SetDoubleThickness(doubleThickness)
    local previousThickness = currentThickness == 2
    currentThickness = doubleThickness and 2 or 1

    return previousThickness
end

function outline.IsDoubleThickness()
    return currentThickness == 2
end

local function RenderOutlines()
    local renderTarget = render.GetRenderTarget()
    render.CopyRenderTargetToTexture(screenEffectTexture1)
    local screenWidth, screenHeight = ScrW(), ScrH()
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SuppressEngineLighting(true)
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilCompareFunction(STENCIL_GREATER)
    render.SetStencilFailOperation(STENCIL_KEEP)
    cam.Start3D()
    render.SetBlend(1)

    for index = 1, outlineCount do
        local alphaValue = 0xFF - (index - 1)
        local line = outlines[index]
        local mode = line[renderOrderAfterEF]
        local entities = line[renderOrderBeforeVM]
        render.SetStencilReferenceValue(alphaValue)

        if mode == outline.MODE_BOTH or mode == outline.MODE_VISIBLE then
            render.SetStencilZFailOperation(mode == outline.MODE_BOTH and STENCIL_REPLACE or STENCIL_KEEP)
            render.SetStencilPassOperation(STENCIL_REPLACE)

            for entityIndex = 1, #entities do
                local entity = entities[entityIndex]

                if IsValid(entity) then
                    currentEntity = entity
                    entity:DrawModel()
                end
            end
        elseif mode == outline.MODE_NOTVISIBLE then
            render.SetStencilZFailOperation(STENCIL_REPLACE)
            render.SetStencilPassOperation(STENCIL_KEEP)

            for entityIndex = 1, #entities do
                local entity = entities[entityIndex]

                if IsValid(entity) then
                    currentEntity = entity
                    entity:DrawModel()
                end
            end

            render.SetStencilCompareFunction(STENCIL_EQUAL)
            render.SetStencilZFailOperation(STENCIL_KEEP)
            render.SetStencilPassOperation(STENCIL_ZERO)

            for entityIndex = 1, #entities do
                local entity = entities[entityIndex]

                if IsValid(entity) then
                    currentEntity = entity
                    entity:DrawModel()
                end
            end

            render.SetStencilCompareFunction(STENCIL_GREATER)
        end
    end

    currentEntity = NULL
    render.SetBlend(1)
    cam.End3D()
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.Clear(0, 0, 0, 0, false, false)
    cam.Start2D()

    for index = 1, outlineCount do
        local alphaValue = 0xFF - (index - 1)
        render.SetStencilReferenceValue(alphaValue)
        surface.SetDrawColor(outlines[index][renderOrderBeforeEF])
        surface.DrawRect(0, 0, screenWidth, screenHeight)
    end

    cam.End2D()
    render.SuppressEngineLighting(false)
    render.SetStencilEnable(false)
    render.CopyRenderTargetToTexture(screenEffectTexture2)
    render.SetRenderTarget(renderTarget)
    materialPPCopy:SetTexture("$basetexture", screenEffectTexture1)
    render.SetMaterial(materialPPCopy)
    render.DrawScreenQuad()
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(0)
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    materialOutline:SetTexture("$basetexture", screenEffectTexture2)
    render.SetMaterial(materialOutline)
    render.DrawScreenQuadEx(-currentThickness, -currentThickness, screenWidth, screenHeight)
    render.DrawScreenQuadEx(-currentThickness, 0, screenWidth, screenHeight)
    render.DrawScreenQuadEx(-currentThickness, currentThickness, screenWidth, screenHeight)
    render.DrawScreenQuadEx(0, -currentThickness, screenWidth, screenHeight)
    render.DrawScreenQuadEx(0, currentThickness, screenWidth, screenHeight)
    render.DrawScreenQuadEx(currentThickness, -currentThickness, screenWidth, screenHeight)
    render.DrawScreenQuadEx(currentThickness, 0, screenWidth, screenHeight)
    render.DrawScreenQuadEx(currentThickness, currentThickness, screenWidth, screenHeight)
    render.SetStencilEnable(false)
    render.ClearDepth()
end

local function SetupOutlines(addFunction)
    hook.Run("SetupOutlines", addFunction)
    if outlineCount == 0 then return end
    RenderOutlines()
    outlines, outlineCount = {}, 0
end

hook.Add("PreDrawViewModels", "RenderOutlines", function()
    if currentRenderType == outline.RENDERTYPE_BEFORE_VM then
        SetupOutlines(outline.Add)
    end
end)

hook.Add("PreDrawEffects", "RenderOutlines", function()
    if currentRenderType == outline.RENDERTYPE_BEFORE_EF then
        SetupOutlines(outline.Add)
    end
end)

hook.Add("PostDrawEffects", "RenderOutlines", function()
    if currentRenderType == outline.RENDERTYPE_AFTER_EF then
        SetupOutlines(outline.Add)
    end
end)