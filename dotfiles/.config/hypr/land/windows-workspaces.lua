--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Keep these windows floating

-- Picture in picture windows
hl.window_rule({
	name = "picture-in-picture-windows",
	match = { title = "(?i)^Picture[- ]in[- ]Picture$" },

	float = true,
	pin = true,
	no_initial_focus = true,
	size = { 800, 450 },
	move = { "(monitor_w-window_w)", "(monitor_h-window_h)" },
})

local floating_windows = {
	{ class = "^(blueman-manager)$" },
	{ class = "^(org.pulseaudio.pavucontrol)$" },
	{ class = "^(localsend)$" },
}

for i, val in ipairs(floating_windows) do
	hl.window_rule({
		name = "floating-windows-by-default-" .. i,
		match = val,
		float = true,
		center = true,
	})
end

-- Some application defaults
hl.window_rule({
	name = "darktable-launch",
	match = { class = "org.darktable.darktable", title = "^(darktable)$" },
	workspace = 9,
	fullscreen = true,
})

hl.window_rule({
	name = "spotify-launch",
	match = { class = "(?i)^(spotify)$" },
	workspace = 10,
})

