# Quit running waybar instances

CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/styles.css"

killall waybar
#waybar -c ~/dotfiles/.config/waybar/config.jsonc -s ~/dotfiles/.config/waybar/styles.css &

#load the configuration based on the username
while true; do
if [[ $USER = "papop" ]]
then
  waybar -c ~/dotfiles/.config/waybar/config.jsonc -s ~/dotfiles/.config/waybar/styles.css &
else
  waybar &
fi
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
