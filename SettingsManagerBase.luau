local RunService = game:GetService("RunService")

local Types = require(script.Parent.Types.SettingsTypes)
local Signal = require(script.Parent.Utility.Signal)

local SettingsManagerBase = {}
SettingsManagerBase.__index = SettingsManagerBase

function SettingsManagerBase.new()
	local self = setmetatable({}, SettingsManagerBase)
	
	self.settings = {} :: Types.SettingsConfig
	self.categories = {} :: {[Types.SettingCategory]: {Types.SettingDefinition}}
	self.settingChanged = Signal.new()
	
	return self
end

function SettingsManagerBase:RegisterSetting(settingDef: Types.SettingDefinition)
	if self.settings[settingDef.id] then
		warn(`Setting with ID {settingDef.id} already exists`)
		return
	end
	
	settingDef.current = settingDef.default
	self.settings[settingDef.id] = settingDef
	
	if not self.categories[settingDef.category] then
		self:AddCategory(settingDef.category)
	end
	
	table.insert(self.categories[settingDef.category], settingDef)
end

function SettingsManagerBase:GetSetting(settingId: string): Types.SettingValueType?
	local setting = self.settings[settingId]
	if not setting then
		warn(`Setting with ID {settingId} not found`)
		return nil
	end
	
	return setting.current
end

function SettingsManagerBase:SetSetting(settingId: string, value: Types.SettingValueType): boolean
	local setting = self.settings[settingId]
	if not setting then
		warn(`Setting with ID {settingId} not found`)
		return false
	end
	
	local oldValue = setting.current
	setting.current = value
	
	self.settingChanged:Fire(settingId, value, oldValue)
	
	if setting.onChange then
		task.spawn(setting.onChange, value)
	end
	
	return true
end

function SettingsManagerBase:GetCategory(category: Types.SettingCategory): {Types.SettingDefinition}
	return self.categories[category] or {}
end

function SettingsManagerBase:AddCategory(category: Types.SettingCategory)
	if not self.categories[category] then
		self.categories[category] = {}
	end
end

function SettingsManagerBase:GetAllSettings(): Types.SettingsConfig
	return self.settings
end

function SettingsManagerBase:ResetSetting(settingId: string): boolean
	local setting = self.settings[settingId]
	if not setting then
		warn(`Setting with ID {settingId} not found`)
		return false
	end
	
	return self:SetSetting(settingId, setting.default)
end

function SettingsManagerBase:ResetAllSettings()
	for settingId, setting in pairs(self.settings) do
		self:SetSetting(settingId, setting.default)
	end
end

function SettingsManagerBase:SaveSettings(): boolean
	warn("SaveSettings must be implemented by a derived class")
	return false
end

function SettingsManagerBase:LoadSettings(): boolean
	warn("LoadSettings must be implemented by a derived class")
	return false
end

function SettingsManagerBase:OnSettingChanged(callback: (settingId: string, newValue: Types.SettingValueType, oldValue: Types.SettingValueType?) -> ()): RBXScriptConnection
	return self.settingChanged:Connect(callback)
end

return SettingsManagerBase
