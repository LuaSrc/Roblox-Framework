export type SettingValueType = string | number | boolean | Color3 | Vector2 | UDim2

export type SettingType = "toggle" | "slider" | "dropdown" | "input" | "color" | "vector2" | "udim2"

export type SettingCategory = "audio" | "graphics" | "controls" | "interface" | "gameplay" | string

export type SettingDefinition = {
	id: string,
	name: string,
	description: string,
	category: SettingCategory,
	type: SettingType,
	default: SettingValueType,
	current: SettingValueType?,
	min: number?,
	max: number?,
	step: number?,
	options: {string}?,
	isReplicated: boolean,
	onChange: ((newValue: SettingValueType) -> ())?
}

export type SettingsConfig = {[string]: SettingDefinition}

export type SettingsModule = {
	RegisterSetting: (settingDef: SettingDefinition) -> (),
	GetSetting: (settingId: string) -> SettingValueType?,
	SetSetting: (settingId: string, value: SettingValueType) -> boolean,
	GetCategory: (category: SettingCategory) -> {SettingDefinition},
	AddCategory: (category: SettingCategory) -> (),
	GetAllSettings: () -> SettingsConfig,
	ResetSetting: (settingId: string) -> boolean,
	ResetAllSettings: () -> (),
	SaveSettings: () -> boolean,
	LoadSettings: () -> boolean,
	OnSettingChanged: (callback: (settingId: string, newValue: SettingValueType, oldValue: SettingValueType?) -> ()) -> RBXScriptConnection
}

return {}
