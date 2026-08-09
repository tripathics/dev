---------------------
---- KEYBINDINGS ----
---------------------

--- Programs to bind to
local terminal = "kitty"
local fileManager = "nautilus"
local music = "~/.config/hypr/scripts/spotify-workspace.sh"
local browser = "google-chrome-stable --profile-directory=Default"
local browserIncognito = "google-chrome-stable --incognito"
local menu = "~/.config/rofi/search"
local lock = "hyprlock"
local powermenu = "~/.config/rofi/my-powermenu/powermenu.sh"
local screenshot = "hyprshot"
local clipboardMenu = "~/.config/rofi/clipboard.sh"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboardMenu))

hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

local float_before_pin = {}
hl.bind(mainMod .. " + P", function ()
    local window = hl.get_active_window()
    if window == nil then return end

    if not window.pinned then
        float_before_pin[window.address] = window.floating
        if not window.floating then
            hl.dispatch(hl.dsp.window.float({ action = "enable" }))
        end
        hl.dispatch(hl.dsp.window.pin({ action = "enable" }))
    else
        local original_float = float_before_pin[window.address]
        if original_float == nil then
            original_float = false
        end
        hl.dispatch(hl.dsp.window.float({ action = original_float and "enable" or "disable" }))
        hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
        float_before_pin[window.address] = nil
    end
end)

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next())

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move windows within workspace with mainmod + vim keys
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit")) -- dwindle only

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(powermenu))

-- screenshots
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot .. " -m output"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(screenshot .. " -m region --freeze"))

-- launching programs
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browserIncognito))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
