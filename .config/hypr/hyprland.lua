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
        disable_hyprland_logo   = false,
    },
})

require("noctalia/noctalia-colors")

-- For Noctalia Color templates
require("noctalia")
