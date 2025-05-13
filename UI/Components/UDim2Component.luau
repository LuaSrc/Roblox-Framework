local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local UDim2Component = {}
UDim2Component.__index = UDim2Component

function UDim2Component.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, UDim2Component)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	
	return self
end

function UDim2Component:Create()
	local frame = Instance.new("Frame")
	frame.Name = self.settingId
	frame.Size = UDim2.new(1, 0, 0, 130)
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
	
	local xScaleContainer = self:CreateInputContainer("X Scale", 0, 25)
	local xOffsetContainer = self:CreateInputContainer("X Offset", 0, 55)
	local yScaleContainer = self:CreateInputContainer("Y Scale", 0, 85)
	local yOffsetContainer = self:CreateInputContainer("Y Offset", 0, 115)
	
	xScaleContainer.Parent = frame
	xOffsetContainer.Parent = frame
	yScaleContainer.Parent = frame
	yOffsetContainer.Parent = frame
	
	self.xScaleInput = xScaleContainer:FindFirstChildOfClass("TextBox")
	self.xOffsetInput = xOffsetContainer:FindFirstChildOfClass("TextBox")
	self.yScaleInput = yScaleContainer:FindFirstChildOfClass("TextBox")
	self.yOffsetInput = yOffsetContainer:FindFirstChildOfClass("TextBox")
	
	self:Update(self.framework:GetSetting(self.settingId))
	
	self.guiObject = frame
	return frame
end

function UDim2Component:CreateInputContainer(label: string, xPos: number, yPos: number)
	local container = Instance.new("Frame")
	container.Name = label:gsub(" ", "") .. "Container"
	container.Size = UDim2.new(1, 0, 0, 25)
	container.Position = UDim2.new(0, xPos, 0, yPos)
	container.BackgroundTransparency = 1
	
	local labelText = Instance.new("TextLabel")
	labelText.Name = "Label"
	labelText.Size = UDim2.new(0, 70, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
	labelText.TextSize = 16
	labelText.Font = Enum.Font.SourceSans
	labelText.Text = label .. ":"
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Parent = container
	
	local input = Instance.new("TextBox")
	input.Name = label:gsub(" ", "") .. "Input"
	input.Size = UDim2.new(1, -80, 1, 0)
	input.Position = UDim2.new(0, 80, 0, 0)
	input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextSize = 16
	input.Font = Enum.Font.SourceSans
	input.Text = "0"
	input.PlaceholderText = "Enter value..."
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
				local currentUDim2 = self.framework:GetSetting(self.settingId)
				local xScale = currentUDim2.X.Scale
				local xOffset = currentUDim2.X.Offset
				local yScale = currentUDim2.Y.Scale
				local yOffset = currentUDim2.Y.Offset
				
				if label == "X Scale" then
					xScale = inputValue
				elseif label == "X Offset" then
					xOffset = inputValue
				elseif label == "Y Scale" then
					yScale = inputValue
				elseif label == "Y Offset" then
					yOffset = inputValue
				end
				
				self.framework:SetSetting(self.settingId, UDim2.new(xScale, xOffset, yScale, yOffset))
			else
				self:Update(self.framework:GetSetting(self.settingId))
			end
		else
			self:Update(self.framework:GetSetting(self.settingId))
		end
	end)
	
	return container
end

function UDim2Component:Update(value: UDim2)
	if not self.xScaleInput or not self.xOffsetInput or not self.yScaleInput or not self.yOffsetInput then return end
	
	self.xScaleInput.Text = tostring(value.X.Scale)
	self.xOffsetInput.Text = tostring(value.X.Offset)
	self.yScaleInput.Text = tostring(value.Y.Scale)
	self.yOffsetInput.Text = tostring(value.Y.Offset)
end

function UDim2Component:Destroy()
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return UDim2Component
