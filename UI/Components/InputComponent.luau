local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local InputComponent = {}
InputComponent.__index = InputComponent

function InputComponent.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, InputComponent)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	
	return self
end

function InputComponent:Create()
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
	
	local inputBox = Instance.new("TextBox")
	inputBox.Name = "InputBox"
	inputBox.Size = UDim2.new(1, 0, 0, 30)
	inputBox.Position = UDim2.new(0, 0, 0, 25)
	inputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.TextSize = 16
	inputBox.Font = Enum.Font.SourceSans
	inputBox.Text = tostring(self.setting.current)
	inputBox.PlaceholderText = "Enter value..."
	inputBox.ClearTextOnFocus = false
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 4)
	uiCorner.Parent = inputBox
	
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 10)
	uiPadding.PaddingRight = UDim.new(0, 10)
	uiPadding.Parent = inputBox
	
	inputBox.Parent = frame
	
	self.inputBox = inputBox
	
	self:Update(self.framework:GetSetting(self.settingId))
	
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local inputValue = inputBox.Text
			local valueType = typeof(self.setting.default)
			
			if valueType == "number" then
				local numValue = tonumber(inputValue)
				if numValue then
					self.framework:SetSetting(self.settingId, numValue)
				else
					self:Update(self.framework:GetSetting(self.settingId))
				end
			elseif valueType == "string" then
				self.framework:SetSetting(self.settingId, inputValue)
			end
		else
			self:Update(self.framework:GetSetting(self.settingId))
		end
	end)
	
	self.guiObject = frame
	return frame
end

function InputComponent:Update(value)
	if not self.inputBox then return end
	
	self.inputBox.Text = tostring(value)
end

function InputComponent:Destroy()
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return InputComponent
