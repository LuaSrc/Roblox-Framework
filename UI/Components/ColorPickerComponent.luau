local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local ColorPickerComponent = {}
ColorPickerComponent.__index = ColorPickerComponent

function ColorPickerComponent.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, ColorPickerComponent)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	self.isOpen = false
	
	return self
end

function ColorPickerComponent:Create()
	local frame = Instance.new("Frame")
	frame.Name = self.settingId
	frame.Size = UDim2.new(1, 0, 0, 60)
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = false
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, -70, 0, 20)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.SourceSans
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = self.setting.name
	nameLabel.Parent = frame
	
	local colorDisplay = Instance.new("Frame")
	colorDisplay.Name = "ColorDisplay"
	colorDisplay.Size = UDim2.new(0, 50, 0, 20)
	colorDisplay.Position = UDim2.new(1, -60, 0, 0)
	colorDisplay.BackgroundColor3 = self.setting.current or Color3.fromRGB(255, 255, 255)
	
	local uiCornerDisplay = Instance.new("UICorner")
	uiCornerDisplay.CornerRadius = UDim.new(0, 4)
	uiCornerDisplay.Parent = colorDisplay
	
	colorDisplay.Parent = frame
	
	local colorButton = Instance.new("TextButton")
	colorButton.Name = "ColorButton"
	colorButton.Size = UDim2.new(1, 0, 0, 30)
	colorButton.Position = UDim2.new(0, 0, 0, 25)
	colorButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	colorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	colorButton.TextSize = 14
	colorButton.Font = Enum.Font.SourceSans
	colorButton.Text = "Select Color"
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 4)
	uiCorner.Parent = colorButton
	
	colorButton.Parent = frame
	
	local pickerFrame = Instance.new("Frame")
	pickerFrame.Name = "PickerFrame"
	pickerFrame.Size = UDim2.new(1, 0, 0, 180)
	pickerFrame.Position = UDim2.new(0, 0, 0, 60)
	pickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	pickerFrame.Visible = false
	pickerFrame.ZIndex = 5
	
	local uiCornerPicker = Instance.new("UICorner")
	uiCornerPicker.CornerRadius = UDim.new(0, 4)
	uiCornerPicker.Parent = pickerFrame
	
	local hueFrame = Instance.new("Frame")
	hueFrame.Name = "HueFrame"
	hueFrame.Size = UDim2.new(1, -20, 0, 20)
	hueFrame.Position = UDim2.new(0, 10, 0, 10)
	hueFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hueFrame.ZIndex = 5
	
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	})
	uiGradient.Parent = hueFrame
	
	local uiCornerHue = Instance.new("UICorner")
	uiCornerHue.CornerRadius = UDim.new(0, 4)
	uiCornerHue.Parent = hueFrame
	
	local hueSelector = Instance.new("Frame")
	hueSelector.Name = "HueSelector"
	hueSelector.Size = UDim2.new(0, 5, 1, 0)
	hueSelector.Position = UDim2.new(0, 0, 0, 0)
	hueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hueSelector.BorderSizePixel = 1
	hueSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
	hueSelector.ZIndex = 6
	hueSelector.Parent = hueFrame
	
	local satValFrame = Instance.new("Frame")
	satValFrame.Name = "SatValFrame"
	satValFrame.Size = UDim2.new(1, -20, 0, 100)
	satValFrame.Position = UDim2.new(0, 10, 0, 40)
	satValFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	satValFrame.ZIndex = 5
	
	local uiCornerSatVal = Instance.new("UICorner")
	uiCornerSatVal.CornerRadius = UDim.new(0, 4)
	uiCornerSatVal.Parent = satValFrame
	
	local satGradient = Instance.new("UIGradient")
	satGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	})
	satGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	satGradient.Parent = satValFrame
	
	local valGradient = Instance.new("Frame")
	valGradient.Name = "ValGradient"
	valGradient.Size = UDim2.new(1, 0, 1, 0)
	valGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	valGradient.BackgroundTransparency = 0
	valGradient.ZIndex = 5
	
	local uiGradientVal = Instance.new("UIGradient")
	uiGradientVal.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})
	uiGradientVal.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	})
	uiGradientVal.Parent = valGradient
	
	valGradient.Parent = satValFrame
	
	local satValSelector = Instance.new("Frame")
	satValSelector.Name = "SatValSelector"
	satValSelector.Size = UDim2.new(0, 10, 0, 10)
	satValSelector.AnchorPoint = Vector2.new(0.5, 0.5)
	satValSelector.Position = UDim2.new(1, 0, 0, 0)
	satValSelector.BackgroundTransparency = 1
	satValSelector.ZIndex = 6
	
	local selectorCircle = Instance.new("Frame")
	selectorCircle.Size = UDim2.new(1, 0, 1, 0)
	selectorCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	selectorCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
	selectorCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	selectorCircle.BorderSizePixel = 1
	selectorCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	selectorCircle.ZIndex = 6
	
	local uiCornerSelector = Instance.new("UICorner")
	uiCornerSelector.CornerRadius = UDim.new(1, 0)
	uiCornerSelector.Parent = selectorCircle
	
	selectorCircle.Parent = satValSelector
	satValSelector.Parent = satValFrame
	
	local rgbInputsFrame = Instance.new("Frame")
	rgbInputsFrame.Name = "RGBInputs"
	rgbInputsFrame.Size = UDim2.new(1, -20, 0, 30)
	rgbInputsFrame.Position = UDim2.new(0, 10, 0, 150)
	rgbInputsFrame.BackgroundTransparency = 1
	rgbInputsFrame.ZIndex = 5
	
	local rInput = self:CreateRGBInput("R", 0)
	local gInput = self:CreateRGBInput("G", 1/3)
	local bInput = self:CreateRGBInput("B", 2/3)
	
	rInput.Parent = rgbInputsFrame
	gInput.Parent = rgbInputsFrame
	bInput.Parent = rgbInputsFrame
	
	rgbInputsFrame.Parent = pickerFrame
	
	hueFrame.Parent = pickerFrame
	satValFrame.Parent = pickerFrame
	pickerFrame.Parent = frame
	
	self.colorDisplay = colorDisplay
	self.colorButton = colorButton
	self.pickerFrame = pickerFrame
	self.hueFrame = hueFrame
	self.hueSelector = hueSelector
	self.satValFrame = satValFrame
	self.satValSelector = satValSelector
	self.rInput = rInput:FindFirstChildOfClass("TextBox")
	self.gInput = gInput:FindFirstChildOfClass("TextBox")
	self.bInput = bInput:FindFirstChildOfClass("TextBox")
	
	self:Update(self.framework:GetSetting(self.settingId))
	
	colorButton.MouseButton1Click:Connect(function()
		self:ToggleColorPicker()
	end)
	
	hueFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:UpdateHueSelection(input.Position.X)
			self:StartHueDrag()
		end
	end)
	
	hueFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:StopHueDrag()
		end
	end)
	
	satValFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:UpdateSatValSelection(input.Position.X, input.Position.Y)
			self:StartSatValDrag()
		end
	end)
	
	satValFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:StopSatValDrag()
		end
	end)
	
	self.guiObject = frame
	return frame
end

function ColorPickerComponent:CreateRGBInput(label, xPosition)
	local container = Instance.new("Frame")
	container.Name = label .. "Container"
	container.Size = UDim2.new(0.3, -5, 1, 0)
	container.Position = UDim2.new(xPosition, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.ZIndex = 5
	
	local labelText = Instance.new("TextLabel")
	labelText.Name = "Label"
	labelText.Size = UDim2.new(0, 15, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
	labelText.TextSize = 14
	labelText.Font = Enum.Font.SourceSans
	labelText.Text = label
	labelText.ZIndex = 5
	labelText.Parent = container
	
	local input = Instance.new("TextBox")
	input.Name = label .. "Input"
	input.Size = UDim2.new(1, -20, 1, 0)
	input.Position = UDim2.new(0, 20, 0, 0)
	input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextSize = 14
	input.Font = Enum.Font.SourceSans
	input.Text = "255"
	input.PlaceholderText = "0-255"
	input.ZIndex = 5
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 4)
	uiCorner.Parent = input
	
	input.Parent = container
	
	input.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local num = tonumber(input.Text)
			if num then
				num = math.clamp(math.floor(num), 0, 255)
				local color = self.framework:GetSetting(self.settingId)
				local r, g, b = color.R, color.G, color.B
				
				if label == "R" then
					r = num / 255
				elseif label == "G" then
					g = num / 255
				elseif label == "B" then
					b = num / 255
				end
				
				self.framework:SetSetting(self.settingId, Color3.new(r, g, b))
			end
			
			self:Update(self.framework:GetSetting(self.settingId))
		end
	end)
	
	return container
end

function ColorPickerComponent:ToggleColorPicker()
	self.isOpen = not self.isOpen
	self.pickerFrame.Visible = self.isOpen
	
	if self.isOpen then
		self.guiObject.Size = UDim2.new(1, 0, 0, 60 + self.pickerFrame.Size.Y.Offset)
	else
		self.guiObject.Size = UDim2.new(1, 0, 0, 60)
	end
end

function ColorPickerComponent:Update(color: Color3)
	if not self.colorDisplay then return end
	
	self.colorDisplay.BackgroundColor3 = color
	self.satValFrame.BackgroundColor3 = self:HueToColor(self:GetHue(color))
	
	self.hueSelector.Position = UDim2.new(self:GetHue(color), 0, 0, 0)
	self.satValSelector.Position = UDim2.new(self:GetSaturation(color), 0, 1 - self:GetValue(color), 0)
	
	if self.rInput and self.gInput and self.bInput then
		self.rInput.Text = tostring(math.floor(color.R * 255))
		self.gInput.Text = tostring(math.floor(color.G * 255))
		self.bInput.Text = tostring(math.floor(color.B * 255))
	end
end

function ColorPickerComponent:GetHue(color: Color3): number
	local h, s, v = color:ToHSV()
	return h
end

function ColorPickerComponent:GetSaturation(color: Color3): number
	local h, s, v = color:ToHSV()
	return s
end

function ColorPickerComponent:GetValue(color: Color3): number
	local h, s, v = color:ToHSV()
	return v
end

function ColorPickerComponent:HueToColor(hue: number): Color3
	return Color3.fromHSV(hue, 1, 1)
end

function ColorPickerComponent:UpdateHueSelection(x: number)
	local huePosition = math.clamp((x - self.hueFrame.AbsolutePosition.X) / self.hueFrame.AbsoluteSize.X, 0, 1)
	self.hueSelector.Position = UDim2.new(huePosition, 0, 0, 0)
	
	local newColor = self:HueToColor(huePosition)
	self.satValFrame.BackgroundColor3 = newColor
	
	self:UpdateSelectedColor()
end

function ColorPickerComponent:UpdateSatValSelection(x: number, y: number)
	local saturation = math.clamp((x - self.satValFrame.AbsolutePosition.X) / self.satValFrame.AbsoluteSize.X, 0, 1)
	local value = 1 - math.clamp((y - self.satValFrame.AbsolutePosition.Y) / self.satValFrame.AbsoluteSize.Y, 0, 1)
	
	self.satValSelector.Position = UDim2.new(saturation, 0, 1 - value, 0)
	
	self:UpdateSelectedColor()
end

function ColorPickerComponent:UpdateSelectedColor()
	local hue = self.hueSelector.Position.X.Scale
	local saturation = self.satValSelector.Position.X.Scale
	local value = 1 - self.satValSelector.Position.Y.Scale
	
	local newColor = Color3.fromHSV(hue, saturation, value)
	self.framework:SetSetting(self.settingId, newColor)
end

function ColorPickerComponent:StartHueDrag()
	self.isDraggingHue = true
	
	self.hueConnection = game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self.isDraggingHue then
				self:UpdateHueSelection(input.Position.X)
			end
		end
	end)
end

function ColorPickerComponent:StopHueDrag()
	self.isDraggingHue = false
	
	if self.hueConnection then
		self.hueConnection:Disconnect()
		self.hueConnection = nil
	end
end

function ColorPickerComponent:StartSatValDrag()
	self.isDraggingSatVal = true
	
	self.satValConnection = game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self.isDraggingSatVal then
				self:UpdateSatValSelection(input.Position.X, input.Position.Y)
			end
		end
	end)
end

function ColorPickerComponent:StopSatValDrag()
	self.isDraggingSatVal = false
	
	if self.satValConnection then
		self.satValConnection:Disconnect()
		self.satValConnection = nil
	end
end

function ColorPickerComponent:Destroy()
	if self.hueConnection then
		self.hueConnection:Disconnect()
	end
	
	if self.satValConnection then
		self.satValConnection:Disconnect()
	end
	
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return ColorPickerComponent
