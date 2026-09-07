# Airflow UI

A Roblox UI library written in Luau. Windows, tabs and eleven element types with lucide icons and eased motion.

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
```

Every constructor also works without the `Create` prefix, and a bare string can be passed where only a name is needed.

## Window

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "v1.0",
    Icon = "wind",
    ToggleUIKeybind = "RightControl", -- "RightShift", "LeftAlt", "Insert", "F1", or an Enum.KeyCode
    Size = UDim2.fromOffset(640, 420),
    MinSize = Vector2.new(480, 320),
    MaxNotifications = 4,
    OpenButton = nil, -- true / false / { Title, Icon }; defaults to on for touch-only devices
    Loading = { Title = "Airflow", Steps = { "Preparing", "Loading icons", "Ready" }, Duration = 1.6 }, -- or false
    ConfigurationSaving = { Enabled = true, FolderName = "MyHub", FileName = "default" },
})

Window:Toggle()
Window:SetKeybind(Enum.KeyCode.RightShift)
Window:SelectTab(Tab)
Window:Destroy()
```

Drag empty space to move, drag the bottom-right grip to resize. Scales down on small screens and stays inside the viewport.

## Tabs

An empty tab shows a placeholder with its icon and `EmptyText` (default "Nothing here yet").

```lua
local Tab = Window:CreateTab({ Name = "Main", Desc = "Movement and actions", Icon = "zap" })
local Tab = Window:CreateTab("Main", "zap")
```

## Section and divider

```lua
local Header = Tab:CreateSection("Movement")
Header:Set("Movement (beta)")

Tab:CreateDivider()
```

## Label

```lua
local Count = Tab:CreateLabel("Players: 12")
Count:Set("Players: 13")

Tab:CreateLabel({ Text = "Careful", Color = Airflow.Theme.Warning })
```

## Paragraph

```lua
local About = Tab:CreateParagraph({ Title = "About", Content = "Longer text that wraps." })
About:Set("Updated body")
```

## Button

```lua
local Reset = Tab:CreateButton({
    Name = "Reset character",
    Desc = "Respawns at the last spawn point",
    Icon = "refresh-cw",
    Style = "Primary", -- accent fill; omit for the standard card
    Callback = function()
        print("clicked")
    end,
})

Reset:SetText("Respawn")
```

## Toggle

```lua
local Speed = Tab:CreateToggle({
    Name = "Speed boost",
    Desc = "Applies the slider value",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(on)
        print(on)
    end,
})

Speed:Set(true)
Speed:Set(false, true) -- silent
print(Speed:Get())
```

## Slider

Click the value chip to type a number. Decimals shown follow the increment.

```lua
local Fov = Tab:CreateSlider({
    Name = "Field of view",
    Range = { 50, 120 },
    Increment = 0.5,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "Fov",
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end,
})

Fov:Set(90)
print(Fov:Get())
```

## Dropdown

Single mode: clicking the selected row unchecks it. Multi mode: rows toggle independently and the callback gets a list. More than six rows adds a search box.

```lua
local Mode = Tab:CreateDropdown({
    Name = "Camera mode",
    Options = { "Classic", "Follow", "Orbital", "Track" },
    CurrentOption = "Classic",
    Flag = "CameraMode",
    Callback = function(choice)
        print(choice)
    end,
})

local Parts = Tab:CreateDropdown({
    Name = "ESP parts",
    Options = { "Head", "Torso", "Arms", "Legs" },
    MultipleOptions = true,
    CurrentOption = { "Head" },
    Callback = function(list)
        print(table.concat(list, ", "))
    end,
})

Mode:Set("Follow")
Mode:Refresh({ "A", "B", "C" }, true) -- true keeps the selection
Mode:SetOpen(false)
print(Mode:Get())
```

## Input

Fires on focus lost; the second argument is whether Enter was pressed.

```lua
local Name = Tab:CreateInput({
    Name = "Config name",
    Icon = "key-round",
    PlaceholderText = "default",
    Numeric = false,
    Flag = "ConfigName",
    Callback = function(text, enterPressed)
        print(text, enterPressed)
    end,
})

Name:Set("pvp")
print(Name:Get())
```

## Keybind

Click the chip and press a key to rebind, Escape to cancel.

```lua
local Bind = Tab:CreateKeybind({
    Name = "Toggle speed",
    CurrentKeybind = "F",
    Flag = "SpeedKey",
    Callback = function(key)
        print("pressed", key.Name)
    end,
    OnChanged = function(key)
        print("rebound to", key.Name)
    end,
})

Bind:Set(Enum.KeyCode.G)
print(Bind:Get())
```

## Color picker

```lua
local Tint = Tab:CreateColorPicker({
    Name = "Highlight colour",
    Color = Color3.fromRGB(235, 199, 246),
    Flag = "HighlightColor",
    Callback = function(color)
        print(color)
    end,
})

Tint:Set(Color3.fromRGB(150, 220, 170))
Tint:SetOpen(true)
print(Tint:Get())
```

## Notifications

```lua
local Toast = Airflow:Notify({
    Title = "Loaded",
    Content = "5 tabs ready",
    Icon = "check",
    Duration = 4,
    Type = "Success", -- Info, Success, Warning, Error
})

Toast:Dismiss()
```

## Confirm and dialog

Call inside a button's callback; the real action goes in the confirm's `Callback`.

```lua
Tab:CreateButton({
    Name = "Unload",
    Callback = function()
        Airflow:Confirm({
            Title = "Unload?",
            Content = "Everything is restored and the window closes.",
            Icon = "power",
            ConfirmText = "Unload",
            CancelText = "Keep",
            Callback = function()
                Window:Destroy()
            end,
            OnCancel = function() end,
        })
    end,
})

Airflow:Dialog({
    Title = "Choose",
    Content = "Pick one.",
    Buttons = {
        { Title = "Later", Callback = function() end },
        { Title = "Now", Variant = "Primary", Callback = function() end },
    },
})
```

`Window:Confirm` / `Window:Dialog` target a specific window. Clicking the dimmed backdrop cancels unless `CloseOnBackdrop = false`.

## Flags

Any element with a `Flag` is stored on `Airflow.Flags`. Flags are what configs save.

```lua
print(Airflow.Flags.SpeedBoost:Get())
Airflow.Flags.Fov:Set(90)
```

## Configs

Needs `writefile` / `readfile`. Call `LoadConfig` after every element exists.

```lua
Window:LoadConfig()
Window:SaveConfig("pvp")
Window:LoadConfig("pvp")
Window:DeleteConfig("pvp")
print(Window:ListConfigs())

local Manager = SettingsTab:CreateConfigManager({ Name = "Configs" }) -- name input, saved list, Save / Load / Delete, auto-save toggle
```

## Icons

Any lucide name works wherever `Icon` is accepted, plus `rbxassetid://` strings and `{ Image, RectOffset, RectSize }` tables. Fetched once on first use; `Airflow:PreloadIcons()` loads it up front.

## Theme and fonts

Change before creating a window.

```lua
Airflow.Theme.Accent = Color3.fromRGB(150, 220, 170)
Airflow.Theme.Background = Color3.fromRGB(14, 12, 16)

local family = "rbxasset://fonts/families/Inter.json"
Airflow.Fonts.Regular = Font.new(family, Enum.FontWeight.Regular)
Airflow.Fonts.Medium = Font.new(family, Enum.FontWeight.Medium)
Airflow.Fonts.Bold = Font.new(family, Enum.FontWeight.SemiBold)
```

Theme keys: `Background`, `Surface`, `Surface2`, `Surface3`, `Stroke`, `StrokeHover`, `Accent`, `AccentDark`, `Text`, `Muted`, `Success`, `Warning`, `Error`.
