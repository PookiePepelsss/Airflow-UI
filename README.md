# Airflow UI

> A UI library for Roblox. Windows, tabs and thirteen elements with lucide icons and eased motion.

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
```

Every constructor also works without the `Create` prefix. `Tab:Toggle` is the same as `Tab:CreateToggle`.

---

## Window

> The root container. Sidebar with tabs, a content area, the close button and the notification stack.

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "by Pookie",
    ToggleUIKeybind = "RightControl",
    ConfigurationSaving = { Enabled = true, FolderName = "MyHub" },
})

Window:Toggle(false)
```

Drag any empty area to move it and the bottom-right grip to resize it. It scales down on small screens and never leaves the viewport.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Airflow"` | Title in the sidebar header. Also names the ScreenGui. |
| `LoadingSubtitle` | string | — | Small line under the title. |
| `Icon` | string \| table | bird logo | Lucide name, `rbxassetid://` string, or `{ Image, RectOffset, RectSize }`. |
| `ToggleUIKeybind` | string \| KeyCode | `"RightControl"` | Hides and shows the window. `"RightShift"`, `"LeftAlt"`, `"Insert"`, `"F1"`, or an `Enum.KeyCode`. |
| `Size` | UDim2 | `640 × 420` | Starting size. |
| `MinSize` | Vector2 | `480 × 320` | Smallest size the resize grip allows. |
| `MaxSize` | Vector2 | unlimited | Largest size the resize grip allows. |
| `MaxNotifications` | number | `4` | Oldest toast is dismissed past this. |
| `OpenButton` | boolean \| table | touch-only devices | Floating pill that reopens the window. `true` / `false` to force, `{ Title, Icon }` to customise. |
| `Loading` | boolean \| table | `true` | Loading card before the window morphs in. `false` skips it. |
| `Loading.Title` | string | `Name` | Title on the card. |
| `Loading.Text` | string | `LoadingSubtitle` | First status line. |
| `Loading.Steps` | table | 3 built-in lines | Status lines cycled over the duration. |
| `Loading.Duration` | number | `1.6` | Seconds before the window appears. |
| `ConfigurationSaving` | table | — | See [Configs](#configs). |
| `Parent` | Instance | `gethui()` / CoreGui | Where the ScreenGui goes. Falls back to PlayerGui. |

### Handle

| Member | Description |
| --- | --- |
| `.Open` | Whether the window is shown. |
| `.CurrentTab` | The selected tab. |
| `.Tabs` | Array of tabs. |
| `Toggle(open?)` | Show, hide, or flip. |
| `SetKeybind(keyCode)` | Change the hide key. Updates the footer chip. |
| `SelectTab(tab)` | Switch tabs from code. |
| `CreateTab(opts)` | See [Tab](#tab). |
| `Notify(opts)` | See [Notification](#notification). |
| `Confirm(opts)` / `Dialog(opts)` | See [Confirm](#confirm). |
| `SaveConfig / LoadConfig / DeleteConfig / ListConfigs` | See [Configs](#configs). |
| `Destroy()` | Fade out, disconnect everything, remove the gui. |

---

## Tab

> A sidebar button and a scrolling page.

```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Desc = "Movement and actions",
    Icon = "zap",
})

local Tab = Window:CreateTab("Main", "zap")
```

The first tab created is selected automatically. An empty tab shows its icon with `EmptyText`.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Tab"` | Sidebar label and page title. |
| `Desc` | string | — | Muted line under the page title. |
| `Icon` | string \| table | — | Sidebar icon, accent-tinted when selected. |
| `EmptyText` | string | `"Nothing here yet"` | Shown while the tab has no elements. |

### Handle

Every `Create*` element constructor below, plus `.Name` and `.Window`.

---

## Section

> An uppercase heading with a rule to the card edge.

```lua
local Section = Tab:CreateSection("Movement")

Section:Set("Movement (beta)")
```

### Handle

| Member | Description |
| --- | --- |
| `Set(text)` | Replace the heading. |

---

## Divider

> A 1px line.

```lua
Tab:CreateDivider()
```

---

## Label

> A single muted line.

```lua
local Label = Tab:CreateLabel("Players: 12")

Label:Set("Players: 13")
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Text` | string | `""` | The line. A bare string works too. |
| `Color` | Color3 | muted | Text colour. |

### Handle

| Member | Description |
| --- | --- |
| `Set(text)` | Replace the line. |

---

## Paragraph

> A card with a heading and wrapped body text.

```lua
local Paragraph = Tab:CreateParagraph({
    Title = "About",
    Content = "Longer text that wraps across several lines.",
})

Paragraph:Set("Updated body")
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `""` | Heading. |
| `Content` | string | `""` | Body. Wraps and grows the card. |

### Handle

| Member | Description |
| --- | --- |
| `Set(text)` | Replace the body. |

---

## Button

> A full-width card that ripples on click.

```lua
local Button = Tab:CreateButton({
    Name = "Reset character",
    Desc = "Respawns at the last spawn point",
    Icon = "refresh-cw",
    Callback = function()
        print("clicked")
    end,
})

Button:SetText("Respawn")
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Button"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Icon` | string \| table | — | Leading icon. |
| `Style` | string | — | `"Primary"` fills the card with the accent colour. |
| `Callback` | function | — | Runs on click. |

### Handle

| Member | Description |
| --- | --- |
| `SetText(text)` | Replace the label. |

---

## Toggle

> Switch a boolean on and off.

```lua
local Toggle = Tab:CreateToggle({
    Name = "Auto sprint",
    Flag = "AutoSprint",
    CurrentValue = true,
    Callback = function(Value)
        print("Auto sprint:", Value)
    end,
})

Toggle:Set(false)
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Toggle"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `CurrentValue` | boolean | `false` | The initial state. The callback fires once on creation if `true`. |
| `Flag` | string | — | The save key. |
| `Callback` | function | — | Runs with the new value on every change. |

### Handle

| Member | Description |
| --- | --- |
| `.Value` | The current state. |
| `Set(value, skipCallback?)` | Set the state. Pass `true` as the second argument to skip the callback. |
| `Get()` | The current state. |

---

## Slider

> Pick a number in a range.

```lua
local Slider = Tab:CreateSlider({
    Name = "Walk speed",
    Range = { 16, 100 },
    Increment = 1,
    Suffix = " sps",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        print("Walk speed:", Value)
    end,
})

Slider:Set(50)
```

Click the value chip to type an exact number.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Slider"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Range` | table | `{ 0, 100 }` | `{ min, max }`. |
| `Increment` | number | `1` | Snap size. Its decimals set how the value is shown. |
| `Suffix` | string | `""` | Appended to the value chip. |
| `CurrentValue` | number | min | The initial value. |
| `Flag` | string | — | The save key. |
| `Callback` | function | — | Runs with the new value on every change, including while dragging. |

### Handle

| Member | Description |
| --- | --- |
| `.Value` | The current value. |
| `Set(value, skipCallback?)` | Set the value. Slides with a small overshoot. |
| `Get()` | The current value. |

---

## Stepper

> A number with − and + buttons.

```lua
local Stepper = Tab:CreateStepper({
    Name = "Fall threshold",
    Range = { 0, 100 },
    Increment = 5,
    CurrentValue = 50,
    Flag = "FallThreshold",
    Callback = function(Value)
        print("Threshold:", Value)
    end,
})

Stepper:Set(75)
```

Hold either button to repeat.

### Properties

Same as [Slider](#slider).

### Handle

Same as [Slider](#slider).

---

## Progress

> A read-only bar from 0 to 1.

```lua
local Progress = Tab:CreateProgress({
    Name = "Health",
    CurrentValue = 1,
})

Progress:Set(0.5)
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Progress"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `CurrentValue` | number | `0` | The initial fraction. |
| `Color` | Color3 | accent | Fill colour. |
| `Format` | function | percentage | Returns the label text for a fraction. |
| `Callback` | function | — | Runs on `Set` unless skipped. |

### Handle

| Member | Description |
| --- | --- |
| `.Value` | The current fraction. |
| `Set(value, skipCallback?)` | Set the fraction. Eases the fill. |
| `SetColor(color)` | Change the fill colour. |
| `Get()` | The current fraction. |

---

## Dropdown

> Pick one option, or several.

```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Camera mode",
    Options = { "Classic", "Follow", "Orbital", "Track" },
    CurrentOption = "Classic",
    Flag = "CameraMode",
    Callback = function(Option)
        print("Camera mode:", Option)
    end,
})

Dropdown:Set("Follow")
```

Clicking the selected row unchecks it. Lists longer than `SearchAfter` get a search box.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Dropdown"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Options` | table | `{}` | The rows. |
| `CurrentOption` | string \| table | — | The initial selection. A table in multi mode. |
| `MultipleOptions` | boolean | `false` | Rows toggle independently and the callback receives a list. |
| `SearchAfter` | number | `6` | Row count that turns the search box on. |
| `Flag` | string | — | The save key. |
| `Callback` | function | — | Runs with the selection on every change. `nil` when unchecked. |

### Handle

| Member | Description |
| --- | --- |
| `.Open` | Whether the list is expanded. |
| `Set(value, skipCallback?)` | Select a value, or a list in multi mode. |
| `Refresh(options, keepSelection?)` | Replace the rows. |
| `SetOpen(open)` | Expand or collapse. |
| `Get()` | The current selection. |

---

## Input

> A text box.

```lua
local Input = Tab:CreateInput({
    Name = "Player name",
    PlaceholderText = "type here",
    Flag = "PlayerName",
    Callback = function(Text, EnterPressed)
        print("Input:", Text, EnterPressed)
    end,
})

Input:Set("Pookie")
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Input"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Icon` | string \| table | — | Icon inside the box. |
| `PlaceholderText` | string | `""` | Shown while empty. |
| `CurrentValue` | string | `""` | The initial text. |
| `Numeric` | boolean | `false` | Clears the box and skips the callback if the text is not a number. |
| `Flag` | string | — | The save key. |
| `Callback` | function | — | Runs when focus is lost. The second argument is whether Enter was pressed. |

### Handle

| Member | Description |
| --- | --- |
| `Set(text)` | Replace the text. |
| `Get()` | The current text. |

---

## Keybind

> Bind an action to a key.

```lua
local Keybind = Tab:CreateKeybind({
    Name = "Toggle sprint",
    CurrentKeybind = "F",
    Flag = "SprintKey",
    Callback = function(Key)
        print("Pressed:", Key.Name)
    end,
})

Keybind:Set(Enum.KeyCode.G)
```

Click the chip and press a key to rebind. Escape cancels.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Keybind"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `CurrentKeybind` | string \| KeyCode | — | The initial key. |
| `Flag` | string | — | The save key. |
| `Callback` | function | — | Runs when the key is pressed and no text box has focus. |
| `OnChanged` | function | — | Runs when the user rebinds it. |

### Handle

| Member | Description |
| --- | --- |
| `.Value` | The current KeyCode, or `nil`. |
| `.Listening` | Whether the chip is waiting for a key. |
| `Set(keyCode, skipCallback?)` | Rebind. Pass `true` to skip `OnChanged`. |
| `Get()` | The current KeyCode. |

---

## Color Picker

> Pick a colour.

```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Highlight colour",
    Color = Color3.fromRGB(235, 199, 246),
    Flag = "HighlightColor",
    Callback = function(Color)
        print("Colour:", Color)
    end,
})

ColorPicker:Set(Color3.fromRGB(150, 220, 170))
```

The panel has a saturation/value square, a hue bar, a hex box and an RGB readout.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Color"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Color` | Color3 | accent | The initial colour. |
| `Flag` | string | — | The save key. |
| `Callback` | function | — | Runs with the new colour on every change, including while dragging. |

### Handle

| Member | Description |
| --- | --- |
| `.Value` | The current colour. |
| `.Open` | Whether the panel is expanded. |
| `Set(color, skipCallback?)` | Set the colour. Animates the cursors. |
| `SetOpen(open)` | Expand or collapse. |
| `Get()` | The current colour. |

---

## Notification

> A toast in the bottom-right corner.

```lua
local Notification = Airflow:Notify({
    Title = "Loaded",
    Content = "5 tabs ready",
    Icon = "check",
    Type = "Success",
    Duration = 4,
})

Notification:Dismiss()
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `"Notification"` | Bold first line. |
| `Content` | string | — | Wrapped body. |
| `Icon` | string \| table | — | Icon before the title. |
| `Duration` | number | `4` | Seconds before it dismisses itself. |
| `Type` | string | `"Info"` | `"Info"`, `"Success"`, `"Warning"` or `"Error"`. Tints the title. |

### Handle

| Member | Description |
| --- | --- |
| `Dismiss()` | Close it now. |

---

## Confirm

> Ask before doing something.

```lua
Tab:CreateButton({
    Name = "Unload",
    Callback = function()
        Airflow:Confirm({
            Title = "Unload?",
            Content = "The window closes and everything is restored.",
            ConfirmText = "Unload",
            Callback = function()
                Window:Destroy()
            end,
        })
    end,
})
```

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `"Are you sure?"` | Heading. |
| `Content` | string | — | Wrapped body. |
| `Icon` | string \| table | — | Icon before the heading. |
| `ConfirmText` | string | `"Confirm"` | Primary button. |
| `CancelText` | string | `"Cancel"` | Secondary button. |
| `Callback` | function | — | Runs when confirmed. |
| `OnCancel` | function | — | Runs on cancel or a backdrop click. |

`Airflow:Dialog({ Title, Content, Buttons = { { Title, Variant, Callback } } })` builds the same card with any buttons. `CloseOnBackdrop = false` forces a button press.

---

## Flags

> Read and write any element by its save key.

```lua
print(Airflow.Flags.AutoSprint:Get())
Airflow.Flags.WalkSpeed:Set(50)
```

Toggles, sliders, steppers, dropdowns, inputs, keybinds and colour pickers created with a `Flag` are stored on `Airflow.Flags`. Flags are also what configs save.

---

## Configs

> Save every flagged element to a file and load it back.

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    ConfigurationSaving = { Enabled = true, FolderName = "MyHub", FileName = "default" },
})

-- create tabs and elements

Window:LoadConfig()
```

Requires `writefile` / `readfile`. Keybinds are stored by key name, colours as RGB components. Call `LoadConfig` after every element exists.

### Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Enabled` | boolean | `true` | Auto-save 0.5 s after any flagged element changes. |
| `FolderName` | string | `"AirflowUI"` | Folder in the executor workspace. |
| `FileName` | string | `"default"` | Config used when no name is given. |

### Handle

| Member | Description |
| --- | --- |
| `Window:SaveConfig(name?)` | Write `<folder>/<name>.json`. Returns `ok, err`. |
| `Window:LoadConfig(name?, skipCallbacks?)` | Apply a saved config. |
| `Window:DeleteConfig(name)` | Remove the file. |
| `Window:ListConfigs()` | Sorted list of saved names. |
| `Tab:CreateConfigManager({ Name })` | Name input, saved-config dropdown, Save / Load / Delete and an auto-save toggle. Returns `Save / Load / Delete / Refresh`. |

---

## Icons

> Any lucide icon, anywhere an `Icon` is accepted.

```lua
Window:CreateTab({ Name = "Main", Icon = "zap" })
Tab:CreateButton({ Name = "Rejoin", Icon = "refresh-cw" })
```

Names resolve through the [Footagesus/Icons](https://github.com/Footagesus/Icons) list, fetched once on first use; `Airflow:PreloadIcons()` fetches it up front. `rbxassetid://` strings and `{ Image, RectOffset, RectSize }` tables also work.

---

## Theme

> Colours, fonts and assets. Change them before creating a window.

```lua
Airflow.Theme.Accent = Color3.fromRGB(150, 220, 170)

local Family = "rbxasset://fonts/families/Inter.json"
Airflow.Fonts.Medium = Font.new(Family, Enum.FontWeight.Medium)
```

### Properties

| Name | Default | Description |
| --- | --- | --- |
| `Theme.Background` | `20, 16, 20` | Window, toast and dialog fill. |
| `Theme.Surface` | `24, 19, 24` | Chips, text boxes, option rows. |
| `Theme.Surface2` | `28, 22, 28` | Element cards, selected tab. |
| `Theme.Surface3` | `42, 36, 43` | Toggle pill off, tracks. |
| `Theme.Stroke` | `40, 32, 41` | Outlines at rest. |
| `Theme.StrokeHover` | `88, 70, 90` | Outlines on hover, focus, open. |
| `Theme.Accent` | `235, 199, 246` | Highlights, primary buttons, indicator, progress bars. |
| `Theme.AccentDark` | `24, 18, 26` | Text on accent surfaces. |
| `Theme.Text` | `233, 229, 234` | Primary text. |
| `Theme.Muted` | `125, 115, 126` | Secondary text. |
| `Theme.Success` / `Warning` / `Error` | — | Notification title tints. |
| `Fonts.Regular` / `Medium` / `Bold` | Builder Sans | Body text / titles and chips / emphasis. Any Roblox font family works. |
| `Assets.Logo` / `Glow` / `Shadow` | — | Header mark, glow decal, drop shadow. |

`Airflow.Touch` is `true` on touch-only devices; cards, chips and hit areas are larger there automatically.
