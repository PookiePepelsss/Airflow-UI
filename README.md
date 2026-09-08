# Airflow UI

Airflow is a UI library for Roblox written in Luau. Windows, tabs and thirteen element types with lucide icons and eased motion.

## Getting Started

### Booting the Library

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
```

### Creating a Window

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "by Pookie",
    Icon = "wind",
    ToggleUIKeybind = "RightControl",
    Size = UDim2.fromOffset(640, 420),
    MinSize = Vector2.new(480, 320),
    MaxSize = nil,
    MaxNotifications = 4,
    OpenButton = nil,
    Loading = {
        Enabled = true,
        Title = "Airflow",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyHub",
        FileName = "default",
    },
    Parent = nil,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Title in the sidebar header. Also names the ScreenGui. |
| LoadingSubtitle | string | Small line under the title. |
| Icon | string \| table | Lucide name, `rbxassetid://` string, or `{ Image, RectOffset, RectSize }`. |
| ToggleUIKeybind | string \| KeyCode | Hides and shows the window. Key names such as `"RightShift"`, `"LeftAlt"`, `"Insert"`, `"F1"`, or an `Enum.KeyCode`. |
| Size | UDim2 | Starting size. Scales itself down to fit small screens. |
| MinSize | Vector2 | Smallest size the resize grip allows. |
| MaxSize | Vector2 | Largest size the resize grip allows. `nil` is unlimited. |
| MaxNotifications | number | Oldest toast is dismissed when the stack would exceed this. |
| OpenButton | boolean \| table | Floating pill that reopens the window. `nil` shows it only on touch-only devices; `true` / `false` forces it; `{ Title, Icon }` customises it. |
| Loading | boolean \| table | Loading card shown before the window morphs in. `false` skips it. |
| Loading.Title | string | Title on the card. Defaults to Name. |
| Loading.Text | string | First status line. Defaults to LoadingSubtitle. |
| Loading.Steps | table | Status lines cycled evenly over the duration. |
| Loading.Duration | number | Seconds before the window appears. |
| ConfigurationSaving | table | See [Configs](#configs). |
| Parent | Instance | Defaults to `gethui()` / CoreGui, then PlayerGui. |

### Updating a Window

```lua
Window:Toggle()                              -- flip visibility; Toggle(true) shows, Toggle(false) hides
Window:SetKeybind(Enum.KeyCode.RightShift)
Window:SelectTab(Tab)
Window:Destroy()
```

Drag any empty area to move the window and the bottom-right grip to resize it. It never leaves the screen.

### Creating a Tab

```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Desc = "Movement and actions",
    Icon = "zap",
    EmptyText = "Nothing here yet",
})

local Tab = Window:CreateTab("Main", "zap")
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Sidebar label and page title. |
| Desc | string | Muted line under the page title. |
| Icon | string \| table | Sidebar icon, accent-tinted when selected. |
| EmptyText | string | Shown with the icon while the tab has no elements. |

The first tab created is selected automatically.

### Creating a Section

```lua
local Section = Tab:CreateSection("Movement")
```

### Updating a Section

```lua
Section:Set("Movement (beta)")
```

### Creating a Divider

```lua
Tab:CreateDivider()
```

### Notifying the user

```lua
local Notification = Airflow:Notify({
    Title = "Loaded",
    Content = "5 tabs ready",
    Icon = "check",
    Duration = 4,
    Type = "Success",
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Title | string | Bold first line. |
| Content | string | Wrapped body text. |
| Icon | string \| table | Icon before the title. |
| Duration | number | Seconds before it dismisses itself. |
| Type | string | `"Info"`, `"Success"`, `"Warning"` or `"Error"`. Tints the title. |

`Window:Notify` does the same for a specific window.

### Dismissing a Notification

```lua
Notification:Dismiss()
```

### Asking for Confirmation

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
```

| Argument | Type | Description |
| --- | --- | --- |
| Title | string | Heading. |
| Content | string | Wrapped body text. |
| Icon | string \| table | Icon before the heading. |
| ConfirmText | string | Primary button text. Defaults to `"Confirm"`. |
| CancelText | string | Secondary button text. Defaults to `"Cancel"`. |
| Callback | function | Runs when confirmed. |
| OnCancel | function | Runs on cancel or when the backdrop is clicked. |

### Creating a Dialog

```lua
Airflow:Dialog({
    Title = "Choose",
    Content = "Pick one.",
    CloseOnBackdrop = true,
    Buttons = {
        { Title = "Later", Callback = function() end },
        { Title = "Now", Variant = "Primary", Callback = function() end },
    },
})
```

## Elements

### Creating a Label

```lua
local Label = Tab:CreateLabel("Players: 12")

local Label = Tab:CreateLabel({
    Text = "Careful",
    Color = Airflow.Theme.Warning,
})
```

### Updating a Label

```lua
Label:Set("Players: 13")
```

### Creating a Paragraph

```lua
local Paragraph = Tab:CreateParagraph({
    Title = "About",
    Content = "Longer text that wraps across several lines.",
})
```

### Updating a Paragraph

```lua
Paragraph:Set("Updated body text")
```

### Creating a Button

```lua
local Button = Tab:CreateButton({
    Name = "Reset character",
    Desc = "Respawns at the last spawn point",
    Icon = "refresh-cw",
    Style = "Primary",
    Callback = function()
        print("clicked")
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Desc | string | Optional second line. |
| Icon | string \| table | Optional leading icon. |
| Style | string | `"Primary"` fills the card with the accent colour. Omit for the standard card. |
| Callback | function | Runs on click. |

### Updating a Button

```lua
Button:SetText("Respawn")
```

### Creating a Toggle

```lua
local Toggle = Tab:CreateToggle({
    Name = "Speed boost",
    Desc = "Applies the slider value",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(Value)
        print(Value)
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Desc | string | Optional second line. |
| CurrentValue | boolean | Starting state. The callback fires once on creation if `true`. |
| Flag | string | Registers the element in `Airflow.Flags` and configs. |
| Callback | function | Runs with the new value. |

### Updating a Toggle

```lua
Toggle:Set(true)
Toggle:Set(false, true) -- silent, no callback
print(Toggle:Get())
```

### Creating a Slider

```lua
local Slider = Tab:CreateSlider({
    Name = "Field of view",
    Range = { 50, 120 },
    Increment = 0.5,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "Fov",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Range | table | `{ min, max }`. |
| Increment | number | Snap size. Its decimals set how the value is displayed. |
| Suffix | string | Appended to the value chip. |
| CurrentValue | number | Starting value. |
| Flag | string | Registers the element in `Airflow.Flags` and configs. |
| Callback | function | Runs on every change, including while dragging. |

Click the value chip to type an exact number.

### Updating a Slider

```lua
Slider:Set(90)
print(Slider:Get())
```

### Creating a Stepper

```lua
local Stepper = Tab:CreateStepper({
    Name = "Fall damage threshold",
    Range = { 0, 100 },
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "FallThreshold",
    Callback = function(Value)
        print(Value)
    end,
})
```

Same arguments as a slider. Hold either button to repeat.

### Updating a Stepper

```lua
Stepper:Set(75)
print(Stepper:Get())
```

### Creating a Progress Bar

```lua
local Progress = Tab:CreateProgress({
    Name = "Health",
    Desc = "Live from the humanoid",
    CurrentValue = 1,
    Color = Airflow.Theme.Success,
    Format = function(Fraction)
        return math.floor(Fraction * 100) .. " hp"
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Desc | string | Optional second line. |
| CurrentValue | number | 0 to 1. |
| Color | Color3 | Fill colour. Defaults to the accent. |
| Format | function | Returns the label text for a fraction. Defaults to a percentage. |
| Callback | function | Runs on `Set` unless silent. |

### Updating a Progress Bar

```lua
Progress:Set(0.5)
Progress:Set(0.5, true) -- silent
Progress:SetColor(Airflow.Theme.Error)
print(Progress:Get())
```

### Creating a Dropdown

```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Camera mode",
    Options = { "Classic", "Follow", "Orbital", "Track" },
    CurrentOption = "Classic",
    MultipleOptions = false,
    SearchAfter = 6,
    Flag = "CameraMode",
    Callback = function(Option)
        print(Option)
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Options | table | Rows. |
| CurrentOption | string \| table | Starting selection. A table in multi mode. `nil` for none. |
| MultipleOptions | boolean | Rows toggle independently and the callback receives a list. |
| SearchAfter | number | A search box appears above this many rows. |
| Flag | string | Registers the element in `Airflow.Flags` and configs. |
| Callback | function | Receives a string (or `nil` when unchecked), or a list in multi mode. |

In single mode, clicking the selected row unchecks it and picking a row closes the list.

### Updating a Dropdown

```lua
Dropdown:Set("Follow")
Dropdown:Refresh({ "A", "B", "C" }, true) -- true keeps the current selection
Dropdown:SetOpen(false)
print(Dropdown:Get())
```

### Creating an Input

```lua
local Input = Tab:CreateInput({
    Name = "Config name",
    Desc = "Enter to save",
    Icon = "key-round",
    PlaceholderText = "default",
    CurrentValue = "",
    Numeric = false,
    Flag = "ConfigName",
    Callback = function(Text, EnterPressed)
        print(Text, EnterPressed)
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Desc | string | Optional second line. |
| Icon | string \| table | Icon inside the box. |
| PlaceholderText | string | Shown while empty. |
| CurrentValue | string | Starting text. |
| Numeric | boolean | Clears the box and skips the callback if the text is not a number. |
| Flag | string | Registers the element in `Airflow.Flags` and configs. |
| Callback | function | Runs when focus is lost. The second argument is whether Enter was pressed. |

### Updating an Input

```lua
Input:Set("pvp")
print(Input:Get())
```

### Creating a Keybind

```lua
local Keybind = Tab:CreateKeybind({
    Name = "Toggle speed",
    CurrentKeybind = "F",
    Flag = "SpeedKey",
    Callback = function(Key)
        print("pressed", Key.Name)
    end,
    OnChanged = function(Key)
        print("rebound to", Key.Name)
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| CurrentKeybind | string \| KeyCode | Starting key. |
| Flag | string | Registers the element in `Airflow.Flags` and configs. |
| Callback | function | Runs when the key is pressed and no text box has focus. |
| OnChanged | function | Runs when the user rebinds it. |

Click the chip and press a key to rebind. Escape cancels.

### Updating a Keybind

```lua
Keybind:Set(Enum.KeyCode.G)
Keybind:Set(Enum.KeyCode.G, true) -- silent, no OnChanged
print(Keybind:Get())
```

### Creating a Color Picker

```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Highlight colour",
    Desc = "Applied to every highlight",
    Color = Color3.fromRGB(235, 199, 246),
    Flag = "HighlightColor",
    Callback = function(Color)
        print(Color)
    end,
})
```

| Argument | Type | Description |
| --- | --- | --- |
| Name | string | Main text. |
| Desc | string | Optional second line. |
| Color | Color3 | Starting colour. |
| Flag | string | Registers the element in `Airflow.Flags` and configs. |
| Callback | function | Runs on every change, including while dragging. |

The panel has a saturation/value square, a hue bar, a hex box and an RGB readout.

### Updating a Color Picker

```lua
ColorPicker:Set(Color3.fromRGB(150, 220, 170))
ColorPicker:SetOpen(true)
print(ColorPicker:Get())
```

## Flags

Any toggle, slider, stepper, dropdown, input, keybind or colour picker created with a `Flag` is stored on `Airflow.Flags` under that name. Flags are also what configs save.

```lua
print(Airflow.Flags.SpeedBoost:Get())
Airflow.Flags.Fov:Set(90)

for Name, Element in pairs(Airflow.Flags) do
    print(Name, Element:Get())
end
```

## Configs

Requires `writefile` / `readfile`. Keybinds are stored by key name, colours as RGB components. Create every element first, then load.

```lua
Window:LoadConfig()             -- uses ConfigurationSaving.FileName
Window:LoadConfig("pvp", true)  -- true applies without firing callbacks
Window:SaveConfig("pvp")        -- returns ok, err
Window:DeleteConfig("pvp")
print(Window:ListConfigs())
```

### Creating a Config Manager

Drops a name input, a dropdown of saved configs, Save / Load / Delete buttons and an auto-save toggle into a tab.

```lua
local Manager = SettingsTab:CreateConfigManager({ Name = "Configs" })

Manager:Save("pvp")
Manager:Load("pvp")
Manager:Delete("pvp") -- asks for confirmation first
Manager:Refresh()
```

## Icons

Any lucide icon name works wherever `Icon` is accepted, alongside `rbxassetid://` strings and `{ Image, RectOffset, RectSize }` tables. The list is fetched once on first use; unknown names warn and render nothing.

```lua
Airflow:PreloadIcons()

Window:CreateTab({ Name = "Main", Icon = "zap" })
Tab:CreateButton({ Name = "Rejoin", Icon = "refresh-cw" })
Tab:CreateInput({ Name = "Key", Icon = "lucide:key-round" })
```

## Theme and Fonts

Change these before creating a window. Existing windows are not restyled.

```lua
Airflow.Theme.Accent = Color3.fromRGB(150, 220, 170)
Airflow.Theme.Background = Color3.fromRGB(14, 12, 16)

local Family = "rbxasset://fonts/families/Inter.json"
Airflow.Fonts.Regular = Font.new(Family, Enum.FontWeight.Regular)
Airflow.Fonts.Medium = Font.new(Family, Enum.FontWeight.Medium)
Airflow.Fonts.Bold = Font.new(Family, Enum.FontWeight.SemiBold)
```

| Key | Used for |
| --- | --- |
| Background | Window, toast and dialog fill |
| Surface | Chips, text boxes, option rows |
| Surface2 | Element cards, selected tab |
| Surface3 | Toggle pill off, tracks |
| Stroke | Outlines at rest |
| StrokeHover | Outlines on hover, focus, open |
| Accent | Highlights, primary buttons, indicator, progress bars |
| AccentDark | Text on accent surfaces |
| Text | Primary text |
| Muted | Secondary text |
| Success, Warning, Error | Notification title tints |

`Airflow.Touch` is `true` on touch-only devices; cards, chips, toggles and hit areas are larger there automatically.
