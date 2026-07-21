local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Resize windows with vim keys
hl.bind(mainMod .. " + R", hl.dsp.submap("RESIZE"))

hl.define_submap("RESIZE", function()
	hl.bind("LEFT", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("RIGHT", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("UP", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("DOWN", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

	hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)
