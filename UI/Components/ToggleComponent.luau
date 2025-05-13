local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local ToggleComponent = {}
ToggleComponent.__index = ToggleComponent

function ToggleComponent.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, ToggleComponent)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	
	return self
end

function ToggleComponent:Create()
	local frame = Instance.new("Frame")
	frame.Name = self.settingId
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundTransparency = 1
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.SourceSans
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = self.setting.name
	nameLabel.Parent = frame
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(0.3, -10, 0, 30)
	toggleButton.Position = UDim2.new(0.7, 0, 0.5, -15)
	toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.TextSize = 14
	toggleButton.Font = Enum.Font.SourceSans
	toggleButton.Text = ""
	toggleButton.AutoButtonColor = false
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 15)
	uiCorner.Parent = toggleButton
	
	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "Indicator"
	toggleIndicator.Size = UDim2.new(0, 24, 0, 24)
	toggleIndicator.Position = UDim2.new(0, 3, 0.5, -12)
	toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	
	local uiCornerIndicator = Instance.new("UICorner")
	uiCornerIndicator.CornerRadius = UDim.new(0, 12)
	uiCornerIndicator.Parent = toggleIndicator
	
	toggleIndicator.Parent = toggleButton
	toggleButton.Parent = frame
	
	self.toggleButton = toggleButton
	self.toggleIndicator = toggleIndicator
	
	self:Update(self.framework:GetSetting(self.settingId))
	
	toggleButton.MouseButton1Click:Connect(function()
		local currentValue = self.framework:GetSetting(self.settingId)
		self.framework:SetSetting(self.settingId, not currentValue)
	end)
	
	self.guiObject = frame
	return frame
end

function ToggleComponent:Update(value: boolean)
	if not self.toggleButton or not self.toggleIndicator then return end
	
	if value then
		self.toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
		self.toggleIndicator.Position = UDim2.new(1, -27, 0.5, -12)
	else
		self.toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		self.toggleIndicator.Position = UDim2.new(0, 3, 0.5, -12)
	end
end

function ToggleComponent:Destroy()
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return ToggleComponent
