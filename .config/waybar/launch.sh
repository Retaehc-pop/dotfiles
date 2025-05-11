# Quit running waybar instances

CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/styles.css"

killall waybar

start_waybar() {
  if [[ $USER = "papop" ]]; then
    waybar -c ~/dotfiles/.config/waybar/config.jsonc -s ~/dotfiles/.config/waybar/styles.css &
  else
    waybar &
  fi
}
#load the configuration based on the username
while true; do
  if ! pgrep -x "waybar" >/dev/null; then
    echo "waybar is not running, starting it..."
    start_waybar
  fi
  sleep 1
done &

# Monitor for configuration file changes
while true; do
  inotifywait -e modify -e create $CONFIG_FILES
  echo "Configuration file changed, restarting waybar..."
  killall waybar
  start_waybar
done &

wait
