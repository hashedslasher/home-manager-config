while getopts ":pfb" opt; do
 case $opt in
  p)
    command="play-pause"
    ;;
  f)
    command="next"
    ;;
  b)
    command="previous"
    ;;
  *)
    echo "invalid options"
    exit 0
    ;;
 esac
done

if [ "$(playerctl -l | wc -l)" -gt 1 ]; then
  playerctl -i brave "$command"
else
  playerctl "$command"
fi
