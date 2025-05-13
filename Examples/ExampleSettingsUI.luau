local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SettingsFramework = require(ReplicatedStorage:WaitForChild("SettingsFramework"))
local SettingsUIManager = require(ReplicatedStorage:WaitForChild("SettingsFramework").UI.SettingsUIManager)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local settingsModule = SettingsFramework.new()
local uiManager = SettingsUIManager.new(settingsModule)

local function CreateSettingsUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SettingsGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 500, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = mainFrame
	
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	titleBar.BorderSizePixel = 0
	
	local uiCornerTitle = Instance.new("UICorner")
	uiCornerTitle.CornerRadius = UDim.new(0, 8)
	uiCornerTitle.Parent = titleBar
	
	local bottomCover = Instance.new("Frame")
	bottomCover.Name = "BottomCover"
	bottomCover.Size = UDim2.new(1, 0, 0, 10)
	bottomCover.Position = UDim2.new(0, 0, 1, -10)
	bottomCover.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	bottomCover.BorderSizePixel = 0
	bottomCover.Parent = titleBar
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -40, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 18
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.Text = "Settings"
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 15)
	uiPadding.Parent = titleLabel
	
	titleLabel.Parent = titleBar
	
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -35, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.Text = "X"
	
	local uiCornerClose = Instance.new("UICorner")
	uiCornerClose.CornerRadius = UDim.new(0, 15)
	uiCornerClose.Parent = closeButton
	
	closeButton.Parent = titleBar
	
	titleBar.Parent = mainFrame
	
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, -20, 1, -50)
	contentFrame.Position = UDim2.new(0, 10, 0, 45)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 6
	contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.Name
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.Parent = contentFrame
	
	contentFrame.Parent = mainFrame
	
	mainFrame.Parent = screenGui
	screenGui.Parent = playerGui
	
	closeButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
		settingsModule:SaveSettings()
	end)
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "SettingsButton"
	toggleButton.Size = UDim2.new(0, 120, 0, 40)
	toggleButton.Position = UDim2.new(1, -130, 0, 10)
	toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.TextSize = 16
	toggleButton.Font = Enum.Font.SourceSansBold
	toggleButton.Text = "Settings"
	toggleButton.AutoButtonColor = true
	
	local uiCornerToggle = Instance.new("UICorner")
	uiCornerToggle.CornerRadius = UDim.new(0, 8)
	uiCornerToggle.Parent = toggleButton
	
	toggleButton.Parent = screenGui
	
	toggleButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)
	
	return {
		ScreenGui = screenGui,
		ContentFrame = contentFrame,
		ToggleButton = toggleButton
	}
end

local function InitializeSettingsUI()
	local uiElements = CreateSettingsUI()
	
	uiManager:Initialize(uiElements.ContentFrame)
	settingsModule:LoadSettings()
	
	return uiElements
end

return InitializeSettingsUI()
