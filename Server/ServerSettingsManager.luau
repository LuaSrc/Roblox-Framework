local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SettingsManagerBase = require(script.Parent.Parent.SettingsManagerBase)
local Types = require(script.Parent.Parent.Types.SettingsTypes)

local ServerSettingsManager = {}
ServerSettingsManager.__index = ServerSettingsManager
setmetatable(ServerSettingsManager, SettingsManagerBase)

function ServerSettingsManager.new(framework)
	local self = setmetatable(SettingsManagerBase.new(), ServerSettingsManager)
	
	self.framework = framework
	self.replicatedSettings = {}
	
	self:SetupRemotes()
	
	Players.PlayerAdded:Connect(function(player)
		self:OnPlayerAdded(player)
	end)
	
	return self
end

function ServerSettingsManager:SetupRemotes()
	local folder = Instance.new("Folder")
	folder.Name = "SettingsFramework"
	folder.Parent = ReplicatedStorage
	
	local remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = "RemoteEvent"
	remoteEvent.Parent = folder
	
	local remoteFunction = Instance.new("RemoteFunction")
	remoteFunction.Name = "RemoteFunction"
	remoteFunction.Parent = folder
	
	self.remoteEvent = remoteEvent
	self.remoteFunction = remoteFunction
	
	remoteFunction.OnServerInvoke = function(player, action, ...)
		return self:HandleRemoteFunction(player, action, ...)
	end
end

function ServerSettingsManager:HandleRemoteFunction(player, action, ...)
	if action == "GetAllSettings" then
		local replicatedSettings = {}
		
		for settingId, setting in pairs(self.settings) do
			if setting.isReplicated then
				replicatedSettings[settingId] = setting
			end
		end
		
		return replicatedSettings
	elseif action == "SetSetting" then
		local settingId, value = ...
		return self:HandleClientSettingChange(player, settingId, value)
	end
	
	return nil
end

function ServerSettingsManager:HandleClientSettingChange(player, settingId, value)
	local setting = self.settings[settingId]
	if not setting or not setting.isReplicated then
		return false
	end
	
	return self:SetSetting(settingId, value)
end

function ServerSettingsManager:OnPlayerAdded(player)
	local replicatedSettings = {}
	
	for settingId, setting in pairs(self.settings) do
		if setting.isReplicated then
			replicatedSettings[settingId] = setting
		end
	end
	
	self.remoteEvent:FireClient(player, "SettingsLoaded", replicatedSettings)
end

function ServerSettingsManager:RegisterSetting(settingDef: Types.SettingDefinition)
	SettingsManagerBase.RegisterSetting(self, settingDef)
	
	if settingDef.isReplicated then
		self.replicatedSettings[settingDef.id] = settingDef
	end
end

function ServerSettingsManager:SetSetting(settingId: string, value: Types.SettingValueType): boolean
	local success = SettingsManagerBase.SetSetting(self, settingId, value)
	
	if success and self.settings[settingId].isReplicated then
		self.remoteEvent:FireAllClients("SettingChanged", settingId, value)
	end
	
	return success
end

function ServerSettingsManager:SaveSettings(): boolean
	local dataModule = script.Parent:FindFirstChild("ServerSettingsData")
	if not dataModule then
		dataModule = Instance.new("ModuleScript")
		dataModule.Name = "ServerSettingsData"
		dataModule.Parent = script.Parent
	end
	
	local saveData = {}
	
	for settingId, setting in pairs(self.settings) do
		if setting.isReplicated then
			saveData[settingId] = {
				value = setting.current,
				type = typeof(setting.current)
			}
		end
	end
	
	local dataString = "return " .. self:TableToString(saveData)
	dataModule.Source = dataString
	
	return true
end

function ServerSettingsManager:TableToString(tbl, indent)
	indent = indent or 0
	local indentStr = string.rep("\t", indent)
	local result = "{\n"
	
	for k, v in pairs(tbl) do
		local key = type(k) == "string" and `["{k}"]` or `[{k}]`
		
		if type(v) == "table" then
			result ..= indentStr .. "\t" .. key .. " = " .. self:TableToString(v, indent + 1) .. ",\n"
		elseif type(v) == "string" then
			result ..= indentStr .. "\t" .. key .. ` = "{v}",\n`
		elseif type(v) == "number" or type(v) == "boolean" then
			result ..= indentStr .. "\t" .. key .. " = " .. tostring(v) .. ",\n"
		elseif typeof(v) == "Color3" then
			result ..= indentStr .. "\t" .. key .. " = Color3.new(" .. v.R .. ", " .. v.G .. ", " .. v.B .. "),\n"
		elseif typeof(v) == "Vector2" then
			result ..= indentStr .. "\t" .. key .. " = Vector2.new(" .. v.X .. ", " .. v.Y .. "),\n"
		elseif typeof(v) == "UDim2" then
			result ..= indentStr .. "\t" .. key .. " = UDim2.new(" .. v.X.Scale .. ", " .. v.X.Offset .. ", " .. v.Y.Scale .. ", " .. v.Y.Offset .. "),\n"
		end
	end
	
	result ..= indentStr .. "}"
	return result
end

function ServerSettingsManager:LoadSettings(): boolean
	local dataModule = script.Parent:FindFirstChild("ServerSettingsData")
	if not dataModule then
		return false
	end
	
	local success, savedData = pcall(function()
		return require(dataModule)
	end)
	
	if not success or type(savedData) ~= "table" then
		return false
	end
	
	for settingId, data in pairs(savedData) do
		if self.settings[settingId] and self.settings[settingId].isReplicated then
			self:SetSetting(settingId, data.value)
		end
	end
	
	return true
end

return ServerSettingsManager
