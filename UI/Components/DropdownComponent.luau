local Types = require(script.Parent.Parent.Parent.Types.SettingsTypes)

local DropdownComponent = {}
DropdownComponent.__index = DropdownComponent

function DropdownComponent.new(settingId: string, setting: Types.SettingDefinition, framework)
	local self = setmetatable({}, DropdownComponent)
	
	self.settingId = settingId
	self.setting = setting
	self.framework = framework
	self.guiObject = nil
	self.isOpen = false
	
	return self
end

function DropdownComponent:Create()
	local frame = Instance.new("Frame")
	frame.Name = self.settingId
	frame.Size = UDim2.new(1, 0, 0, 60)
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = false
	
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
	
	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Size = UDim2.new(1, 0, 0, 30)
	dropdownButton.Position = UDim2.new(0, 0, 0, 25)
	dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	dropdownButton.TextSize = 16
	dropdownButton.Font = Enum.Font.SourceSans
	dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
	dropdownButton.Text = "  " .. tostring(self.setting.current)
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 4)
	uiCorner.Parent = dropdownButton
	
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 10)
	uiPadding.Parent = dropdownButton
	
	local dropdownArrow = Instance.new("ImageLabel")
	dropdownArrow.Name = "DropdownArrow"
	dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
	dropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
	dropdownArrow.BackgroundTransparency = 1
	dropdownArrow.Image = "rbxassetid://6031091004"
	dropdownArrow.Parent = dropdownButton
	
	dropdownButton.Parent = frame
	
	local optionsFrame = Instance.new("Frame")
	optionsFrame.Name = "OptionsFrame"
	optionsFrame.Size = UDim2.new(1, 0, 0, 0)
	optionsFrame.Position = UDim2.new(0, 0, 0, 60)
	optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	optionsFrame.Visible = false
	optionsFrame.ZIndex = 5
	
	local uiCornerOptions = Instance.new("UICorner")
	uiCornerOptions.CornerRadius = UDim.new(0, 4)
	uiCornerOptions.Parent = optionsFrame
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = optionsFrame
	
	optionsFrame.Parent = frame
	
	self.dropdownButton = dropdownButton
	self.optionsFrame = optionsFrame
	self.dropdownArrow = dropdownArrow
	
	self:Update(self.framework:GetSetting(self.settingId))
	self:CreateOptionButtons()
	
	dropdownButton.MouseButton1Click:Connect(function()
		self:ToggleDropdown()
	end)
	
	self.guiObject = frame
	return frame
end

function DropdownComponent:CreateOptionButtons()
	for _, option in ipairs(self.setting.options or {}) do
		local optionButton = Instance.new("TextButton")
		optionButton.Name = option
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.BackgroundTransparency = 1
		optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionButton.TextSize = 16
		optionButton.Font = Enum.Font.SourceSans
		optionButton.TextXAlignment = Enum.TextXAlignment.Left
		optionButton.Text = "  " .. option
		optionButton.ZIndex = 5
		
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingLeft = UDim.new(0, 10)
		uiPadding.Parent = optionButton
		
		optionButton.Parent = self.optionsFrame
		
		optionButton.MouseButton1Click:Connect(function()
			self.framework:SetSetting(self.settingId, option)
			self:ToggleDropdown()
		end)
	end
	
	self.optionsFrame.Size = UDim2.new(1, 0, 0, 30 * #(self.setting.options or {}))
end

function DropdownComponent:ToggleDropdown()
	self.isOpen = not self.isOpen
	self.optionsFrame.Visible = self.isOpen
	
	if self.isOpen then
		self.dropdownArrow.Rotation = 180
		self.guiObject.Size = UDim2.new(1, 0, 0, 60 + self.optionsFrame.Size.Y.Offset)
	else
		self.dropdownArrow.Rotation = 0
		self.guiObject.Size = UDim2.new(1, 0, 0, 60)
	end
end

function DropdownComponent:Update(value: string)
	if not self.dropdownButton then return end
	
	self.dropdownButton.Text = "  " .. tostring(value)
end

function DropdownComponent:Destroy()
	if self.guiObject then
		self.guiObject:Destroy()
		self.guiObject = nil
	end
end

return DropdownComponent
