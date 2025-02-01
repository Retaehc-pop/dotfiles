#!/bin/bash

# Get the workspace of the currently focused window
current_workspace=$(hyprctl activewindow -j | grep '"name"' | head -1 | sed 's/.*"name": "\(.*\)".*/\1/')

# If the current workspace is 'special:magic', move the window back to the currently focused workspace
if [ "$current_workspace" == "special:hide" ]; then
  # Move the window to the currently focused workspace
  hyprctl dispatch movetoworkspace e+0
else
  # Move the window to 'special:magic'
  hyprctl dispatch movetoworkspace special:hide
fi
