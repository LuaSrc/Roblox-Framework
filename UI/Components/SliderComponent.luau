local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local SliderComponent = {}
SliderComponent.__index = SliderComponent

function SliderComponent.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, SliderComponent)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	
	return self
end

function SliderComponent:Create()
	local frame = Instance.new("Frame")
	frame.Name = self.settingId
	frame.Size = UDim2.new(1, 0, 0, 60)
	frame.BackgroundTransparency = 1
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, 0, 0, 20)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.SourceSans
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = self.setting.name
	nameLabel.Parent = frame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "ValueLabel"
	valueLabel.Size = UDim2.new(0, 50, 0, 20)
	valueLabel.Position = UDim2.new(1, -50, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	valueLabel.TextSize = 16
	valueLabel.Font = Enum.Font.SourceSans
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Text = tostring(self.setting.current)
	valueLabel.Parent = frame
	
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Name = "SliderContainer"
	sliderContainer.Size = UDim2.new(1, 0, 0, 30)
	sliderContainer.Position = UDim2.new(0, 0, 0, 25)
	sliderContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 4)
	uiCorner.Parent = sliderContainer
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "SliderFill"
	sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
	
	local uiCornerFill = Instance.new("UICorner")
	uiCornerFill.CornerRadius = UDim.new(0, 4)
	uiCornerFill.Parent = sliderFill
	
	sliderFill.Parent = sliderContainer
	
	local sliderButton = Instance.new("TextButton")
	sliderButton.Name = "SliderButton"
	sliderButton.Size = UDim2.new(1, 0, 1, 0)
	sliderButton.BackgroundTransparency = 1
	sliderButton.Text = ""
	sliderButton.Parent = sliderContainer
	
	sliderContainer.Parent = frame
	
	self.valueLabel = valueLabel
	self.sliderFill = sliderFill
	self.sliderButton = sliderButton
	
	self:Update(self.framework:GetSetting(self.settingId))
	
	local isDragging = false
	
	sliderButton.MouseButton1Down:Connect(function()
		isDragging = true
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	sliderButton.MouseMoved:Connect(function(x)
		if not isDragging then return end
		
		local sliderPosition = math.clamp((x - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1)
		local min = self.setting.min or 0
		local max = self.setting.max or 1
		local step = self.setting.step or 0.01
		
		local newValue = min + (max - min) * sliderPosition
		newValue = math.floor(newValue / step + 0.5) * step
		
		self.framework:SetSetting(self.settingId, newValue)
	end)
	
	self.guiObject = frame
	return frame
end

function SliderComponent:Update(value: number)
	if not self.valueLabel or not self.sliderFill then return end
	
	local min = self.setting.min or 0
	local max = self.setting.max or 1
	local percentage = (value - min) / (max - min)
	
	self.sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
	self.valueLabel.Text = string.format("%.2f", value)
end

function SliderComponent:Destroy()
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return SliderComponent
