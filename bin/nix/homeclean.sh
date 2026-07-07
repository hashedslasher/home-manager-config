trail=5
while getopts ":k:h" opt; do
 case $opt in
  k)
    trail="$OPTARG"
    ;;
  h)
    echo " -h         Show help options"
    echo " -k {num}   Specifiy number of generations to keep (default is 5)"
    exit 0
    ;;
  *)
    echo " -h         Show help options"
    echo " -k {num}   Specifiy number of generations to keep (default is 5)"
    exit 0
    ;;
 esac
done

if ! generations_output=$(home-manager generations); then
  echo "Error: Failed to get home-manager generations" >&2
  exit 1
fi

generations=$(echo "$generations_output" | wc -l)

if [ "$trail" -le 0 ]; then
  trail=5
fi

if [ "$generations" -gt "$trail" ]; then
  echo "Keeping $trail generations"
  sleep 1
  
  while IFS= read -r line; do
    num="$(echo -e "$line" | xargs)"
    if [[ "$num" =~ ^[0-9]+$ ]]; then
      home-manager remove-generations "$num"
    fi
  done < <(home-manager generations | tail -n +$((trail + 1)) | awk '{print $5}')
elif [ "$generations" -eq "$trail" ]; then
  echo "No generations to remove"
else
  echo "Can't keep $trail generations because you only have $generations"
fi
