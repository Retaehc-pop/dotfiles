-- -------- HYPRLAND --------
require("conf/monitor")
require("conf/application")
require("conf/startup")
require("conf/env")
require("conf/appearance")
require("conf/workspace")
require("conf/input")
require("conf/layout")
require("conf/keybind")
require("conf/windowrule")

-- PERMISSIONS
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
})

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
end)

require("noctalia/noctalia-colors")

-- For Noctalia Color templates
require("noctalia")

local mainMod = "SUPER"
local ipc = "noctalia msg "

-- Core binds
hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Noctalia Settings
hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})
