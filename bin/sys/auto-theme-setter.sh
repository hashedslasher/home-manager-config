input_file="$HOME/.config/home-manager/themes/themed-files"

set_theme () {
  i=1
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    export "COLOR$i=$line"
    echo "COLOR$i=$line"
    ((i++))
  done < "$colors"



  var1=""
  var2=""
  var3=""
  state=0

  while IFS= read -r line || [[ -n "$line" ]]; do
  line=$(echo "$line" | tr -d '\r' | xargs)

    if [[ -z "$line" ]]; then
      state=0
      continue
    fi

    line="${line%\"}"
    line="${line#\"}"

    if [[ $state -eq 0 ]]; then
      var1="$line"
      state=1
  
    elif [[ $state -eq 1 ]]; then
      var2="$line"
      state=2
  
    elif [[ $state -eq 2 ]]; then
      var3="$line"

      echo "Processing pair:"
      echo "  program $var1"
      echo "  Input: $var2"
      echo "  Output: $var3"

      if [[ ! -f "$var2" ]]; then
        echo "Error: Input file '$var2' does not exist." >&2
        state=0
        continue
      fi

      envsubst < $var2 > $var3
      $var1

      state=0
      var1=""
      var2=""
      var3=""
    fi 
  done < "$input_file"

}

show_help() {
  echo "Usage: $0 [OPTION] filepath/imagepath"
  echo ""
  echo "options"
  echo "-w    use pywal to set system theme"
  echo "-t    use filepath to set system theme"
  echo "-h    show this help message"
}

w() {
  wal -i "$1"
  colors="$HOME/.cache/wal/colors"
  set_theme
}

t() {
  colors="$1"
  set_theme
}

while getopts ":w:t:h" opt; do
    case $opt in
        w)
            w "$OPTARG"
            ;;
        t)
            t "$OPTARG"
            ;;
        h)
            show_help
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            exit 1
            ;;
    esac
done
