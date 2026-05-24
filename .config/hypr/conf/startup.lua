-- -------- STARTUP --------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("udiskie")
end)
