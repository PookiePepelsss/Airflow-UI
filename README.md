# Airflow UI

A Roblox UI library written in Luau. Windows, tabs and eleven element types with lucide icons, eased motion and a Rayfield-compatible API.

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
```

## Contents

- [Quick start](#quick-start)
- [Naming conventions](#naming-conventions)
- [Library](#library)
- [Window](#window)
- [Tabs](#tabs)
- [Elements](#elements)
  - [Section](#section)
  - [Divider](#divider)
  - [Label](#label)
  - [Paragraph](#paragraph)
  - [Button](#button)
  - [Toggle](#toggle)
  - [Slider](#slider)
  - [Dropdown](#dropdown)
  - [Input](#input)
  - [Keybind](#keybind)
  - [Color picker](#color-picker)
- [Notifications](#notifications)
- [Flags](#flags)
- [Configs](#configs)
- [Icons](#icons)
- [Theme, fonts and assets](#theme-fonts-and-assets)

## Quick start

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()

local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "v1.0",
    ToggleUIKeybind = "RightControl",
})

local Tab = Window:CreateTab({ Name = "Main", Icon = "zap" })

Tab:CreateSection("Movement")

Tab:CreateToggle({
    Name = "Speed boost",
    CurrentValue = false,
    Flag = "Speed",
    Callback = function(on)
        print(on)
    end,
})

Tab:CreateSlider({
    Name = "Walk speed",
    Range = { 16, 120 },
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        print(value)
    end,
})

Airflow:Notify({ Title = "Loaded", Content = "Ready to go", Duration = 3 })
```

## Naming conventions

Every constructor exists twice: `CreateToggle` and `Toggle`, `CreateWindow` and `Window`, and so on. Use whichever you prefer; they are the same function.

Argument names accept the Rayfield spelling and the short spelling. The tables in this README list the Rayfield spelling first and the alias after it.

| Rayfield | Alias |
| --- | --- |
| `Title` | `Name` |
| `Description` | `Desc` |
| `CurrentValue`, `Value` | `Default` |
| `Range = { min, max }` | `Min`, `Max` |
| `Increment` | `Step` |
| `CurrentOption` | `Default` |
| `MultipleOptions` | `Multi` |
| `Values` | `Options` |
| `PlaceholderText` | `Placeholder` |
| `CurrentKeybind` | `Default` |
| `Color` | `Default` |
| `LoadingTitle` | `Title`, `Name` |
| `LoadingSubtitle` | `Subtitle` |
| `ToggleUIKeybind` | `Keybind` |
| `Text`, `Message` (notify) | `Content` |
| `Image` (notify) | `Icon` |

Any constructor that takes a table also takes a bare string, which becomes `Name`.

## Library

| Member | Description |
| --- | --- |
| `Airflow:CreateWindow(opts)` / `Airflow:Window(opts)` | Creates a window. See [Window](#window). |
| `Airflow:Notify(opts)` | Sends a toast to the most recently created window. See [Notifications](#notifications). |
| `Airflow:PreloadIcons()` | Fetches the lucide icon list now instead of on first use. Returns `true` on success. |
| `Airflow.Flags` | Table of element handles registered with `Flag`. See [Flags](#flags). |
| `Airflow.Windows` | Array of live windows, oldest first. |
| `Airflow.Theme` | Colour table. See [Theme](#theme-fonts-and-assets). |
| `Airflow.Fonts` | `Regular`, `Medium`, `Bold` as `Font` objects. |
| `Airflow.Assets` | `Shadow`, `Glow`, `Logo` asset ids. |
| `Airflow.Icons` | Named shortcuts: `Key`, `Submit`, `Link`, `Discord`, `Logo`. |

## Window

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "Example build",
    Icon = "wind",
    ToggleUIKeybind = "RightControl",
    Size = UDim2.fromOffset(640, 420),
    MaxNotifications = 4,
    Loading = {
        Title = "Airflow",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 2,
    },
    Parent = nil,
})
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Airflow"` | Title in the sidebar header. Also names the ScreenGui. |
| `LoadingSubtitle` (`Subtitle`) | string | `""` | Small line under the title. |
| `Icon` | string \| table | bird logo | Header mark. Lucide name, asset id, or sprite table. |
| `ToggleUIKeybind` (`Keybind`) | string \| KeyCode | `"RightControl"` | Hides and shows the window. Accepts a KeyCode name (`"RightShift"`, `"LeftAlt"`, `"Insert"`, `"Home"`, `"F1"`, `"Backquote"`) or an `Enum.KeyCode`. Shown as a key-cap chip in the sidebar footer. |
| `Size` | UDim2 | `640 × 420` | Window size in pixels. |
| `MaxNotifications` | number | `4` | The oldest toast is dismissed when the stack would exceed this. |
| `Loading` | boolean \| table | `true` | `false` skips the loading card. A table configures it: `{ Enabled, Title, Text, Steps, Duration }`. |
| `LoadingTitle` | string | `Name` | Title shown on the loading card. |
| `LoadingText` | string | subtitle | First status line on the loading card. |
| `LoadingSteps` | `{ string }` | 3 built-in lines | Status lines cycled evenly across the duration. |
| `LoadingDuration` | number | `1.6` | Seconds the loading card stays before the window animates in. |
| `MinSize` | Vector2 | `480, 320` | Smallest size the resize grip allows. |
| `MaxSize` | Vector2 | unlimited | Largest size the resize grip allows. |
| `OpenButton` | boolean \| `{ Title, Icon }` | on for touch-only devices | Floating, draggable pill that shows or hides the window. Pass `true`/`false` to force it, or a table to customise. |
| `ConfigurationSaving` | `{ Enabled, FolderName, FileName }` | `nil` | Turns on auto-save of flagged elements. See [Configs](#configs). |
| `Parent` | Instance | `PlayerGui` | Where the ScreenGui is placed. |

### Methods

| Method | Description |
| --- | --- |
| `Window:CreateTab(opts)` / `Window:Tab(opts)` | Adds a tab and returns it. Also accepts `("Name", "icon")`. |
| `Window:SelectTab(tab)` | Switches to a tab with the indicator slide and page transition. |
| `Window:Toggle(open?)` | `true` shows, `false` hides, `nil` flips. |
| `Window:SetKeybind(keyCode)` | Changes the hide key and updates the footer chip. |
| `Window:Notify(opts)` | Same as `Airflow:Notify` but targets this window. |
| `Window:SaveConfig(name?)` | Writes every flagged element to `<folder>/<name>.json`. Returns `ok, err`. |
| `Window:LoadConfig(name?, silent?)` | Applies a saved config. `silent` skips callbacks. |
| `Window:DeleteConfig(name)` / `Window:ListConfigs()` | File helpers. |
| `Window:Destroy()` | Fades out, disconnects every listener, removes the ScreenGui and unregisters from `Airflow.Windows`. |

### Properties

| Property | Description |
| --- | --- |
| `Window.Gui` | The ScreenGui. |
| `Window.Root` | The draggable root frame. |
| `Window.Body` | CanvasGroup that holds everything. |
| `Window.Tabs` | Array of tabs in creation order. |
| `Window.CurrentTab` | The selected tab. |
| `Window.Open` | Whether the window is currently shown. |
| `Window.Keybind` | Current hide key. |
| `Window.OpenButton` | The floating pill, when created. |

The window scales itself to fit small viewports (down to 45%), is kept inside the screen after every drag, resize or viewport change, and notifications shrink to fit narrow screens.

## Tabs

```lua
local Tab = Window:CreateTab({
    Name = "Visuals",
    Desc = "Lighting and player visuals",
    Icon = "eye",
})

local Tab = Window:CreateTab("Visuals", "eye")
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Tab"` | Sidebar label and page title. |
| `Desc` (`Description`) | string | `nil` | Muted line under the page title. |
| `Icon` | string \| table | `nil` | Sidebar icon, tinted accent when selected. |

The first tab created is selected automatically. Tabs expose `Tab.Name`, `Tab.Window` and `Tab.List` (the ScrollingFrame that elements go into).

## Elements

Every element is a full-width card added to the tab's page in creation order. Handles returned by the constructors are plain tables; `Set` accepts a second `silent` argument that suppresses the callback.

### Section

```lua
local Header = Tab:CreateSection("Movement")
Header:Set("Movement (beta)")
```

| Argument | Type | Description |
| --- | --- | --- |
| `name` | string \| `{ Name }` | Heading text, rendered uppercase with a rule to the card edge. |

Returns `Set(text)`.

### Divider

```lua
Tab:CreateDivider()
```

A 1px line. Returns nothing.

### Label

```lua
local Count = Tab:CreateLabel("Players: 12")
Count:Set("Players: 13")

Tab:CreateLabel({ Text = "Warning", Color = Airflow.Theme.Warning })
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Text` (`Name`, `Title`) | string | `""` | Line text. |
| `Color` | Color3 | muted | Text colour. |

Returns `Set(text)`.

### Paragraph

```lua
local About = Tab:CreateParagraph({
    Title = "About",
    Content = "Longer text that wraps across several lines.",
})
About:Set("Updated body")
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` (`Name`) | string | `""` | Heading. |
| `Content` | string | `""` | Body, wraps and grows the card. |

Returns `Set(text)` for the body.

### Button

```lua
Tab:CreateButton({
    Name = "Reset character",
    Desc = "Respawns at the last spawn point",
    Icon = "refresh-cw",
    Style = "Primary",
    Callback = function()
        print("clicked")
    end,
})
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Button"` | Main text. |
| `Desc` (`Description`) | string | `nil` | Second line. Makes the card taller. |
| `Icon` | string \| table | `nil` | Leading icon with glow. |
| `Style` | `"Primary"` \| nil | `nil` | Primary fills the card with the accent colour. |
| `Callback` | function() | `nil` | Runs on click, inside `pcall`. |

Returns `SetText(text)`.

### Toggle

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
Speed:Set(false, true)
print(Speed:Get(), Speed.Value)
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Toggle"` | Main text. |
| `Desc` (`Description`) | string | `nil` | Second line. |
| `CurrentValue` (`Default`) | boolean | `false` | Starting state. The callback fires once on creation if `true`. |
| `Flag` | string | `nil` | Registers the handle in `Airflow.Flags`. |
| `Callback` | function(value) | `nil` | Runs when the value changes. |

Returns `Set(value, silent?)`, `Get()`, `.Value`.

### Slider

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
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Slider"` | Main text. |
| `Range` (`Min`, `Max`) | `{ min, max }` | `{ 0, 100 }` | Bounds. |
| `Increment` (`Step`) | number | `1` | Snap size. The number of decimals in the increment sets how the value is displayed. |
| `Suffix` | string | `""` | Appended to the value chip. |
| `CurrentValue` (`Default`) | number | min | Starting value, snapped and clamped. |
| `Flag` | string | `nil` | Registers in `Airflow.Flags`. |
| `Callback` | function(value) | `nil` | Runs on every change, including while dragging. |

Click the value chip to type an exact number; Enter or clicking away applies it (snapped and clamped).

Returns `Set(value, silent?)`, `Get()`, `.Value`.

### Dropdown

```lua
local Mode = Tab:CreateDropdown({
    Name = "Mode",
    Options = { "Classic", "Follow", "Orbital", "Track" },
    CurrentOption = "Classic",
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

Mode:Refresh({ "A", "B", "C" })
Mode:Set("B")
Mode:SetOpen(false)
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Dropdown"` | Main text. |
| `Desc` (`Description`) | string | `nil` | Second line. |
| `Options` (`Values`) | `{ string }` | `{}` | Rows. |
| `CurrentOption` (`Default`) | string \| `{ string }` | `nil` | Initial selection. |
| `MultipleOptions` (`Multi`) | boolean | `false` | Rows toggle independently and the callback receives a list. |
| `SearchAfter` | number | `6` | A search box appears when there are more rows than this. |
| `Flag` | string | `nil` | Registers in `Airflow.Flags`. |
| `Callback` | function(value) | `nil` | A string (or `nil` when unchecked), or a list in multi mode. |

In single mode, clicking the selected row unchecks it and the list stays open; picking a new row closes it. Multi mode never auto-closes.

Returns `Set(value, silent?)`, `Get()`, `Refresh(options, keepSelection?)`, `SetOpen(bool)`, `.Open`.

### Input

```lua
Tab:CreateInput({
    Name = "Config name",
    Desc = "Enter to save",
    Icon = "key-round",
    PlaceholderText = "default",
    CurrentValue = "",
    Numeric = false,
    Callback = function(text, enterPressed)
        if enterPressed then
            print("save", text)
        end
    end,
})
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Input"` | Main text. |
| `Desc` (`Description`) | string | `nil` | Second line. |
| `Icon` | string \| table | `nil` | Icon inside the box. |
| `PlaceholderText` (`Placeholder`) | string | `""` | Shown while empty. |
| `CurrentValue` (`Default`) | string | `""` | Starting text. |
| `Numeric` | boolean | `false` | Clears the box and skips the callback if the text is not a number. |
| `Flag` | string | `nil` | Registers in `Airflow.Flags`. |
| `Callback` | function(text, enterPressed) | `nil` | Runs on focus lost. |

Returns `Set(text)`, `Get()`.

### Keybind

```lua
local Bind = Tab:CreateKeybind({
    Name = "Toggle speed",
    CurrentKeybind = "F",
    Callback = function(key)
        print("pressed", key.Name)
    end,
    OnChanged = function(key)
        print("rebound to", key.Name)
    end,
})

Bind:Set(Enum.KeyCode.G)
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Keybind"` | Main text. |
| `Desc` (`Description`) | string | `nil` | Second line. |
| `CurrentKeybind` (`Default`) | string \| KeyCode | `nil` | Starting key. Strings are looked up in `Enum.KeyCode`. |
| `Flag` | string | `nil` | Registers in `Airflow.Flags`. |
| `Callback` | function(keyCode) | `nil` | Runs when the bound key is pressed and no text box has focus. |
| `OnChanged` | function(keyCode) | `nil` | Runs when the user rebinds. |

Click the chip to listen; the next key binds, Escape cancels. Returns `Set(keyCode, silent?)`, `Get()`, `.Value`, `.Listening`.

### Color picker

```lua
local Tint = Tab:CreateColorPicker({
    Name = "Highlight color",
    Color = Color3.fromRGB(235, 199, 246),
    Callback = function(color)
        print(color)
    end,
})

Tint:Set(Color3.fromRGB(150, 220, 170))
Tint:SetOpen(true)
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` (`Title`) | string | `"Color"` | Main text. |
| `Desc` (`Description`) | string | `nil` | Second line. |
| `Color` (`Default`) | Color3 | accent | Starting colour. |
| `Flag` | string | `nil` | Registers in `Airflow.Flags`. |
| `Callback` | function(color) | `nil` | Runs on every change, including while dragging. |

The panel has a saturation/value square, a vertical hue bar, a hex box (`#RRGGBB` or `RRGGBB`, invalid text reverts) and an RGB readout. `CreateColorpicker` is accepted as an alias.

Returns `Set(color, silent?)`, `Get()`, `SetOpen(bool)`, `.Value`, `.Open`.

## Notifications

```lua
local Toast = Airflow:Notify({
    Title = "Loaded",
    Content = "5 tabs ready",
    Icon = "check",
    Duration = 4,
    Type = "Success",
})

Toast:Dismiss()
```

| Argument | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `"Notification"` | Bold first line. |
| `Content` (`Text`, `Message`) | string | `nil` | Wrapped body. |
| `Icon` (`Image`) | string \| table | `nil` | Icon with glow before the title. |
| `Duration` | number | `4` | Seconds before auto dismiss. |
| `Type` | `"Info"` \| `"Success"` \| `"Warning"` \| `"Error"` | `"Info"` | Tints the title and icon. |

Toasts stack bottom right, slide in with an overshoot, drain a progress bar and can be closed early with the `×`. When the stack exceeds `MaxNotifications` the oldest is dismissed. Returns `Dismiss()`.

## Flags

Pass `Flag` on any toggle, slider, dropdown, input, keybind or colour picker and its handle is stored on `Airflow.Flags` under that name.

```lua
Tab:CreateToggle({ Name = "ESP", Flag = "Esp", CurrentValue = true })
Tab:CreateSlider({ Name = "Speed", Flag = "Speed", Range = { 16, 100 } })

print(Airflow.Flags.Esp:Get())
Airflow.Flags.Speed:Set(50)

for name, element in pairs(Airflow.Flags) do
    print(name, element:Get())
end
```

Flags are what the config system saves.

## Configs

Flagged elements can be written to and read from JSON files wherever `writefile` / `readfile` exist (executors). Keybinds are stored by key name and colours as three 0–1 RGB components.

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    ConfigurationSaving = { Enabled = true, FolderName = "MyHub", FileName = "default" },
})

-- tabs and flagged elements

Window:LoadConfig()            -- call last, once every element exists

Window:SaveConfig("pvp")
Window:LoadConfig("pvp")
Window:DeleteConfig("pvp")
print(Window:ListConfigs())
```

| Option | Default | Description |
| --- | --- | --- |
| `Enabled` | `true` | Auto-save 0.5 s after any flagged element changes. |
| `FolderName` | `"AirflowUI"` | Folder under the executor workspace. |
| `FileName` | `"default"` | Config used when `SaveConfig` / `LoadConfig` get no name. |

`Tab:CreateConfigManager({ Name })` drops a ready-made group into a tab: a name input, a dropdown of saved configs, Save / Load / Delete buttons and an auto-save toggle. It returns `Save(name?)`, `Load(name?)`, `Delete(name?)`, `Refresh()`. `LoadConfiguration` / `SaveConfiguration` are accepted as Rayfield-style aliases.

## Icons

Any lucide icon name works wherever `Icon` is accepted:

```lua
Window:CreateTab({ Name = "Main", Icon = "zap" })
Tab:CreateButton({ Name = "Rejoin", Icon = "refresh-cw" })
Tab:CreateInput({ Name = "Key", Icon = "lucide:key-round" })
```

Names resolve through the [Footagesus/Icons](https://github.com/Footagesus/Icons) asset list, the same one WindUI uses. The list is fetched with `HttpGet` once, on the first icon request; call `Airflow:PreloadIcons()` after loading the library to do it up front. Unknown names print a warning and render nothing.

Also accepted:

```lua
Icon = "rbxassetid://103859712365480"
Icon = { Image = "rbxassetid://...", RectOffset = Vector2.new(0, 0), RectSize = Vector2.new(24, 24) }
```

`Airflow.Icons` holds shortcuts used internally: `Key = "key-round"`, `Submit = "chevron-right"`, `Link = "external-link"`, `Discord = "message-circle"`, `Logo` (asset id).

## Theme, fonts and assets

Change these before creating a window; existing windows are not restyled.

```lua
Airflow.Theme.Accent = Color3.fromRGB(150, 220, 170)
Airflow.Theme.Background = Color3.fromRGB(14, 12, 16)

local family = "rbxasset://fonts/families/Inter.json"
Airflow.Fonts.Regular = Font.new(family, Enum.FontWeight.Regular)
Airflow.Fonts.Medium = Font.new(family, Enum.FontWeight.Medium)
Airflow.Fonts.Bold = Font.new(family, Enum.FontWeight.SemiBold)
```

| Theme key | Default (RGB) | Used for |
| --- | --- | --- |
| `Background` | 20, 16, 20 | Window and toast fill |
| `Surface` | 24, 19, 24 | Chips, text boxes, option rows |
| `Surface2` | 28, 22, 28 | Element cards, selected tab |
| `Surface3` | 42, 36, 43 | Toggle pill off, slider track, dropdown dot off |
| `SurfaceHover` | 40, 33, 41 | Reserved |
| `Stroke` | 40, 32, 41 | Outlines at rest |
| `StrokeHover` | 88, 70, 90 | Outlines on hover, focus, open |
| `Accent` | 235, 199, 246 | Highlights, primary buttons, indicator, progress bar |
| `AccentDark` | 24, 18, 26 | Text on accent surfaces |
| `Text` | 233, 229, 234 | Primary text |
| `Muted` | 125, 115, 126 | Secondary text |
| `Success` | 150, 220, 170 | Notification title tint |
| `Warning` | 240, 176, 108 | Notification title tint |
| `Error` | 240, 120, 120 | Notification title tint |

Fonts default to Builder Sans (`rbxasset://fonts/families/BuilderSans.json`) at Regular, Medium and SemiBold. Assets: `Shadow` (sliced drop shadow), `Glow` (radial glow used behind icons and as ambient decals), `Logo`.
