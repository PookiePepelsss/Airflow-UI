# Airflow UI

> A UI library for Roblox. Windows, tabs and thirteen elements with lucide icons, eased motion and live themes.

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
```

## Quick start

```lua
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()

local Window = Airflow:CreateWindow({
    Name = "My Hub",
    Theme = "Midnight",
    ConfigurationSaving = { Enabled = true, FolderName = "MyHub" },
})

local Main = Window:CreateTab({ Name = "Main", Icon = "zap" })

Main:CreateToggle({
    Name = "Auto sprint",
    Flag = "AutoSprint",
    Callback = function(Value)
        print("Auto sprint:", Value)
    end,
})

Window:LoadConfig()
```

[`Example.luau`](Example.luau) builds one of everything. It contains the full readable library followed by the demo, so it runs on its own without fetching `Source.luau`.

## Contents

- [Window](#window) · [Home](#home) · [Tab](#tab)
- [Every element](#every-element) — options and methods all elements share
- Elements: [Section](#section) · [Divider](#divider) · [Label](#label) · [Paragraph](#paragraph) · [Button](#button) · [Toggle](#toggle) · [Slider](#slider) · [Stepper](#stepper) · [Progress](#progress) · [Dropdown](#dropdown) · [Input](#input) · [Keybind](#keybind) · [Color Picker](#color-picker)
- [Notification](#notification) · [Confirm and Dialog](#confirm-and-dialog)
- [Themes](#themes) · [Flags](#flags) · [Configs](#configs) · [Icons](#icons) · [Fonts](#fonts) · [Assets](#assets)

### Conventions

- Every constructor works with or without the `Create` prefix: `Tab:Toggle` is `Tab:CreateToggle`.
- Option names have aliases so Rayfield-style scripts work unchanged: `Title` → `Name`, `Description` → `Desc`, `CurrentValue` / `Value` → `Default`, `Increment` → `Step`, `Range = { min, max }` → `Min` / `Max`.
- `Set(value, skipCallback)` on any element changes its value and fires its callback unless the second argument is `true`.
- Callbacks run protected. An error inside one prints a `[AirFlow] callback error` warning instead of breaking the UI.

---

## Window

> The root container: a sidebar of tabs, the content area, a close button and the notification stack.

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "by Pookie",
    Icon = "wind",
    Theme = "Default",
    ToggleUIKeybind = "RightControl",
    Size = UDim2.fromOffset(640, 480),
    MinSize = Vector2.new(480, 360),
    MaxSize = Vector2.new(1000, 700),
    MaxNotifications = 4,
    KeepOnScreen = true,
    OpenButton = { Title = "Airflow", Icon = "wind" },
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
    Home = { Name = "Home" },
    Parent = game:GetService("CoreGui"),
})
```

Drag any empty area to move the window and the grip in the bottom-right corner to resize it. It scales down on small screens and stays inside the viewport.

### Options

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Airflow"` | Title in the sidebar header. Also names the ScreenGui. |
| `LoadingSubtitle` | string | — | Small line under the title. |
| `Icon` | string \| table | bird logo | See [Icons](#icons). |
| `Theme` | string \| table | current theme | Applied before the window is built. See [Themes](#themes). |
| `ToggleUIKeybind` | string \| KeyCode | `"RightControl"` | Hides and shows the window. An unknown name warns and falls back to the default. |
| `Size` | UDim2 | `640 × 480` | Starting size in offsets. Screen fitting and the resize grip only read the offset part. |
| `MinSize` | Vector2 | `480 × 360` | Smallest size the resize grip allows. |
| `MaxSize` | Vector2 | unlimited | Largest size the resize grip allows. |
| `MaxNotifications` | number | `4` | The oldest toast is dismissed past this. |
| `KeepOnScreen` | boolean | `true` | Nudge the window back inside the viewport after a drag, resize or screen change. |
| `OpenButton` | boolean \| table | touch-only devices | Floating pill that reopens the window. `true` / `false` forces it, `{ Title, Icon }` customises it. |
| `Loading` | boolean \| table | `true` | Loading card before the window morphs in. `false` skips it. |
| `Loading.Title` / `Text` / `Steps` / `Duration` | — | `Name` / `LoadingSubtitle` / 3 lines / `1.6` | Card title, first status line, status lines cycled over the duration, seconds before the window appears. |
| `ConfigurationSaving` | table | — | See [Configs](#configs). |
| `Home` | boolean \| table | — | Adds a first tab with a greeting and live session stats. See [Home](#home). |
| `Parent` | Instance | `gethui()` → CoreGui → PlayerGui | Where the ScreenGui goes. |

### Handle

| Member | Description |
| --- | --- |
| `.Open` | Whether the window is shown. |
| `.CurrentTab` / `.Tabs` | The selected tab and the array of all tabs. |
| `.Home` | The home tab, when one was created. |
| `.Flags` | This window's flagged elements. See [Flags](#flags). |
| `Toggle(open?)` | Show, hide, or flip when called with no argument. |
| `SelectTab(tab)` | Switch tabs from code. Accepts a tab or its name. |
| `SetTitle(text)` / `SetSubtitle(text)` / `SetIcon(icon)` | Change the sidebar header. |
| `SetKeybind(key)` | Change the hide key. Accepts a KeyCode or its name and updates the footer chip. |
| `SetKeepOnScreen(enabled)` | Turn the viewport clamp on or off. |
| `CreateTab(opts)` | See [Tab](#tab). |
| `Notify(opts)` | See [Notification](#notification). |
| `Confirm(opts)` / `Dialog(opts)` | See [Confirm and Dialog](#confirm-and-dialog). |
| `SaveConfig` / `LoadConfig` / `DeleteConfig` / `ListConfigs` | See [Configs](#configs). |
| `Destroy()` | Fade out, disconnect everything, release this window's flags and remove the gui. |

---

## Home

> An optional first tab: a greeting card, live session stats, and pages of your own.

```lua
Home = {
    Name = "Home",
    Desc = "Session",
    Icon = "layout-dashboard",
    Welcome = "Hello, ",
    Greeting = "Good to see you.",
    SectionName = "System info",
    Stats = { "FPS", "Ping", "Executor", "Game", "Region", "Time", "Players", "Uptime" },
    TimeFormat = "%H:%M",
    Pages = {
        {
            Name = "Changelog",
            Icon = "scroll-text",
            Entries = {
                { Title = "v1.3", Tag = "Latest", Changes = { "Live themes" } },
                { Title = "v1.2", Date = "Aug 30", Content = "Plain text instead of bullets." },
            },
        },
        { Name = "Info", Icon = "info", Content = "Wrapped text in a card." },
        { Name = "Custom", Icon = "wrench", Build = function(Frame) end },
    },
}
```

Stats refresh once a second and pause while the window is hidden or another tab is open. Pages appear as a pill strip above the content; the greeting only shows on the first page. `"Region"` asks `ipinfo.io` through the executor's `request` function and shows `Unavailable` without one.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` / `Desc` / `Icon` | string | `"Home"` / — / `"house"` | The tab itself. |
| `Welcome` | string | `"Hello, "` | Prefix before the player's display name. |
| `Greeting` | string | time of day | Second line under the welcome. |
| `SectionName` | string | `"System info"` | Heading above the stat cards. `Sections = false` hides it. |
| `Stats` | table | first six | Any of `"FPS"`, `"Ping"`, `"Executor"`, `"Game"`, `"Region"`, `"Time"`, `"Players"`, `"Uptime"`. |
| `TimeFormat` | string | `"%H:%M"` | `os.date` format for the time card. |
| `TabIcon` | string | `"layout-grid"` | Icon on the built-in details page button. |
| `Pages[n].Name` / `Icon` | string | — | The page button. |
| `Pages[n].Content` | string | — | Wrapped text in a card. |
| `Pages[n].Entries` | table | — | Cards with `Title`, `Tag` or `Date`, and `Changes` (a list) or `Content`. |
| `Pages[n].Build` | function | — | `function(Frame)` to fill the page yourself. |

---

## Tab

> A sidebar button and a scrolling page.

```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Desc = "Movement and actions",
    Icon = "zap",
    EmptyText = "Nothing here yet",
})

local Tab = Window:CreateTab("Main", "zap")

Tab:Select()
```

The first tab created is selected automatically. An empty tab shows its icon above `EmptyText`.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Tab"` | Sidebar label and page title. |
| `Desc` | string | — | Muted line under the page title. |
| `Icon` | string \| table | — | Sidebar icon, accent-tinted when selected. |
| `EmptyText` | string | `"Nothing here yet"` | Shown while the tab has no elements. |

The handle has every element constructor below, `Select()`, `.Name` and `.Window`.

---

## Every element

These options work on every element that sits in a card.

| Option | Type | Description |
| --- | --- | --- |
| `Flag` | string | Save key. Registers the element on `Airflow.Flags` and `Window.Flags`. |
| `Locked` | boolean | Start locked: dimmed, with a lock pill, ignoring clicks, drags and keybinds. |
| `LockedReason` | string | Text in the lock pill. Defaults to `"Locked"`. |
| `Visible` | boolean | `false` creates it hidden. |

And every handle has these methods:

| Method | Description |
| --- | --- |
| `SetTitle(text)` | Replace the label. |
| `SetDesc(text)` | Replace the description. Only for elements created with a `Desc`. |
| `SetLocked(locked, reason?)` | Lock or unlock. Locking also collapses dropdowns and colour pickers. `.Locked` holds the state. |
| `SetVisible(visible)` | Show or hide the card; the list closes the gap. `.Visible` holds the state. |
| `Destroy()` | Remove the card, its listeners and its flag. |

Locking only blocks input. `Set` from your own code still works.

```lua
local Fly = Tab:CreateToggle({ Name = "Fly", Locked = true, LockedReason = "Premium" })

Fly:SetLocked(false)
Fly:SetTitle("Fly (unlocked)")
```

---

## Section

> An uppercase heading with a rule to the card edge.

```lua
local Section = Tab:CreateSection("Movement")

Section:Set("Movement (beta)")
```

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

> A single muted line. Can refresh itself.

```lua
local Label = Tab:CreateLabel({
    Text = "Players: 12",
    Color = Airflow.Theme.Muted,
    UpdateRate = 1,
    Update = function()
        return "Players: " .. #game.Players:GetPlayers()
    end,
})

local Label = Tab:CreateLabel("Players: 12")

Label:Set("Players: 13")
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Text` | string | `""` | The line. A bare string works too. |
| `Color` | Color3 | muted | Text colour. |
| `Update` | function | — | Called on a timer; its return value becomes the text. Stops when the label is destroyed. |
| `UpdateRate` | number | `1` | Seconds between `Update` calls. Minimum `0.05`. |

| Member | Description |
| --- | --- |
| `Set(text)` / `Get()` | Replace or read the line. |
| `SetUpdateRate(seconds)` | Change the timer, when `Update` was given. |

---

## Paragraph

> A card with a heading and wrapped body text.

```lua
local Paragraph = Tab:CreateParagraph({
    Title = "About",
    Content = "Longer text that wraps across several lines.",
})

Paragraph:Set("Updated body")
Paragraph:SetTitle("About this hub")
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `""` | Heading. |
| `Content` | string | `""` | Body. Wraps and grows the card. |

| Member | Description |
| --- | --- |
| `Set(text)` / `Get()` | Replace or read the body. |
| `SetTitle(text)` | Replace the heading. |

---

## Button

> A full-width card that ripples on click.

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

Button:SetText("Respawn")
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Button"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Icon` | string \| table | — | Leading icon. |
| `Style` | string | — | `"Primary"` fills the card with the accent colour, `"Danger"` with the error colour. |
| `Callback` | function | — | Runs on click. |

| Member | Description |
| --- | --- |
| `SetText(text)` | Replace the label. Same as `SetTitle`. |

---

## Toggle

> Switch a boolean on and off.

```lua
local Toggle = Tab:CreateToggle({
    Name = "Auto sprint",
    Desc = "Hold shift to run",
    CurrentValue = true,
    Flag = "AutoSprint",
    Callback = function(Value)
        print("Auto sprint:", Value)
    end,
})

Toggle:Set(false)
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Toggle"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `CurrentValue` | boolean | `false` | Initial state. The callback fires once on creation when `true`. |
| `Flag` | string | — | Save key. |
| `Callback` | function | — | Runs with the new value on every change. |

| Member | Description |
| --- | --- |
| `.Value` / `Get()` | The current state. |
| `Set(value, skipCallback?)` | Set the state. |

---

## Slider

> Pick a number in a range.

```lua
local Slider = Tab:CreateSlider({
    Name = "Walk speed",
    Desc = "Studs per second",
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

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Slider"` | The label. |
| `Desc` | string | — | Hint text under the label. Makes the card taller. |
| `Range` | table | `{ 0, 100 }` | `{ min, max }`. A reversed range is swapped. |
| `Increment` | number | `1` | Snap size. Its decimals (up to 6) set how the value is shown, and values are rounded to them, so `0.1` steps give `0.3`, never `0.30000000000000004`. |
| `Suffix` | string | `""` | Appended to the value chip. |
| `CurrentValue` | number | min | Initial value. |
| `Flag` | string | — | Save key. |
| `Callback` | function | — | Runs with the new value on every change, including while dragging. |
| `OnRelease` | function | — | Runs once with the final value when a drag ends. Use it for work too heavy to repeat every frame. |

| Member | Description |
| --- | --- |
| `.Value` / `Get()` | The current value. |
| `Set(value, skipCallback?)` | Set the value. Snapped, clamped, and eased with a small overshoot. |

---

## Stepper

> A number with − and + buttons.

```lua
local Stepper = Tab:CreateStepper({
    Name = "Fall threshold",
    Desc = "Distance before damage",
    Range = { 0, 100 },
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "FallThreshold",
    Callback = function(Value)
        print("Threshold:", Value)
    end,
})

Stepper:Set(75)
```

Hold either button to repeat after 0.4 s.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Stepper"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Range` | table | `{ 0, 100 }` | `{ min, max }`. |
| `Increment` | number | `1` | Step per press. Decimals behave as on the slider. |
| `Suffix` | string | `""` | Appended to the value. |
| `CurrentValue` | number | min | Initial value. |
| `Flag` | string | — | Save key. |
| `Callback` | function | — | Runs with the new value on every change. |

| Member | Description |
| --- | --- |
| `.Value` / `Get()` | The current value. |
| `Set(value, skipCallback?)` | Set the value, snapped and clamped. |

---

## Progress

> A read-only bar from 0 to 1.

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

Progress:Set(0.5)
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Progress"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `CurrentValue` | number | `0` | Initial fraction. |
| `Color` | Color3 | accent | Fill colour. |
| `Format` | function | percentage | Returns the label text for a fraction. |
| `Callback` | function | — | Runs on `Set` unless skipped. |

| Member | Description |
| --- | --- |
| `.Value` / `Get()` | The current fraction. |
| `Set(value, skipCallback?)` | Set the fraction, clamped to 0–1. Eases the fill. |
| `SetColor(color)` | Change the fill colour. |

---

## Dropdown

> Pick one option, or several.

```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Camera mode",
    Desc = "Applied to the current camera",
    Options = { "Classic", "Follow", "Orbital", "Track" },
    CurrentOption = "Classic",
    MultipleOptions = false,
    Placeholder = "None",
    SearchAfter = 6,
    Flag = "CameraMode",
    Callback = function(Option)
        print("Camera mode:", Option)
    end,
})

Dropdown:Set("Follow")
Dropdown:Refresh({ "Classic", "Follow" }, true)
```

Clicking the selected row unchecks it. Lists longer than `SearchAfter` get a search box.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Dropdown"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Options` | table | `{}` | The rows. Values are shown with `tostring`, so numbers work. |
| `CurrentOption` | any \| table | — | Initial selection. A table in multi mode. |
| `MultipleOptions` | boolean | `false` | Rows toggle independently and the callback receives a list. |
| `Placeholder` | string | `"None"` | Chip text while nothing is selected. |
| `SearchAfter` | number | `6` | Row count above which the search box appears. |
| `Flag` | string | — | Save key. |
| `Callback` | function | — | Runs with the selection on every change: a value (`nil` when unchecked), or a list in multi mode. |

| Member | Description |
| --- | --- |
| `.Open` | Whether the list is expanded. |
| `Get()` | The current selection. |
| `Set(value, skipCallback?)` | Select a value, or a list in multi mode. |
| `Refresh(options, keepSelection?)` | Replace the rows. |
| `SetOpen(open)` | Expand or collapse. |

---

## Input

> A text box that grows with what you type.

```lua
local Input = Tab:CreateInput({
    Name = "Player name",
    Desc = "Partial names work",
    Icon = "user",
    PlaceholderText = "type here",
    CurrentValue = "",
    MaxLength = 20,
    Numeric = false,
    ClearOnFocus = false,
    Flag = "PlayerName",
    OnChanged = function(Text)
        print("Typing:", Text)
    end,
    Callback = function(Text, EnterPressed)
        print("Input:", Text, EnterPressed)
    end,
})

Input:Set("Pookie")
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Input"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Icon` | string \| table | — | Icon inside the box. |
| `PlaceholderText` | string | `""` | Shown while empty. |
| `CurrentValue` | string | `""` | Initial text. |
| `MaxLength` | number | — | Longer text is cut to this many characters. |
| `Numeric` | boolean | `false` | On focus loss, clears the box and skips the callback when the text is not a number. |
| `ClearOnFocus` | boolean | `false` | Empty the box when it gains focus. |
| `Flag` | string | — | Save key. |
| `OnChanged` | function | — | Runs on every keystroke while the box has focus. |
| `Callback` | function | — | Runs when focus is lost, and on `Set`. The second argument is whether Enter was pressed. |

| Member | Description |
| --- | --- |
| `Get()` | The current text. |
| `Set(text, skipCallback?)` | Replace the text and fire `Callback(text, false)`. |
| `SetPlaceholder(text)` | Replace the placeholder. |

---

## Keybind

> Bind an action to a key.

```lua
local Keybind = Tab:CreateKeybind({
    Name = "Sprint",
    Desc = "Hold to run",
    CurrentKeybind = "LeftShift",
    Mode = "Hold",
    Flag = "SprintKey",
    Callback = function(Held)
        print("Sprinting:", Held)
    end,
    OnChanged = function(Key)
        print("Rebound to:", Key and Key.Name)
    end,
})

Keybind:Set("G")
```

Click the chip and press a key to rebind. Escape cancels; Backspace or Delete clears the binding.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Keybind"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `CurrentKeybind` | string \| KeyCode | — | Initial key. An unknown name warns and leaves it unbound. |
| `Mode` | string | `"Press"` | `"Press"` calls `Callback(KeyCode)` on key down. `"Hold"` calls `Callback(true)` on key down and `Callback(false)` on key up. |
| `Flag` | string | — | Save key. Rebinding triggers autosave. |
| `Callback` | function | — | Runs on the key while no text box has focus and the element is not locked. |
| `OnChanged` | function | — | Runs with the new KeyCode, or `nil`, when it is rebound. |

| Member | Description |
| --- | --- |
| `.Value` / `Get()` | The current KeyCode, or `nil`. |
| `.Listening` | Whether the chip is waiting for a key. |
| `.Held` | In hold mode, whether the key is down. |
| `Set(key, skipCallback?)` | Rebind. Accepts a KeyCode, its name or `nil`. Pass `true` to skip `OnChanged`. |

---

## Color Picker

> Pick a colour.

```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Highlight colour",
    Desc = "Applied to every highlight",
    Color = Color3.fromRGB(235, 199, 246),
    Flag = "HighlightColor",
    Callback = function(Color)
        print("Colour:", Color)
    end,
})

ColorPicker:Set(Color3.fromRGB(150, 220, 170))
ColorPicker:Set("#96DCAA")
```

The panel has a saturation/value square, a hue bar, a hex box and an RGB readout.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"Color"` | The label. |
| `Desc` | string | — | Hint text under the label. |
| `Color` | Color3 \| string | accent | Initial colour, as a Color3 or hex string. |
| `Flag` | string | — | Save key. |
| `Callback` | function | — | Runs with the new colour on every change, including while dragging. |

| Member | Description |
| --- | --- |
| `.Value` / `Get()` | The current colour. |
| `.Open` | Whether the panel is expanded. |
| `Set(color, skipCallback?)` | Set from a Color3 or hex string. Anything else warns and is ignored. |
| `SetOpen(open)` | Expand or collapse. |

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

Window:Notify({ Title = "Window specific" })

Notification:Dismiss()
```

`Airflow:Notify` uses the most recently created window and returns `nil` when none exists.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `"Notification"` | First line. |
| `Content` | string | — | Wrapped body. |
| `Icon` | string \| table | — | Icon before the title. |
| `Duration` | number | `4` | Seconds before it dismisses itself. |
| `Type` | string | — | `"Info"`, `"Success"`, `"Warning"` or `"Error"`. Colours the edge, icon and timer bar; the last three also tint the title. |

| Member | Description |
| --- | --- |
| `Dismiss()` | Close it now. |

---

## Confirm and Dialog

> Ask before doing something.

```lua
Airflow:Confirm({
    Title = "Unload?",
    Content = "The window closes and everything is restored.",
    Icon = "power",
    ConfirmText = "Unload",
    CancelText = "Keep",
    Callback = function()
        Window:Destroy()
    end,
    OnCancel = function()
        print("Kept")
    end,
})

Airflow:Dialog({
    Title = "Choose",
    Content = "Pick one.",
    Icon = "list",
    CloseOnBackdrop = true,
    Buttons = {
        { Title = "Later", Callback = function() end },
        { Title = "Now", Variant = "Primary", Callback = function() end },
    },
})
```

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | string | `"Are you sure?"` | Heading. |
| `Content` | string | — | Wrapped body. |
| `Icon` | string \| table | — | Icon before the heading. |
| `ConfirmText` / `CancelText` | string | `"Confirm"` / `"Cancel"` | Button labels (Confirm only). |
| `Callback` | function | — | Runs when confirmed (Confirm only). |
| `OnCancel` | function | — | Runs on cancel, a backdrop click or Escape. |
| `Buttons` | table | — | Dialog only: `{ Title, Variant, Callback }` per button. `Variant = "Primary"` gives the accent fill. |
| `CloseOnBackdrop` | boolean | `true` | `false` forces a button press: backdrop clicks and Escape are ignored. |

Opening a dialog closes any dialog already open in that window. Both return a handle with `Close()` (closes silently) and `Cancel()` (closes and runs `OnCancel`).

---

## Themes

> Six built-in palettes, your own palettes, and live switching.

```lua
Airflow:SetTheme("Midnight")

Airflow:SetTheme({ Accent = Color3.fromRGB(120, 200, 255) })

Airflow:AddTheme("Ocean", {
    Base = "Midnight",
    Accent = Color3.fromRGB(90, 210, 220),
    AccentDark = Color3.fromRGB(8, 24, 28),
})

Settings:CreateThemePicker({ Flag = "Theme" })
```

`SetTheme` recolours every open window in place, so switching mid-session is fine. Themes are global: all windows share one. Built in: `Default`, `Midnight`, `Moss`, `Ember`, `Rose`, `Mono`.

A theme table only needs the colours it changes. Missing keys come from `Base` (default `"Default"`).

| Function | Description |
| --- | --- |
| `Airflow:SetTheme(nameOrTable)` | Apply a theme. Returns `false` and warns for an unknown name. |
| `Airflow:AddTheme(name, table)` | Register a theme so `SetTheme(name)` and the picker can use it. |
| `Airflow:GetThemes()` | Theme names, `Default` first then alphabetical. |
| `Airflow.Theme` | The live colour table. Read it; change it through `SetTheme`. |
| `Airflow.ThemeName` | The current theme's name, `"Custom"` for an unnamed table. |
| `Tab:CreateThemePicker({ Name?, Desc?, Flag?, Callback? })` | A dropdown of every theme. With a `Flag`, configs remember the choice. |

| Key | Used for |
| --- | --- |
| `Background` | Window, toast and dialog fill. |
| `Surface` | Chips, text boxes, option rows. |
| `Surface2` | Element cards, selected tab. |
| `Surface3` | Toggle pill off, tracks. |
| `Stroke` / `StrokeHover` | Outlines at rest / on hover, focus and open. |
| `Accent` | Highlights, primary buttons, indicator, progress bars. |
| `AccentDark` | Text and icons on accent or danger fills. |
| `Text` / `Muted` | Primary and secondary text. Built-in `Muted` colours keep at least 4.5:1 contrast on cards. |
| `Glow` | Tint of the soft glow decals. |
| `Success` / `Warning` / `Error` | Notification types and `Danger` buttons. |

---

## Flags

> Read and write any element by its save key.

```lua
print(Airflow.Flags.AutoSprint:Get())
Airflow.Flags.WalkSpeed:Set(50)

print(Window.Flags.WalkSpeed.Value)
```

Elements created with a `Flag` are stored on `Airflow.Flags` (all windows) and on `Window.Flags` (that window only). Configs save and load `Window.Flags`. Destroying an element or its window removes its flags.

---

## Configs

> Save every flagged element to a file and load it back.

```lua
local Window = Airflow:CreateWindow({
    Name = "Airflow",
    ConfigurationSaving = { Enabled = true, FolderName = "MyHub", FileName = "default", AutoSave = true },
})

-- create tabs and elements

Window:LoadConfig()
```

Requires `writefile`, `readfile` and `isfile`; listing and deleting also need `listfiles`, `isfolder` and `delfile`. Call `LoadConfig` after every element exists. Keybinds are stored by key name and colours as RGB components. Config names are cleaned to a single file name: slashes, `..` and characters invalid in file names are removed.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Enabled` | boolean | `true` | Turns config saving on for this window. |
| `AutoSave` | boolean | `false` | Save 0.5 s after any flagged element changes. Also switchable at runtime with `Window:SetAutoSave(on)` or the config manager toggle. |
| `FolderName` | string | `"AirflowUI"` | Folder in the executor workspace. |
| `FileName` | string | `"default"` | Config used when no name is given. |

| Member | Description |
| --- | --- |
| `Window:SaveConfig(name?)` | Write `<folder>/<name>.json`. Returns `ok, err`. |
| `Window:LoadConfig(name?, skipCallbacks?)` | Apply a saved config. Returns `ok, err`. Flags that fail to apply print a warning. |
| `Window:DeleteConfig(name)` | Remove the file. Returns `ok, err`. |
| `Window:ListConfigs()` | Sorted list of saved names. |
| `Window:SetAutoSave(enabled)` | Turn autosave on or off. |
| `Tab:CreateConfigManager({ Name })` | Name input, saved-config dropdown, Save / Load / Delete and an auto-save toggle. Returns a handle with `Save(name?)`, `Load(name?)`, `Delete(name?)` and `Refresh()`. |

---

## Icons

> Any lucide icon, anywhere an `Icon` is accepted.

```lua
Airflow:PreloadIcons()

Window:CreateTab({ Name = "Main", Icon = "zap" })
Tab:CreateInput({ Name = "Key", Icon = "lucide:key-round" })
Window:CreateTab({ Name = "Custom", Icon = "rbxassetid://103859712365480" })
Tab:CreateButton({
    Name = "Sprite",
    Icon = { Image = "rbxassetid://122605056588923", RectOffset = Vector2.new(325, 775), RectSize = Vector2.new(24, 24) },
})
```

Names resolve through the [Footagesus/Icons](https://github.com/Footagesus/Icons) list, fetched once on first use. `Airflow:PreloadIcons()` fetches it up front and returns whether it loaded. Unknown names print a warning and leave the icon blank.

---

## Fonts

> Download a font once and use it everywhere.

```lua
Airflow:LoadFont({ Name = "ValleySans" })

Airflow:LoadFont({
    Name = "MyFont",
    Folder = "AirFlowFonts",
    Weights = {
        Regular = "https://example.com/MyFont-Regular.ttf",
        Medium = "https://example.com/MyFont-Medium.ttf",
        SemiBold = "https://example.com/MyFont-SemiBold.ttf",
    },
})
```

Call it before `CreateWindow`. The TTFs are saved to the folder on first run and reused after that. Needs `writefile`, `isfile` and `getcustomasset`; without them it returns `false` and Builder Sans stays.

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `"CustomFont"` | Family name. `"ValleySans"` uses built-in URLs. |
| `Folder` | string | `"AirFlowFonts"` | Where the TTFs and family file are saved. |
| `Weights` | table | preset | `Regular`, `Medium`, `SemiBold`, `Bold` → TTF URL. |

The faces in use live on `Airflow.Fonts.Regular` / `Medium` / `Bold` (body text / titles and chips / emphasis) and can be replaced with any `Font` before creating a window.

