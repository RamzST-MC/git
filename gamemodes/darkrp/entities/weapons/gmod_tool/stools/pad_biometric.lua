TOOL.Category = 'Скрывающиеся двери'
TOOL.Name = '#tool.pad_biometric.name'

if CLIENT then
	language.Add('tool.pad_biometric.name', 'Сканнер')
	language.Add('tool.pad_biometric.desc', 'Создать биометрический сканер с fading door')
	language.Add('tool.pad_biometric.right', 'Присоеденить проп')
	language.Add('tool.pad_biometric.left_1', 'Поставить Сканер')
	language.Add('tool.pad_biometric.reload', 'Очистить выбранные пропы')
end

TOOL.Information = {
	{ name = "left_1", stage = 1 },
	{ name = "right" },
	{ name = "reload" }
}

TOOL.ClientConVar['orgown'] = 0
TOOL.ClientConVar['partyown'] = 0

cleanup.Register('biometrics')

-- это вы не получите сегодня, прошу простить и извинить
-- верните просто старые кейпады, лол

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl('Header', { Description = '#tool.pad_biometric.desc' })

	CPanel:CheckBox('Доступ организации', 'pad_biometric_orgown')
	CPanel:ControlHelp('Разрешите вашей организации доступ к этому биометрическому сканеру')
	
	CPanel:CheckBox('Доступ пати', 'pad_biometric_partyown')
	CPanel:ControlHelp('Разрешите вашей пати доступ к этому биометрическому сканеру')
end
