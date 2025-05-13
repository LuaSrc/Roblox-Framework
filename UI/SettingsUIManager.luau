local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Parent.Parent.Types.SettingsTypes)
local ToggleComponent = require(script.Parent.Components.ToggleComponent)
local SliderComponent = require(script.Parent.Components.SliderComponent)
local DropdownComponent = require(script.Parent.Components.DropdownComponent)
local InputComponent = require(script.Parent.Components.InputComponent)
local ColorPickerComponent = require(script.Parent.Components.ColorPickerComponent)
local Vector2Component = require(script.Parent.Components.Vector2Component)
local UDim2Component = require(script.Parent.Components.UDim2Component)

local SettingsUIManager = {}
SettingsUIManager.__index = SettingsUIManager

function SettingsUIManager.new(framework)
	local self = setmetatable({}, SettingsUIManager)
	
	self.framework = framework
	self.components = {}
	self.categoryContainers = {}
	
	return self
end

function SettingsUIManager:Initialize(settingsGuiRoot)
	self.settingsGuiRoot = settingsGuiRoot
	self:RefreshUI()
	
	self.framework:OnSettingChanged(function(settingId)
		self:UpdateComponent(settingId)
	end)
end

function SettingsUIManager:RefreshUI()
	if not self.settingsGuiRoot then return end
	
	self:ClearUI()
	self:BuildCategories()
	self:BuildComponents()
end

function SettingsUIManager:ClearUI()
	for _, component in pairs(self.components) do
		if component.Destroy then
			component:Destroy()
		end
	end
	
	self.components = {}
	
	for _, container in pairs(self.categoryContainers) do
		container:Destroy()
	end
	
	self.categoryContainers = {}
end

function SettingsUIManager:BuildCategories()
	local settings = self.framework:GetAllSettings()
	local categories = {}
	
	for _, setting in pairs(settings) do
		if not table.find(categories, setting.category) then
			table.insert(categories, setting.category)
		end
	end
	
	table.sort(categories)
	
	for _, category in ipairs(categories) do
		self:CreateCategoryContainer(category)
	end
end

function SettingsUIManager:CreateCategoryContainer(category)
	local categoryFrame = Instance.new("Frame")
	categoryFrame.Name = category
	categoryFrame.Size = UDim2.new(1, 0, 0, 30)
	categoryFrame.BackgroundTransparency = 1
	categoryFrame.AutomaticSize = Enum.AutomaticSize.Y
	categoryFrame.Parent = self.settingsGuiRoot
	
	local categoryLabel = Instance.new("TextLabel")
	categoryLabel.Name = "CategoryLabel"
	categoryLabel.Size = UDim2.new(1, 0, 0, 30)
	categoryLabel.BackgroundTransparency = 0.5
	categoryLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	categoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	categoryLabel.TextSize = 18
	categoryLabel.Font = Enum.Font.SourceSansBold
	categoryLabel.Text = category:sub(1, 1):upper() .. category:sub(2)
	categoryLabel.Parent = categoryFrame
	
	local settingsContainer = Instance.new("Frame")
	settingsContainer.Name = "SettingsContainer"
	settingsContainer.Size = UDim2.new(1, 0, 0, 0)
	settingsContainer.Position = UDim2.fromOffset(0, 30)
	settingsContainer.BackgroundTransparency = 1
	settingsContainer.AutomaticSize = Enum.AutomaticSize.Y
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 5)
	uiListLayout.Parent = settingsContainer
	
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 10)
	uiPadding.PaddingRight = UDim.new(0, 10)
	uiPadding.PaddingTop = UDim.new(0, 5)
	uiPadding.PaddingBottom = UDim.new(0, 5)
	uiPadding.Parent = settingsContainer
	
	settingsContainer.Parent = categoryFrame
	
	self.categoryContainers[category] = settingsContainer
	
	return settingsContainer
end

function SettingsUIManager:BuildComponents()
	local settings = self.framework:GetAllSettings()
	
	for settingId, setting in pairs(settings) do
		self:CreateComponentForSetting(settingId, setting)
	end
end

function SettingsUIManager:CreateComponentForSetting(settingId: string, setting: Types.SettingDefinition)
	local container = self.categoryContainers[setting.category]
	if not container then return end
	
	local component
	
	if setting.type == "toggle" then
		component = ToggleComponent.new(settingId, setting, self.framework)
	elseif setting.type == "slider" then
		component = SliderComponent.new(settingId, setting, self.framework)
	elseif setting.type == "dropdown" then
		component = DropdownComponent.new(settingId, setting, self.framework)
	elseif setting.type == "input" then
		component = InputComponent.new(settingId, setting, self.framework)
	elseif setting.type == "color" then
		component = ColorPickerComponent.new(settingId, setting, self.framework)
	elseif setting.type == "vector2" then
		component = Vector2Component.new(settingId, setting, self.framework)
	elseif setting.type == "udim2" then
		component = UDim2Component.new(settingId, setting, self.framework)
	end
	
	if component then
		local guiObject = component:Create()
		guiObject.Parent = container
		self.components[settingId] = component
	end
end

function SettingsUIManager:UpdateComponent(settingId: string)
	local component = self.components[settingId]
	if component and component.Update then
		local value = self.framework:GetSetting(settingId)
		component:Update(value)
	end
end

function SettingsUIManager:GetComponentInstance(settingId: string)
	local component = self.components[settingId]
	return component and component.guiObject
end

return SettingsUIManager
