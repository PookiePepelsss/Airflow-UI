local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()

Airflow:LoadFont({ Name = "ValleySans" }) -- downloads the font once into workspace/AirFlowFonts and uses it everywhere

local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "Example",
    Theme = "Default", -- or "Midnight", "Moss", "Ember", "Rose", "Mono", or a table of colours
    ToggleUIKeybind = "RightControl", -- key that hides and shows the window
    -- examples: "RightShift", "RightControl", "LeftAlt", "Insert", "Home", "F1", "Backquote"
    -- Enum.KeyCode values also work: ToggleUIKeybind = Enum.KeyCode.RightShift
    ConfigurationSaving = { Enabled = true, FolderName = "AirflowExample", FileName = "default" },
    Home = {
        Name = "Home",
        Stats = { "FPS", "Ping", "Executor", "Game", "Region", "Time" },
        Pages = { -- extra tabs beside the info one
            {
                Name = "Changelog",
                Icon = "scroll-text",
                Entries = {
                    { Title = "v1.3", Tag = "Latest", Changes = { "Live themes and six presets", "Lock, hide and rename any element", "Hold-mode keybinds" } },
                    { Title = "v1.2", Tag = "Sep 12", Changes = { "Added the home tab", "Smaller input boxes that grow", "Faster dropdowns" } },
                    { Title = "v1.1", Tag = "Aug 30", Changes = { "Config manager", "Stepper and progress elements" } },
                },
            },
            {
                Name = "Info",
                Icon = "info",
                Content = "Airflow UI example. Everything on the Elements tab just prints, so you can click around safely.",
            },
        },
    },
})

local Elements = Window:CreateTab({ Name = "Elements", Desc = "One of everything", Icon = "layout-grid" })

Elements:CreateSection("Buttons")

Elements:CreateButton({
    Name = "Example button",
    Desc = "Example description",
    Icon = "mouse-pointer-click",
    Callback = function()
        print("button")
    end,
})

Elements:CreateButton({
    Name = "Example primary button",
    Style = "Primary",
    Callback = function()
        print("primary button")
    end,
})

Elements:CreateButton({
    Name = "Example danger button",
    Style = "Danger",
    Icon = "trash-2",
    Callback = function()
        print("danger button")
    end,
})

Elements:CreateButton({
    Name = "Example locked button",
    Desc = "Locked elements ignore input until unlocked",
    Locked = true,
    LockedReason = "Premium",
})

Elements:CreateSection("Values")

local ExampleToggle = Elements:CreateToggle({
    Name = "Example toggle",
    Desc = "Example description",
    CurrentValue = false,
    Flag = "ExampleToggle",
    Callback = function(Value)
        print("toggle", Value)
    end,
})

Elements:CreateToggle({
    Name = "Lock the toggle above",
    Callback = function(Value)
        ExampleToggle:SetLocked(Value, "Locked by the switch below")
    end,
})

Elements:CreateSlider({
    Name = "Example slider",
    Desc = "Click the value to type a number",
    Range = { 0, 100 },
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "ExampleSlider",
    Callback = function(Value)
        print("slider", Value)
    end,
})

Elements:CreateStepper({
    Name = "Example stepper",
    Range = { 0, 10 },
    Increment = 0.5,
    CurrentValue = 5,
    Flag = "ExampleStepper",
    Callback = function(Value)
        print("stepper", Value)
    end,
})

Elements:CreateProgress({
    Name = "Example progress",
    CurrentValue = 0.65,
})

Elements:CreateSection("Choices")

Elements:CreateDropdown({
    Name = "Example dropdown",
    Options = { "Option 1", "Option 2", "Option 3" },
    CurrentOption = "Option 1",
    Flag = "ExampleDropdown",
    Callback = function(Option)
        print("dropdown", Option)
    end,
})

Elements:CreateDropdown({
    Name = "Example multi dropdown",
    Options = { "Option 1", "Option 2", "Option 3", "Option 4" },
    MultipleOptions = true,
    CurrentOption = { "Option 1" },
    Placeholder = "Nothing picked",
    Flag = "ExampleMultiDropdown",
    Callback = function(Options)
        print("multi dropdown", table.concat(Options, ", "))
    end,
})

Elements:CreateInput({
    Name = "Example input",
    PlaceholderText = "Type here",
    MaxLength = 24,
    Flag = "ExampleInput",
    OnChanged = function(Text)
        print("typing", Text)
    end,
    Callback = function(Text, EnterPressed)
        print("input", Text, EnterPressed)
    end,
})

Elements:CreateKeybind({
    Name = "Example keybind",
    Desc = "Backspace clears it while rebinding",
    CurrentKeybind = "F",
    Flag = "ExampleKeybind",
    Callback = function(Key)
        print("keybind", Key.Name)
    end,
})

Elements:CreateKeybind({
    Name = "Example hold keybind",
    CurrentKeybind = "LeftAlt",
    Mode = "Hold",
    Flag = "ExampleHoldKeybind",
    Callback = function(Held)
        print("held", Held)
    end,
})

Elements:CreateColorPicker({
    Name = "Example color picker",
    Color = Color3.fromRGB(235, 199, 246),
    Flag = "ExampleColor",
    Callback = function(Color)
        print("color", Color)
    end,
})

Elements:CreateDivider()

Elements:CreateLabel("Example label")

Elements:CreateParagraph({
    Title = "Example paragraph",
    Content = "Longer text that wraps across several lines.",
})

local Popups = Window:CreateTab({ Name = "Popups", Desc = "Notifications and dialogs", Icon = "bell" })

for _, Type in ipairs({ "Info", "Success", "Warning", "Error" }) do
    Popups:CreateButton({
        Name = Type .. " notification",
        Callback = function()
            Airflow:Notify({
                Title = Type,
                Content = "Example " .. string.lower(Type) .. " notification",
                Icon = "bell",
                Type = Type,
                Duration = 3,
            })
        end,
    })
end

Popups:CreateButton({
    Name = "Example confirm",
    Callback = function()
        Airflow:Confirm({
            Title = "Example confirm",
            Content = "Are you sure?",
            ConfirmText = "Yes",
            CancelText = "No",
            Callback = function()
                print("confirmed")
            end,
        })
    end,
})

Popups:CreateButton({
    Name = "Example dialog",
    Callback = function()
        Airflow:Dialog({
            Title = "Example dialog",
            Content = "Pick one.",
            Buttons = {
                { Title = "One", Callback = function() print("one") end },
                { Title = "Two", Callback = function() print("two") end },
                { Title = "Three", Variant = "Primary", Callback = function() print("three") end },
            },
        })
    end,
})

Window:CreateTab({ Name = "Empty", Desc = "Nothing in here", Icon = "package" })

local Settings = Window:CreateTab({ Name = "Settings", Icon = "settings" })

Settings:CreateSection("Interface")

Settings:CreateThemePicker({ Flag = "Theme" })

Settings:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    OnChanged = function(Key)
        Window:SetKeybind(Key)
    end,
})

Settings:CreateConfigManager({ Name = "Configs" })

Settings:CreateButton({
    Name = "Unload",
    Icon = "power",
    Style = "Danger",
    Callback = function()
        Airflow:Confirm({
            Title = "Unload?",
            ConfirmText = "Unload",
            Callback = function()
                Window:Destroy()
            end,
        })
    end,
})

Window:LoadConfig()
