-- eDP-1 (laptop panel) on the right, DP-4 (external) on the left, both at max refresh
hl.monitor({ output = "DP-4", mode = "1920x1080@165", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "2560x1600@165.04", position = "1920x0", scale = 1 })
