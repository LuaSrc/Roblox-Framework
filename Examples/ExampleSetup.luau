local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SettingsFramework = require(ReplicatedStorage:WaitForChild("SettingsFramework"))

local settingsModule = SettingsFramework.new()

local function SetupPlayerSettings()
	settingsModule:RegisterSetting({
		id = "masterVolume",
		name = "Master Volume",
		description = "Controls the overall game volume",
		category = "audio",
		type = "slider",
		default = 0.8,
		min = 0,
		max = 1,
		step = 0.01,
		isReplicated = false,
		onChange = function(newValue)
			local soundService = game:GetService("SoundService")
			soundService.MasterVolume = newValue
		end
	})
	
	settingsModule:RegisterSetting({
		id = "sfxVolume",
		name = "SFX Volume",
		description = "Controls the sound effects volume",
		category = "audio",
		type = "slider",
		default = 1,
		min = 0,
		max = 1,
		step = 0.01,
		isReplicated = false,
		onChange = function(newValue)
			local soundService = game:GetService("SoundService")
			soundService.SFXVolume = newValue
		end
	})
	
	settingsModule:RegisterSetting({
		id = "musicVolume",
		name = "Music Volume",
		description = "Controls the music volume",
		category = "audio",
		type = "slider",
		default = 0.7,
		min = 0,
		max = 1,
		step = 0.01,
		isReplicated = false,
		onChange = function(newValue)
			local soundService = game:GetService("SoundService")
			soundService.MusicVolume = newValue
		end
	})
	
	settingsModule:RegisterSetting({
		id = "mouseSensitivity",
		name = "Mouse Sensitivity",
		description = "Controls the mouse sensitivity",
		category = "controls",
		type = "slider",
		default = 0.5,
		min = 0.1,
		max = 2,
		step = 0.05,
		isReplicated = false,
		onChange = function(newValue)
			local userInputService = game:GetService("UserInputService")
			userInputService.MouseDeltaSensitivity = newValue
		end
	})
	
	settingsModule:RegisterSetting({
		id = "cameraInverted",
		name = "Invert Camera Y-Axis",
		description = "Invert the camera's Y-axis movement",
		category = "controls",
		type = "toggle",
		default = false,
		isReplicated = false,
		onChange = function(newValue)
			local player = game:GetService("Players").LocalPlayer
			if player and player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
				player.CameraMode = if newValue then Enum.CameraMode.Classic else Enum.CameraMode.Classic
			end
		end
	})
	
	settingsModule:RegisterSetting({
		id = "qualityLevel",
		name = "Graphics Quality",
		description = "Set the graphics quality level",
		category = "graphics",
		type = "dropdown",
		default = "Medium",
		options = {"Low", "Medium", "High", "Ultra"},
		isReplicated = false,
		onChange = function(newValue)
			local runService = game:GetService("RunService")
			local lighting = game:GetService("Lighting")
			
			if newValue == "Low" then
				settings().Rendering.QualityLevel = 1
				lighting.GlobalShadows = false
			elseif newValue == "Medium" then
				settings().Rendering.QualityLevel = 4
				lighting.GlobalShadows = true
			elseif newValue == "High" then
				settings().Rendering.QualityLevel = 8
				lighting.GlobalShadows = true
			elseif newValue == "Ultra" then
				settings().Rendering.QualityLevel = 10
				lighting.GlobalShadows = true
			end
		end
	})
end

local function SetupUISettings()
	settingsModule:RegisterSetting({
		id = "uiScale",
		name = "UI Scale",
		description = "Adjust the size of the user interface",
		category = "interface",
		type = "slider",
		default = 1,
		min = 0.5,
		max = 1.5,
		step = 0.05,
		isReplicated = false,
		onChange = function(newValue)
			local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
			for _, gui in pairs(playerGui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui.Name ~= "SettingsGui" then
					gui.UIScale.Scale = newValue
				end
			end
		end
	})
	
	settingsModule:RegisterSetting({
		id = "accentColor",
		name = "Accent Color",
		description = "Change the accent color of the interface",
		category = "interface",
		type = "color",
		default = Color3.fromRGB(0, 120, 220),
		isReplicated = true,
		onChange = function(newValue)
			local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
			for _, gui in pairs(playerGui:GetChildren()) do
				if gui:IsA("ScreenGui") then
					for _, obj in pairs(gui:GetDescendants()) do
						if obj:IsA("Frame") and obj.Name == "AccentElement" then
							obj.BackgroundColor3 = newValue
						elseif obj:IsA("TextLabel") and obj.Name == "AccentText" then
							obj.TextColor3 = newValue
						end
					end
				end
			end
		end
	})
end

local function SetupGameplaySettings()
	settingsModule:RegisterSetting({
		id = "showPlayerNames",
		name = "Show Player Names",
		description = "Toggle the visibility of player names",
		category = "gameplay",
		type = "toggle",
		default = true,
		isReplicated = true,
		onChange = function(newValue)
			local players = game:GetService("Players"):GetPlayers()
			for _, player in ipairs(players) do
				local character = player.Character
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid.DisplayDistanceType = if newValue then Enum.HumanoidDisplayDistanceType.Viewer else Enum.HumanoidDisplayDistanceType.None
					end
				end
			end
		end
	})
	
	settingsModule:RegisterSetting({
		id = "crosshairColor",
		name = "Crosshair Color",
		description = "Change the color of your crosshair",
		category = "gameplay",
		type = "color",
		default = Color3.fromRGB(255, 255, 255),
		isReplicated = true,
		onChange = function(newValue)
			local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
			local crosshair = playerGui:FindFirstChild("CrosshairGui")
			if crosshair then
				local crosshairFrame = crosshair:FindFirstChild("Crosshair")
				if crosshairFrame then
					crosshairFrame.BackgroundColor3 = newValue
				end
			end
		end
	})
	
	settingsModule:RegisterSetting({
		id = "crosshairSize",
		name = "Crosshair Size",
		description = "Adjust the size of your crosshair",
		category = "gameplay",
		type = "vector2",
		default = Vector2.new(4, 4),
		isReplicated = true,
		onChange = function(newValue)
			local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
			local crosshair = playerGui:FindFirstChild("CrosshairGui")
			if crosshair then
				local crosshairFrame = crosshair:FindFirstChild("Crosshair")
				if crosshairFrame then
					crosshairFrame.Size = UDim2.new(0, newValue.X, 0, newValue.Y)
				end
			end
		end
	})
end

local function InitializeSettings()
	if game:GetService("RunService"):IsClient() then
		SetupPlayerSettings()
		SetupUISettings()
		SetupGameplaySettings()
		
		settingsModule:LoadSettings()
		
		local player = game:GetService("Players").LocalPlayer
		
		player.CharacterAdded:Connect(function()
			local value = settingsModule:GetSetting("showPlayerNames")
			if value ~= nil then
				local character = player.Character
				local humanoid = character:WaitForChild("Humanoid")
				humanoid.DisplayDistanceType = if value then Enum.HumanoidDisplayDistanceType.Viewer else Enum.HumanoidDisplayDistanceType.None
			end
		end)
		
		game:GetService("Players").PlayerAdded:Connect(function(newPlayer)
			local value = settingsModule:GetSetting("showPlayerNames")
			if value ~= nil then
				newPlayer.CharacterAdded:Connect(function(character)
					local humanoid = character:WaitForChild("Humanoid")
					humanoid.DisplayDistanceType = if value then Enum.HumanoidDisplayDistanceType.Viewer else Enum.HumanoidDisplayDistanceType.None
				end)
			end
		end)
	else
		SetupGameplaySettings()
		settingsModule:LoadSettings()
	end
end

InitializeSettings()

return settingsModule
