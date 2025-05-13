local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local Vector2Component = {}
Vector2Component.__index = Vector2Component

function Vector2Component.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, Vector2Component)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	
	return self
end

function Vector2Component:Create()
	local frame = Instance.new("Frame")
	frame.Name = self.settingId
	frame.Size = UDim2.new(1, 0, 0, 80)
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
	
	local xContainer = self:CreateInputContainer("X", 0, 25)
	local yContainer = self:CreateInputContainer("Y", 0, 55)
	
	xContainer.Parent = frame
	yContainer.Parent = frame
	
	self.xInput = xContainer:FindFirstChildOfClass("TextBox")
	self.yInput = yContainer:FindFirstChildOfClass("TextBox")
	
	self:Update(self.framework:GetSetting(self.settingId))
	
	self.guiObject = frame
	return frame
end

function Vector2Component:CreateInputContainer(label: string, xPos: number, yPos: number)
	local container = Instance.new("Frame")
	container.Name = label .. "Container"
	container.Size = UDim2.new(1, 0, 0, 25)
	container.Position = UDim2.new(0, xPos, 0, yPos)
	container.BackgroundTransparency = 1
	
	local labelText = Instance.new("TextLabel")
	labelText.Name = "Label"
	labelText.Size = UDim2.new(0, 30, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
	labelText.TextSize = 16
	labelText.Font = Enum.Font.SourceSans
	labelText.Text = label .. ":"
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Parent = container
	
	local input = Instance.new("TextBox")
	input.Name = label .. "Input"
	input.Size = UDim2.new(1, -40, 1, 0)
	input.Position = UDim2.new(0, 40, 0, 0)
	input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextSize = 16
	input.Font = Enum.Font.SourceSans
	input.Text = "0"
	input.PlaceholderText = "Enter " .. label .. " value..."
	input.ClearTextOnFocus = false
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 4)
	uiCorner.Parent = input
	
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 10)
	uiPadding.PaddingRight = UDim.new(0, 10)
	uiPadding.Parent = input
	
	input.Parent = container
	
	input.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local inputValue = tonumber(input.Text)
			if inputValue then
				local currentVector = self.framework:GetSetting(self.settingId)
				local x = currentVector.X
				local y = currentVector.Y
				
				if label == "X" then
					x = inputValue
				elseif label == "Y" then
					y = inputValue
				end
				
				self.framework:SetSetting(self.settingId, Vector2.new(x, y))
			else
				self:Update(self.framework:GetSetting(self.settingId))
			end
		else
			self:Update(self.framework:GetSetting(self.settingId))
		end
	end)
	
	return container
end

function Vector2Component:Update(value: Vector2)
	if not self.xInput or not self.yInput then return end
	
	self.xInput.Text = tostring(value.X)
	self.yInput.Text = tostring(value.Y)
end

function Vector2Component:Destroy()
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return Vector2Component
