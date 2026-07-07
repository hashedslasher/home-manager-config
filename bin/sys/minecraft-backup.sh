Mount="/mnt/external-hdd"
Destination="$HOME/Games/Gamedata/Minecraft"
Src="/home/layton/.local/share/PrismLauncher/instances"

if ! mountpoint -q $Mount; then
  echo "External drive not mounted"
  exit 1
fi

mkdir -p "$Destination"

touch "$Destination"/logs

rsync -avL "$Src" "$Destination" > "$Destination"/logs
