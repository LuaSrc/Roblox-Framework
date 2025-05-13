local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Types.SettingsTypes)
local ClientSettingsManager = require(script.Client.ClientSettingsManager)
local ServerSettingsManager = require(script.Server.ServerSettingsManager)

local RunService = game:GetService("RunService")

local SettingsFramework = {}
SettingsFramework.__index = SettingsFramework

local function isServer()
	return RunService:IsServer()
end

function SettingsFramework.new()
	local self = setmetatable({}, SettingsFramework)
	
	self.isServer = isServer()
	self.manager = if self.isServer 
		then ServerSettingsManager.new(self) 
		else ClientSettingsManager.new(self)
	
	return self
end

function SettingsFramework:RegisterSetting(settingDef: Types.SettingDefinition)
	return self.manager:RegisterSetting(settingDef)
end

function SettingsFramework:GetSetting(settingId: string): Types.SettingValueType?
	return self.manager:GetSetting(settingId)
end

function SettingsFramework:SetSetting(settingId: string, value: Types.SettingValueType): boolean
	return self.manager:SetSetting(settingId, value)
end

function SettingsFramework:GetCategory(category: Types.SettingCategory): {Types.SettingDefinition}
	return self.manager:GetCategory(category)
end

function SettingsFramework:AddCategory(category: Types.SettingCategory)
	return self.manager:AddCategory(category)
end

function SettingsFramework:GetAllSettings(): Types.SettingsConfig
	return self.manager:GetAllSettings()
end

function SettingsFramework:ResetSetting(settingId: string): boolean
	return self.manager:ResetSetting(settingId)
end

function SettingsFramework:ResetAllSettings()
	return self.manager:ResetAllSettings()
end

function SettingsFramework:SaveSettings(): boolean
	return self.manager:SaveSettings()
end

function SettingsFramework:LoadSettings(): boolean
	return self.manager:LoadSettings()
end

function SettingsFramework:OnSettingChanged(callback: (settingId: string, newValue: Types.SettingValueType, oldValue: Types.SettingValueType?) -> ()): RBXScriptConnection
	return self.manager:OnSettingChanged(callback)
end

return SettingsFramework
