--[[
    ╔══════════════════════════════════════════════════════╗
    ║              Neverlose.cc UI                         ║
    ╠══════════════════════════════════════════════════════╣
    ║  Original UI Library                                 ║
    ║    Author  : 4lpaca                                  ║
    ║    License : MIT                                     ║
    ║    Discord : https://arceney.win/discord             ║
    ║    Site    : https://4lpaca.win                      ║
    ╠══════════════════════════════════════════════════════╣
    ║  Modified by  : Resolver                             ║
    ║  Changes made :                                      ║
    ║    [+] Inline keybind widget on every toggle         ║
    ║        Click to bind, Esc to clear, fires toggle     ║
    ║        in-game when bound key is pressed             ║
    ║    [+] Toggle:GetKeybind() / :SetKeybind() methods   ║
    ║    [+] Ninality:Unload() fires OnUnload() callback   ║
    ║        before cleaning up connections and flags      ║
    ║    [+] Unload button added to settings tab           ║
    ║    [+] LOADING screen on startup                     ║
    ║        Tracks real build steps, not fake timers      ║
    ║    [+] Unload button icon changed to circle-x        ║
    ║    [+] Dropdowns and settings auto-close on UI hide  ║
    ║        via global PopupCloseSignal fired on toggle   ║
    ║    [+] Logo field supports string, bool, image       ║
    ╚══════════════════════════════════════════════════════╝
    -- All credits to the rightful owner of the UI library, 4lpaca
]]

local Ninality = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/source.luau"))()

-- ─────────────────────────────────────────────────────────────
-- Cleanup on unload
-- Put your own connection disconnects, loop stops etc here
-- ─────────────────────────────────────────────────────────────
Ninality.OnUnload = function()
    print("[Ninality] Cleaning up...")
    -- example: myHeartbeat:Disconnect()
end

local Notification = Ninality:CreateNotification()
local Logging      = Ninality:CreateLogger()
local Indicator    = Ninality:CreateIndicator()

-- ─────────────────────────────────────────────────────────────
-- CreateWindow
--
-- Logo field accepts:
--   Logo = "NL"           → shows "NL" as text in the logo slot (string)
--   Logo = false or nil   → auto-generates initials from Name (boolean/nil)
--                           "Never Lose" → NL, "Ninality" → NI
--   Logo = true,          → shows your image (boolean true + LogoId string)
--   LogoId = "rbxassetid://YOUR_ID"
--
-- Loading field (all optional):
--   Version = "v1.0"      → shown next to Content e.g. "Counter-Strike 2 • v1.0"
--   Credit  = "text"      → bottom credit text on loading screen
--
-- Size accepts:
--   Ninality.Scales.Default
--   Ninality.Scales.Large   ← recommended
--   Ninality.Scales.Mobile
--   Ninality.Scales.Small
-- ─────────────────────────────────────────────────────────────
local window = Ninality:CreateWindow({
    Logo         = "NL",              -- string: shows exactly "NL" in logo slot
    Name         = "Never Lose",      -- window title
    Content      = "Counter-Strike 2",-- subtitle shown under title + on loading screen
    Size         = Ninality.Scales.Large,
    ConfigFolder = "NinalityConfigs",
    Enable3DRenderer = false,
    Keybind      = "Insert",          -- key to open/close the menu
    Loading      = {
        Version = "v1.0",             -- optional: appended to Content on loading screen
        Credit  = "Modified by Resolver", -- optional: bottom text on loading screen
    }
})

-- ─────────────────────────────────────────────────────────────
-- Watermark (top right corner)
-- ─────────────────────────────────────────────────────────────
local Watermark = window:Watermark()
local ping      = Watermark:AddBlock("chart-four-vertical-bars", "0MS")
local UITogg    = Watermark:AddBlock("cube-vertexes", "Ninality")

-- Click the "Ninality" block to toggle menu open/close
UITogg:Input(function()
    window:ToggleInterface()
end)

-- Fake ping updater
task.spawn(function()
    while true do task.wait(1)
        ping:SetText(tostring(math.random(30, 90)) .. "MS")
    end
end)

-- ─────────────────────────────────────────────────────────────
-- Indicator (small icon in corner)
-- ─────────────────────────────────────────────────────────────
local HC = Indicator.new({
    Name  = "HC",
    Icon  = "crosshairs",
    Color = "Red",
})

-- ─────────────────────────────────────────────────────────────
-- Tabs
-- ─────────────────────────────────────────────────────────────
window:AddTabLabel("AIMBOT")

local Rage  = window:AddTab({ Icon = "crosshairs",        Name = "Rage" })
local Legit = window:AddTab({ Icon = "mouse-scrollwheel", Name = "Legit" })

-- ─────────────────────────────────────────────────────────────
-- RAGE TAB
-- ─────────────────────────────────────────────────────────────
local Raging    = Rage:AddSection({ Name = "MAIN" })
local Selection = Rage:AddSection({ Name = "SELECTION", Position = "left" })
local Other     = Rage:AddSection({ Name = "OTHER",     Position = "right" })
local AntiAim   = Rage:AddSection({ Name = "ANTI-AIM",  Position = "right" })

-- ── MAIN ──────────────────────────────────────────────────────

local EnabledRage = Raging:AddLabel("Enabled")
local SlientAim   = Raging:AddLabel("Silent Aim")

-- ToolTip: hover over label to see description
EnabledRage:ToolTip("Enables the ragebot, automatically shoots at enemies")

-- Keybind field accepts:
--   Keybind = Enum.KeyCode.E  → sets E as default key
--   Keybind = nil             → shows "None", user can click to bind in-game
--   No Keybind field          → same as nil
EnabledRage:AddToggle({
    Default  = false,
    Flag     = "Ragebot",
    Callback = print,
    Keybind  = Enum.KeyCode.E,
})

EnabledRage:AddOption():AddLabel("Force Shoot"):AddToggle({
    Default  = false,
    Flag     = "FS",
    Callback = print,
    -- no keybind = shows "None"
})

SlientAim:ToolTip("Shoots at target without visually moving your crosshair")
SlientAim:AddToggle({
    Default  = false,
    Flag     = "SLIENTAIM",
    Callback = print,
    Keybind  = Enum.KeyCode.R,
})

local opt = SlientAim:AddOption()
opt:AddLabel("Perfect Silent-Aim"):AddToggle({ Default = false, Flag = "HideShot",  Callback = print })
opt:AddLabel("Perfect Silent-Aim"):AddToggle({ Default = false, Flag = "HideShot2", Callback = print })

Raging:AddLabel("Automatic Fire"):AddToggle({
    Default  = false,
    Flag     = "AutoFire",
    Keybind  = Enum.KeyCode.T,
})

Raging:AddLabel("Aim Through Walls"):AddToggle({
    Default = false,
    Flag    = "AWALLS",
    -- no Keybind
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

-- ── SELECTION ─────────────────────────────────────────────────

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
    Min = 0, Max = 100, Default = 75, Flag = "multipoint", Callback = print
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
    Min = 0, Max = 100, Type = "%",
    Nums = { [0] = "Auto" }, Flag = "hc", Size = 95, Default = 50,
})
hc:AddOption():AddLabel("Something"):AddToggle({ Default = false })

local md = Selection:AddLabel("Min Damage")
md:AddSlider({
    Min = 0, Max = 100,
    Nums = { [0] = "Auto" }, Flag = "md", Size = 95, Default = 15,
})
md:AddOption():AddLabel("Something"):AddToggle({ Default = false })

local qs = Selection:AddLabel("Quick Stop")
qs:AddToggle({ Default = false, Flag = "astop", Callback = print, Keybind = Enum.KeyCode.X })
qs:AddOption():AddLabel("Auto Stop"):AddDropdown({
    Default  = { "Early" },
    Multi    = true,
    Flag     = "astop_module",
    Values   = { "Early", "In Air", "Between Shot", "Force Accurate" },
    Callback = print,
})

Selection:AddLabel("Quick Scope"):AddToggle({
    Default = false, Flag = "ascope", Callback = print
})

-- ── OTHER ──────────────────────────────────────────────────────

Other:AddLabel("History"):AddDropdown({
    Default  = "High",
    Values   = { "Minimum", "Low", "High", "Maximum" },
    Flag     = "backtrack",
    Callback = print,
})

Other:AddLabel("Delay Shot"):AddToggle({ Default = false, Flag = "delayshoot",    Callback = print })
Other:AddLabel("Remove Recoil"):AddToggle({ Default = false, Flag = "removerecoil", Callback = print })
Other:AddLabel("Remove Spread"):AddToggle({ Default = false, Flag = "removespread", Callback = print })
Other:AddLabel("Duck Peek Assist"):AddToggle({ Default = false, Callback = print })

local qpa = Other:AddLabel("Quick Peek Assist")
qpa:AddToggle({ Default = false, Flag = "qpa", Callback = print, Keybind = Enum.KeyCode.Z })
qpa:AddOption():AddLabel("Something tung tung")

Other:AddLabel("Double Tap"):AddToggle({
    Default = false, Flag = "dt", Callback = print, Keybind = Enum.KeyCode.F
})

-- ── ANTI-AIM ───────────────────────────────────────────────────

local aa_enable = AntiAim:AddLabel("Enabled")
aa_enable:AddToggle({
    Default = false, Flag = "aa", Callback = print, Keybind = Enum.KeyCode.G
})
aa_enable:AddOption():AddLabel("Resolvers tung tung"):AddToggle({
    Default = false, Callback = print
})

AntiAim:AddLabel("Pitch"):AddDropdown({
    Default = "Down", Flag = "pitch",
    Values  = { "Down", "Center", "Up", "Fake Up", "Fake Down" },
})

AntiAim:AddLabel("Yaw"):AddDropdown({
    Default = "Backwards", Flag = "yaw",
    Values  = { "Backwards", "Left", "Right", "Forwards" },
})

AntiAim:AddLabel("Freestanding"):AddToggle({ Default = false, Flag = "freestand",     Callback = print })
AntiAim:AddLabel("Mouse Override"):AddToggle({ Default = false, Flag = "mouse_override", Callback = print })

-- ─────────────────────────────────────────────────────────────
-- Settings Tab
-- Note: Unload button is added automatically by the library
-- When clicked it calls Ninality:Unload() which fires OnUnload()
-- then disconnects all signals, clears flags, destroys the UI
-- ─────────────────────────────────────────────────────────────
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
        window:SetSize(Ninality.Scales[v])
        Logging.new("crop", "Changed ui size to " .. tostring(v), 5)
    end,
})

window.UserSettings:AddButton({
    Icon     = "discord",
    Name     = "Discord",
    Callback = function()
        Logging.new("discord", "Copied discord invite link", 5)
    end,
})

-- ─────────────────────────────────────────────────────────────
-- Startup Notifications
-- ─────────────────────────────────────────────────────────────
Notification.new({ Title = "Ninality", Content = "Welcome back, Resolver", Duration = 5 })
task.wait(1)
Notification.new({ Title = "Ninality", Content = "Initialization complete", Duration = 7 })

Logging.new("crosshairs",       "Hit thatguy in the neck for 100 damage", 15)
task.wait(2)
Logging.new("crosshairs-slash", "Missed shot due to prediction error",    15)

HC:SetRender(true)

-- ─────────────────────────────────────────────────────────────
-- Watermark / Indicator loop
-- ─────────────────────────────────────────────────────────────
while true do
    task.wait(3)
    Watermark:SetRender(true)
    HC:SetColor("Red")   HC:SetText("FL")
    task.wait(3)
    Watermark:SetRender(false)
    HC:SetColor("Green") HC:SetText("AUTO")
    task.wait(3)
    Watermark:SetRender(true)
    HC:SetColor("White") HC:SetText("HC")
    task.wait(1)
    Watermark:SetRender(false)
    HC:SetRender(false)
    task.wait(1)
    HC:SetRender(true)
end
