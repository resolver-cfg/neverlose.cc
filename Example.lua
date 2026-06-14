--[[
    ╔══════════════════════════════════════════════════════╗
    ║              Nigginality UI                          ║
    ╠══════════════════════════════════════════════════════╣
    ║  Original UI Library                                 ║
    ║    Author  : 4lpaca                                  ║
    ║    License : MIT                                     ║
    ║    Discord : https://arceney.win/discord             ║
    ║    Site    : https://4lpaca.win                      ║
    ╠══════════════════════════════════════════════════════╣
    ║  Modifications by  : Resolver                        ║
    ║  Changes made      :                                 ║
    ║    [+] Inline keybind widget on every toggle         ║
    ║        Click to bind, Esc to clear, fires toggle     ║
    ║        in-game when bound key is pressed             ║
    ║    [+] Toggle:GetKeybind() / :SetKeybind() methods   ║
    ║    [+] Default keybind via Keybind = Enum.KeyCode.X  ║
    ║    [+] Nigginality:Unload() now fires OnUnload()     ║
    ║        callback before cleaning up connections       ║
    ║    [+] Unload button added to settings tab           ║
    ║                                                      ║
    ╚══════════════════════════════════════════════════════╝
]]


local Nigginality = loadstring(game:HttpGet("https://raw.githubusercontent.com/resolver-cfg/neverlose.cc/refs/heads/main/Neverlose..cc"))()

-- ─────────────────────────────────────────────────────────────────────────────
-- OnUnload: fires BEFORE the library cleans itself up.
-- Put your own cleanup here: stop loops, remove stuff, reset characters, etc.
-- ─────────────────────────────────────────────────────────────────────────────
Nigginality.OnUnload = function()
    print("[Nigginality] Unloading - cleaning up...")

    -- Example: stop your own loops, reset values, etc.
    -- myHeartbeat:Disconnect()
    -- game:GetService("RunService").Heartbeat:Disconnect()
    -- LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
    
    print("[Nigginality] Cleanup done. Goodbye!")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Notification & Logger (optional utilities)
-- ─────────────────────────────────────────────────────────────────────────────
local Notification = Nigginality:CreateNotification()
local Logging      = Nigginality:CreateLogger()
local Indicator    = Nigginality:CreateIndicator()

-- ─────────────────────────────────────────────────────────────────────────────
-- Create the main window
-- Size options: Default, Large, Mobile, Small
-- Keybind: the key that opens/closes the menu
-- ─────────────────────────────────────────────────────────────────────────────
local window = Nigginality:CreateWindow({
    Logo         = Nigginality.GlobalLogo,
    Name         = "Nigginality",
    Content      = "Counter-Strike 2",
    Size         = Nigginality.Scales.Large,   -- Opens Large by default (user can change in settings)
    ConfigFolder = "NigginalityConfigs",
    Enable3DRenderer = false,
    Keybind      = "Insert"                 -- Insert opens/closes the menu
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Watermark (top-right corner blocks)
-- ─────────────────────────────────────────────────────────────────────────────
local Watermark = window:Watermark()

local ping  = Watermark:AddBlock("chart-four-vertical-bars", "0MS")
local UITogg = Watermark:AddBlock("cube-vertexes", "Nigginality")

-- Click the watermark "Nigginality" block to toggle the menu
UITogg:Input(function()
    window:ToggleInterface()
end)

-- Fake ping updater
task.spawn(function()
    while true do
        task.wait(1)
        ping:SetText(tostring(math.random(30, 90)) .. "MS")
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Indicator (small corner icon)
-- ─────────────────────────────────────────────────────────────────────────────
local HC = Indicator.new({
    Name  = "HC",
    Icon  = "crosshairs",
    Color = "Red",
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Tabs
-- ─────────────────────────────────────────────────────────────────────────────
window:AddTabLabel("AIMBOT")

local Rage  = window:AddTab({ Icon = "crosshairs",       Name = "Rage" })
local Legit = window:AddTab({ Icon = "mouse-scrollwheel", Name = "Legit" })

-- ─────────────────────────────────────────────────────────────────────────────
-- RAGE TAB - Sections
-- ─────────────────────────────────────────────────────────────────────────────
local Raging    = Rage:AddSection({ Name = "MAIN" })
local Selection = Rage:AddSection({ Name = "SELECTION", Position = "left" })
local Other     = Rage:AddSection({ Name = "OTHER",     Position = "right" })
local AntiAim   = Rage:AddSection({ Name = "ANTI-AIM",  Position = "right" })

-- ─────────────────────────────────────────────────────────────────────────────
-- MAIN Section
-- Toggles with Keybind:
--   Keybind = Enum.KeyCode.X  → sets X as the default key
--   Keybind = nil             → shows "None", user can click to set one
--   No Keybind field at all   → same as nil
-- ─────────────────────────────────────────────────────────────────────────────
local EnabledRage = Raging:AddLabel("Enabled")
local SlientAim   = Raging:AddLabel("Silent Aim")

EnabledRage:ToolTip("Dynamically adjusts grenade throw angles to counteract\nmovement velocity, allowing precise straight-line throws\neven while strafing")

-- [NEW] Keybind = Enum.KeyCode.E → press E in-game to toggle Ragebot on/off
EnabledRage:AddToggle({
    Default  = false,
    Flag     = "Ragebot",
    Callback = print,
    Keybind  = Enum.KeyCode.E,  -- press E to toggle
})

EnabledRage:AddOption():AddLabel("Force Shoot"):AddToggle({
    Default  = false,
    Flag     = "FS",
    Callback = print,
    -- No Keybind = shows "None", user can set one in-game
})

-- [NEW] Keybind = Enum.KeyCode.R → press R to toggle Silent Aim
SlientAim:AddToggle({
    Default  = false,
    Flag     = "SLIENTAIM",
    Callback = print,
    Keybind  = Enum.KeyCode.R,  -- press R to toggle
})

local opt = SlientAim:AddOption()

opt:AddLabel("Perfect Silent-Aim"):AddToggle({
    Default  = false,
    Flag     = "HideShot",
    Callback = print,
    -- No keybind
})

opt:AddLabel("Perfect Silent-Aim"):AddToggle({
    Default  = false,
    Flag     = "HideShot2",
    Callback = print,
})

-- [NEW] Keybind = Enum.KeyCode.T → press T to toggle Auto Fire
Raging:AddLabel("Automatic Fire"):AddToggle({
    Default  = false,
    Flag     = "AutoFire",
    Keybind  = Enum.KeyCode.T,
})

-- No keybind on this one
Raging:AddLabel("Aim Through Walls"):AddToggle({
    Default = false,
    Flag    = "AWALLS",
})

Raging:AddLabel("Field of View"):AddSlider({
    Min      = 0,
    Max      = 2600,
    Rounding = 1,
    Default  = 100,
    Type     = "Lv",
    Size     = 100,
    Callback = print,
    Flag     = "fov",
})

-- ─────────────────────────────────────────────────────────────────────────────
-- SELECTION Section
-- ─────────────────────────────────────────────────────────────────────────────
Selection:AddLabel("Target"):AddDropdown({
    Default  = "Hightest Damage",
    Values   = { "Hightest Damage", "Automatic", "Lowest Damage" },
    Callback = print,
    Flag     = "target_box",
})

Selection:AddLabel("Hitboxes"):AddDropdown({
    Default  = { "Head" },
    Multi    = true,
    Values   = { "Head", "Body", "Arms", "Legs" },
    Flag     = "hitboxes",
    Callback = print,
})

local Multipoint = Selection:AddLabel("Multipoint")
Multipoint:AddOption():AddLabel("Multipoint"):AddSlider({
    Min      = 0,
    Max      = 100,
    Default  = 75,
    Flag     = "multipoint",
    Callback = print,
})
Multipoint:AddDropdown({
    Default  = { "Head" },
    Multi    = true,
    Values   = { "Head", "Body", "Arms", "Legs" },
    Flag     = "hitboxmulti",
    Callback = print,
})

local hc = Selection:AddLabel("Hit Chance")
hc:AddSlider({
    Min     = 0,
    Max     = 100,
    Type    = "%",
    Nums    = { [0] = "Auto" },
    Flag    = "hc",
    Size    = 95,
    Default = 50,
})
hc:AddOption():AddLabel("Something"):AddToggle({ Default = false })

local md = Selection:AddLabel("Min Damage")
md:AddSlider({
    Min     = 0,
    Max     = 100,
    Nums    = { [0] = "Auto" },
    Flag    = "md",
    Size    = 95,
    Default = 15,
})
md:AddOption():AddLabel("Something"):AddToggle({ Default = false })

local qs = Selection:AddLabel("Quick Stop")
qs:AddToggle({
    Default  = false,
    Flag     = "astop",
    Callback = print,
    Keybind  = Enum.KeyCode.X,  -- press X to toggle Quick Stop
})
qs:AddOption():AddLabel("Auto Stop"):AddDropdown({
    Default  = { "Early" },
    Multi    = true,
    Flag     = "astop_module",
    Values   = { "Early", "In Air", "Between Shot", "Force Accurate" },
    Callback = print,
})

Selection:AddLabel("Quick Scope"):AddToggle({
    Default  = false,
    Flag     = "ascope",
    Callback = print,
    -- No keybind
})

-- ─────────────────────────────────────────────────────────────────────────────
-- OTHER Section
-- ─────────────────────────────────────────────────────────────────────────────
Other:AddLabel("History"):AddDropdown({
    Default  = "High",
    Values   = { "Minimum", "Low", "High", "Maximum" },
    Flag     = "backtrack",
    Callback = print,
})

Other:AddLabel("Delay Shot"):AddToggle({
    Default  = false,
    Flag     = "delayshoot",
    Callback = print,
})

Other:AddLabel("Remove Recoil"):AddToggle({
    Default  = false,
    Flag     = "removerecoil",
    Callback = print,
})

Other:AddLabel("Remove Spread"):AddToggle({
    Default  = false,
    Flag     = "removespread",
    Callback = print,
})

Other:AddLabel("Duck Peek Assist"):AddToggle({
    Default  = false,
    Callback = print,
})

local qpa = Other:AddLabel("Quick Peek Assist")
qpa:AddToggle({
    Default  = false,
    Flag     = "qpa",
    Callback = print,
    Keybind  = Enum.KeyCode.Z,  -- press Z to toggle Quick Peek Assist
})
qpa:AddOption():AddLabel("Something tung tung")

Other:AddLabel("Double Tap"):AddToggle({
    Default  = false,
    Flag     = "dt",
    Callback = print,
    Keybind  = Enum.KeyCode.F,  -- press F to toggle Double Tap
})

-- ─────────────────────────────────────────────────────────────────────────────
-- ANTI-AIM Section
-- ─────────────────────────────────────────────────────────────────────────────
local aa_enable = AntiAim:AddLabel("Enabled")
aa_enable:AddToggle({
    Default  = false,
    Flag     = "aa",
    Callback = print,
    Keybind  = Enum.KeyCode.G,  -- press G to toggle Anti-Aim
})
aa_enable:AddOption():AddLabel("Resolvers tung tung"):AddToggle({
    Default  = false,
    Callback = print,
})

AntiAim:AddLabel("Pitch"):AddDropdown({
    Default = "Down",
    Flag    = "pitch",
    Values  = { "Down", "Center", "Up", "Fake Up", "Fake Down" },
})

AntiAim:AddLabel("Yaw"):AddDropdown({
    Default = "Backwards",
    Flag    = "yaw",
    Values  = { "Backwards", "Left", "Right", "Forwards" },
})

AntiAim:AddLabel("Freestanding"):AddToggle({
    Default  = false,
    Flag     = "freestand",
    Callback = print,
})

AntiAim:AddLabel("Mouse Override"):AddToggle({
    Default  = false,
    Flag     = "mouse_override",
    Callback = print,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Settings (UserSettings) - auto-populated by the library
-- [NEW] Unload button is automatically added by the library here.
-- ─────────────────────────────────────────────────────────────────────────────
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({
    Default  = "Insert",
    Callback = function(v)
        window.Keybind = v
        Logging.new("ps4-touchpad", "Changed ui keybind to " .. tostring(v), 5)
    end,
})

window.UserSettings:AddLabel("Menu Scale"):AddDropdown({
    Default  = "Large",
    Values   = { "Default", "Large", "Mobile", "Small" },
    Callback = function(v)
        window:SetSize(Nigginality.Scales[v])
        Logging.new("crop", "Changed ui size to " .. tostring(v), 5)
    end,
})

window.UserSettings:AddLabel("3D Menu"):AddToggle({
    Default  = false,
    Callback = function(v)
        window:Set3DRender(v)
    end,
})

window.UserSettings:AddButton({
    Icon     = "discord",
    Name     = "Discord",
    Callback = function()
        print("invite")
        Logging.new("discord", "Copied discord invite link", 5)
    end,
})

-- Note: The Unload button appears automatically in settings.
-- When clicked it calls Nigginality:Unload() which:
--   1. Fires your Nigginality.OnUnload() function first
--   2. Disconnects all signals/connections
--   3. Clears all flags
--   4. Destroys the UI

-- ─────────────────────────────────────────────────────────────────────────────
-- Startup notifications
-- ─────────────────────────────────────────────────────────────────────────────
Notification.new({
    Title    = "Nigginality",
    Content  = "Welcome back, Resolver",
    Duration = 5,
})

task.wait(1)
Notification.new({
    Title    = "Nigginality",
    Content  = "Initialization complete",
    Duration = 7,
})

Logging.new("crosshairs", "Hit thatguy in the neck for 100 damage", 15)
task.wait(2)
Logging.new("crosshairs-slash", "Missed shot due to prediction error", 15)

HC:SetRender(true)

-- ─────────────────────────────────────────────────────────────────────────────
-- Watermark / Indicator loop
-- ─────────────────────────────────────────────────────────────────────────────
while true do
    task.wait(3)
    Watermark:SetRender(true)
    HC:SetColor("Red")
    HC:SetText("FL")

    task.wait(3)
    Watermark:SetRender(false)
    HC:SetColor("Green")
    HC:SetText("AUTO")

    task.wait(3)
    Watermark:SetRender(true)
    HC:SetColor("White")
    HC:SetText("HC")

    task.wait(1)
    Watermark:SetRender(false)
    HC:SetRender(false)

    task.wait(1)
    HC:SetRender(true)
end
