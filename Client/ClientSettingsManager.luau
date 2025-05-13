local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SettingsManagerBase = require(script.Parent.Parent.SettingsManagerBase)
local Types = require(script.Parent.Parent.Types.SettingsTypes)

local ClientSettingsManager = {}
ClientSettingsManager.__index = ClientSettingsManager
setmetatable(ClientSettingsManager, SettingsManagerBase)

function ClientSettingsManager.new(framework)
	local self = setmetatable(SettingsManagerBase.new(), ClientSettingsManager)
	
	self.framework = framework
	self.player = Players.LocalPlayer
	
	self.remoteEvent = ReplicatedStorage:WaitForChild("SettingsFramework"):WaitForChild("RemoteEvent")
	self.remoteFunction = ReplicatedStorage:WaitForChild("SettingsFramework"):WaitForChild("RemoteFunction")
	
	self:InitializeRemotes()
	
	return self
end

function ClientSettingsManager:InitializeRemotes()
	self.remoteEvent.OnClientEvent:Connect(function(action, ...)
		if action == "SettingChanged" then
			local settingId, value = ...
			if self.settings[settingId] and self.settings[settingId].isReplicated then
				self:SetSetting(settingId, value)
			end
		elseif action == "SettingsLoaded" then
			local serverSettings = ...
			self:ApplyServerSettings(serverSettings)
		end
	end)
	
	task.spawn(function()
		local serverSettings = self.remoteFunction:InvokeServer("GetAllSettings")
		if serverSettings then
			self:ApplyServerSettings(serverSettings)
		end
	end)
end

function ClientSettingsManager:ApplyServerSettings(serverSettings)
	for settingId, settingData in pairs(serverSettings) do
		if not self.settings[settingId] then
			self:RegisterSetting(settingData)
		else
			if self.settings[settingId].isReplicated then
				self:SetSetting(settingId, settingData.current)
			end
		end
	end
end

function ClientSettingsManager:SetSetting(settingId: string, value: Types.SettingValueType): boolean
	local setting = self.settings[settingId]
	if not setting then
		warn(`Setting with ID {settingId} not found`)
		return false
	end
	
	if setting.isReplicated then
		local success = self.remoteFunction:InvokeServer("SetSetting", settingId, value)
		if not success then
			return false
		end
	end
	
	return SettingsManagerBase.SetSetting(self, settingId, value)
end

function ClientSettingsManager:SaveSettings(): boolean
	local saveData = {}
	
	for settingId, setting in pairs(self.settings) do
		if not setting.isReplicated then
			saveData[settingId] = setting.current
		end
	end
	
	if self.player then
		for settingId, value in pairs(saveData) do
			local valueType = typeof(value)
			
			if valueType == "Color3" then
				self.player:SetAttribute(settingId .. "_R", value.R)
				self.player:SetAttribute(settingId .. "_G", value.G)
				self.player:SetAttribute(settingId .. "_B", value.B)
			elseif valueType == "Vector2" then
				self.player:SetAttribute(settingId .. "_X", value.X)
				self.player:SetAttribute(settingId .. "_Y", value.Y)
			elseif valueType == "UDim2" then
				self.player:SetAttribute(settingId .. "_X_Scale", value.X.Scale)
				self.player:SetAttribute(settingId .. "_X_Offset", value.X.Offset)
				self.player:SetAttribute(settingId .. "_Y_Scale", value.Y.Scale)
				self.player:SetAttribute(settingId .. "_Y_Offset", value.Y.Offset)
			else
				self.player:SetAttribute(settingId, value)
			end
		end
		
		return true
	end
	
	return false
end

function ClientSettingsManager:LoadSettings(): boolean
	if not self.player then
		return false
	end
	
	for settingId, setting in pairs(self.settings) do
		if not setting.isReplicated then
			local value = setting.default
			local valueType = typeof(value)
			
			if valueType == "Color3" then
				local r = self.player:GetAttribute(settingId .. "_R")
				local g = self.player:GetAttribute(settingId .. "_G")
				local b = self.player:GetAttribute(settingId .. "_B")
				
				if r and g and b then
					value = Color3.new(r, g, b)
				end
			elseif valueType == "Vector2" then
				local x = self.player:GetAttribute(settingId .. "_X")
				local y = self.player:GetAttribute(settingId .. "_Y")
				
				if x and y then
					value = Vector2.new(x, y)
				end
			elseif valueType == "UDim2" then
				local xScale = self.player:GetAttribute(settingId .. "_X_Scale")
				local xOffset = self.player:GetAttribute(settingId .. "_X_Offset")
				local yScale = self.player:GetAttribute(settingId .. "_Y_Scale")
				local yOffset = self.player:GetAttribute(settingId .. "_Y_Offset")
				
				if xScale and xOffset and yScale and yOffset then
					value = UDim2.new(xScale, xOffset, yScale, yOffset)
				end
			else
				local storedValue = self.player:GetAttribute(settingId)
				if storedValue ~= nil then
					value = storedValue
				end
			end
			
			self:SetSetting(settingId, value)
		end
	end
	
	return true
end

return ClientSettingsManager
