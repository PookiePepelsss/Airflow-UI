local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
Airflow:PreloadIcons()

local win = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "Example build",
    ToggleUIKeybind = "RightControl",
    Size = UDim2.fromOffset(640, 420),
    ConfigurationSaving = { Enabled = true, FolderName = "AirflowExample", FileName = "default" },
})

local main = win:CreateTab({ Name = "Main", Desc = "Movement, inputs and keybinds", Icon = "zap" })

main:CreateSection("Movement")

local walkSpeed = 16
local speedEnabled = false

local function applySpeed()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and walkSpeed or 16
    end
end

main:CreateToggle({
    Name = "Speed boost",
    Flag = "SpeedBoost",
    Desc = "Applies the slider value to WalkSpeed",
    CurrentValue = false,
    Callback = function(on)
        speedEnabled = on
        applySpeed()
    end,
})

main:CreateSlider({
    Name = "Walk speed",
    Flag = "WalkSpeed",
    Range = { 16, 120 },
    Increment = 1,
    CurrentValue = 16,
    Suffix = " st/s",
    Callback = function(value)
        walkSpeed = value
        applySpeed()
    end,
})

main:CreateSlider({
    Name = "Field of view",
    Flag = "Fov",
    Range = { 50, 120 },
    Increment = 0.5,
    CurrentValue = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end,
})

main:CreateSection("Actions")

main:CreateButton({
    Name = "Reset character",
    Desc = "Respawns you at the last spawn point",
    Callback = function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end,
})

main:CreateButton({
    Name = "Send test notification",
    Style = "Primary",
    Callback = function()
        Airflow:Notify({
            Title = "Hello",
            Content = "This toast dismisses on its own or on click.",
            Duration = 4,
            Type = "Success",
        })
    end,
})

main:CreateKeybind({
    Name = "Speed toggle key",
    Flag = "SpeedKey",
    Desc = "Press to flip the speed boost",
    CurrentKeybind = "F",
    Callback = function()
        speedEnabled = not speedEnabled
        applySpeed()
        Airflow:Notify({ Title = "Speed boost", Content = speedEnabled and "Enabled" or "Disabled", Duration = 2 })
    end,
    OnChanged = function(key)
        Airflow:Notify({ Title = "Rebound", Content = "Speed toggle is now " .. key.Name, Duration = 2, Type = "Info" })
    end,
})

main:CreateSection("Inputs")

local jumpPower = 50
main:CreateInput({
    Name = "Jump power",
    Desc = "Applied on Enter",
    PlaceholderText = "50",
    Numeric = true,
    Callback = function(text, enterPressed)
        local number = tonumber(text)
        if enterPressed and number then
            jumpPower = math.clamp(number, 0, 500)
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = jumpPower
            end
        end
    end,
})

main:CreateInput({
    Name = "Teleport to player",
    Desc = "Partial username, Enter to go",
    PlaceholderText = "name",
    Callback = function(text, enterPressed)
        if not enterPressed or #text == 0 then
            return
        end
        local needle = string.lower(text)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and string.find(string.lower(player.Name), needle, 1, true) then
                local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot and myRoot then
                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                    Airflow:Notify({ Title = "Teleported", Content = "To " .. player.Name, Duration = 2, Type = "Success" })
                end
                return
            end
        end
        Airflow:Notify({ Title = "Not found", Content = "No player matches " .. text, Duration = 2, Type = "Warning" })
    end,
})

main:CreateSection("Keybinds")

main:CreateKeybind({
    Name = "Jump",
    Desc = "Forces a jump",
    CurrentKeybind = "G",
    Callback = function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end,
})

main:CreateKeybind({
    Name = "Reset FOV",
    CurrentKeybind = "H",
    Callback = function()
        workspace.CurrentCamera.FieldOfView = 70
    end,
})

local visuals = win:CreateTab({ Name = "Visuals", Desc = "Lighting and player visuals", Icon = "eye" })

visuals:CreateSection("Environment")

local originalClockTime = Lighting.ClockTime
local originalBrightness = Lighting.Brightness

visuals:CreateDropdown({
    Name = "Time of day",
    Flag = "TimeOfDay",
    Options = { "Morning", "Noon", "Evening", "Night" },
    CurrentOption = "Noon",
    Callback = function(choice)
        local times = { Morning = 7, Noon = 12, Evening = 18, Night = 0 }
        Lighting.ClockTime = times[choice] or originalClockTime
    end,
})

local brightnessSlider = visuals:CreateSlider({
    Name = "Brightness",
    Range = { 0, 5 },
    Increment = 0.1,
    CurrentValue = originalBrightness,
    Callback = function(value)
        Lighting.Brightness = value
    end,
})

visuals:CreateToggle({
    Name = "Full bright",
    Flag = "FullBright",
    Desc = "Overrides ambient lighting",
    Callback = function(on)
        if on then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = Color3.fromRGB(70, 70, 70)
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end,
})

visuals:CreateSection("Colors")

local originalAmbient = Lighting.Ambient
visuals:CreateColorPicker({
    Name = "Ambient color",
    Desc = "Lighting.Ambient",
    Color = originalAmbient,
    Callback = function(color)
        Lighting.Ambient = color
    end,
})

local highlightColor = Color3.fromRGB(235, 199, 246)
local highlightEnabled = false
local highlights = {}

local function refreshHighlights()
    for player, highlight in pairs(highlights) do
        highlight:Destroy()
        highlights[player] = nil
    end
    if not highlightEnabled then
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = highlightColor
            highlight.OutlineColor = highlightColor
            highlight.FillTransparency = 0.6
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
            highlights[player] = highlight
        end
    end
end

visuals:CreateToggle({
    Name = "Player highlight",
    Flag = "Highlight",
    Desc = "Highlight instance on every other character",
    Callback = function(on)
        highlightEnabled = on
        refreshHighlights()
    end,
})

visuals:CreateColorPicker({
    Name = "Highlight color",
    Flag = "HighlightColor",
    Color = highlightColor,
    Callback = function(color)
        highlightColor = color
        for _, highlight in pairs(highlights) do
            highlight.FillColor = color
            highlight.OutlineColor = color
        end
    end,
})

visuals:CreateSection("Players")

local espTargets = {}
visuals:CreateDropdown({
    Name = "ESP parts",
    Flag = "EspParts",
    Desc = "Multi select",
    Options = { "Head", "Torso", "Arms", "Legs" },
    MultipleOptions = true,
    CurrentOption = { "Head" },
    Callback = function(list)
        espTargets = list
        print("ESP parts:", table.concat(list, ", "))
    end,
})

visuals:CreateButton({
    Name = "Reset lighting",
    Callback = function()
        Lighting.ClockTime = originalClockTime
        brightnessSlider:Set(originalBrightness)
    end,
})

local camera = win:CreateTab({ Name = "Camera", Desc = "View and post-processing", Icon = "camera" })

camera:CreateSection("View")

local originalMaxZoom = LocalPlayer.CameraMaxZoomDistance
camera:CreateSlider({
    Name = "Max zoom distance",
    Range = { 10, 500 },
    Increment = 10,
    CurrentValue = math.clamp(originalMaxZoom, 10, 500),
    Callback = function(value)
        LocalPlayer.CameraMaxZoomDistance = value
    end,
})

camera:CreateDropdown({
    Name = "Camera mode",
    Flag = "CameraMode",
    Options = { "Classic", "Follow", "Orbital", "Track", "Attach", "Watch", "Fixed", "Scriptable" },
    CurrentOption = "Classic",
    Callback = function(choice)
        local modes = {
            Classic = Enum.CameraType.Custom,
            Follow = Enum.CameraType.Follow,
            Orbital = Enum.CameraType.Orbital,
            Track = Enum.CameraType.Track,
            Attach = Enum.CameraType.Attach,
            Watch = Enum.CameraType.Watch,
            Fixed = Enum.CameraType.Fixed,
            Scriptable = Enum.CameraType.Scriptable,
        }
        workspace.CurrentCamera.CameraType = modes[choice] or Enum.CameraType.Custom
    end,
})

local shiftLock = false
camera:CreateToggle({
    Name = "Force shift lock",
    Desc = "Locks the cursor to the centre",
    Callback = function(on)
        shiftLock = on
        UserInputService.MouseBehavior = on and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
    end,
})

camera:CreateSection("Effects")

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Enabled = false
blur.Parent = Lighting

camera:CreateToggle({
    Name = "Blur",
    Callback = function(on)
        blur.Enabled = on
    end,
})

camera:CreateSlider({
    Name = "Blur size",
    Flag = "BlurSize",
    Range = { 0, 56 },
    Increment = 1,
    CurrentValue = 12,
    Callback = function(value)
        blur.Size = value
    end,
})

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Enabled = false
colorCorrection.Parent = Lighting

camera:CreateToggle({
    Name = "Color correction",
    Callback = function(on)
        colorCorrection.Enabled = on
    end,
})

camera:CreateSlider({
    Name = "Saturation",
    Range = { -1, 1 },
    Increment = 0.05,
    CurrentValue = 0,
    Callback = function(value)
        colorCorrection.Saturation = value
    end,
})

camera:CreateSlider({
    Name = "Contrast",
    Range = { -1, 1 },
    Increment = 0.05,
    CurrentValue = 0,
    Callback = function(value)
        colorCorrection.Contrast = value
    end,
})

camera:CreateColorPicker({
    Name = "Tint",
    Color = Color3.new(1, 1, 1),
    Callback = function(color)
        colorCorrection.TintColor = color
    end,
})

camera:CreateKeybind({
    Name = "Toggle blur",
    CurrentKeybind = "B",
    Callback = function()
        blur.Enabled = not blur.Enabled
    end,
})

local server = win:CreateTab({ Name = "Server", Desc = "Session info and players", Icon = "server" })

server:CreateSection("Info")

local playerCountLabel = server:CreateLabel({ Text = "Players: " .. #Players:GetPlayers() })
Players.PlayerAdded:Connect(function()
    playerCountLabel:Set("Players: " .. #Players:GetPlayers())
end)
Players.PlayerRemoving:Connect(function()
    playerCountLabel:Set("Players: " .. (#Players:GetPlayers() - 1))
end)

server:CreateParagraph({
    Title = "Place",
    Content = string.format("PlaceId %d, JobId %s", game.PlaceId, game.JobId ~= "" and game.JobId or "n/a"),
})

server:CreateSection("Players")

local function playerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local spectating = nil
local playerDropdown = server:CreateDropdown({
    Name = "Spectate",
    Desc = "Camera follows the selected player",
    Options = playerNames(),
    Callback = function(name)
        spectating = name
        local player = name and Players:FindFirstChild(name)
        local humanoid = player and player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        workspace.CurrentCamera.CameraSubject = humanoid or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    end,
})

server:CreateButton({
    Name = "Refresh player list",
    Callback = function()
        playerDropdown:Refresh(playerNames(), true)
    end,
})

server:CreateButton({
    Name = "Stop spectating",
    Callback = function()
        spectating = nil
        playerDropdown:Set(nil, true)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        workspace.CurrentCamera.CameraSubject = humanoid
    end,
})

server:CreateSection("Actions")

server:CreateButton({
    Name = "Rejoin",
    Desc = "Teleports back into this place",
    Icon = "refresh-cw",
    Style = "Primary",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

server:CreateInput({
    Name = "Copy to clipboard",
    Desc = "Enter to copy (requires setclipboard)",
    PlaceholderText = "text",
    Callback = function(text, enterPressed)
        if enterPressed and typeof(setclipboard) == "function" then
            setclipboard(text)
            Airflow:Notify({ Title = "Copied", Content = text, Duration = 2, Type = "Success" })
        end
    end,
})

local settings = win:CreateTab({ Name = "Settings", Desc = "Interface and configs", Icon = "settings" })

settings:CreateSection("Window")

settings:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    OnChanged = function(key)
        win:SetKeybind(key)
    end,
})

settings:CreateInput({
    Name = "Config name",
    Icon = "key-round",
    PlaceholderText = "default",
    Callback = function(text, enterPressed)
        if enterPressed and #text > 0 then
            Airflow:Notify({ Title = "Config", Content = "Saved as " .. text, Duration = 3, Type = "Success" })
        end
    end,
})

settings:CreateInput({
    Name = "Refresh rate",
    Desc = "Numeric only",
    PlaceholderText = "60",
    Numeric = true,
    Callback = function(text)
        print("Refresh rate:", tonumber(text))
    end,
})

settings:CreateSection("Appearance")

local accentDemo = settings:CreateColorPicker({
    Name = "Accent preview",
    Desc = "Drives the notification stripe colour below",
    Color = Color3.fromRGB(235, 199, 246),
})

settings:CreateButton({
    Name = "Preview accent",
    Callback = function()
        Airflow:Notify({ Title = "Accent", Content = "Current pick: " .. tostring(accentDemo:Get()), Duration = 3 })
    end,
})

settings:CreateKeybind({
    Name = "Quick notify",
    CurrentKeybind = "N",
    Callback = function()
        Airflow:Notify({ Title = "Ping", Content = os.date("%H:%M:%S"), Duration = 2 })
    end,
})

settings:CreateConfigManager({ Name = "Configs" })

settings:CreateSection("Links")

settings:CreateButton({
    Name = "Discord",
    Desc = "dsc.gg/airflowscript",
    Icon = "message-circle",
    Callback = function()
        if typeof(setclipboard) == "function" then
            setclipboard("https://dsc.gg/airflowscript")
            Airflow:Notify({ Title = "Copied", Content = "Invite link copied", Duration = 2, Type = "Success" })
        end
    end,
})

settings:CreateButton({
    Name = "Website",
    Desc = "airflowscript.com",
    Icon = "globe",
    Callback = function()
        if typeof(setclipboard) == "function" then
            setclipboard("https://airflowscript.com")
            Airflow:Notify({ Title = "Copied", Content = "Website link copied", Duration = 2, Type = "Success" })
        end
    end,
})

settings:CreateDivider()

settings:CreateParagraph({
    Title = "About",
    Content = "Airflow UI example. Every element in this window returns a handle: call :Set(value) to drive it from code, :Get() to read it. Callbacks run inside pcall so a failing callback never breaks the interface.",
})

settings:CreateLabel({ Text = "Press RCtrl to hide or show the window." })

settings:CreateButton({
    Name = "Unload",
    Desc = "Destroys the interface and restores lighting",
    Callback = function()
        Lighting.ClockTime = originalClockTime
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        speedEnabled = false
        applySpeed()
        highlightEnabled = false
        refreshHighlights()
        LocalPlayer.CameraMaxZoomDistance = originalMaxZoom
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        blur:Destroy()
        colorCorrection:Destroy()
        win:Destroy()
    end,
})

win:LoadConfig()

Airflow:Notify({
    Title = "Airflow loaded",
    Content = "5 tabs loaded. RCtrl toggles the window.",
    Duration = 5,
})
