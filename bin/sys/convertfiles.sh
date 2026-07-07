delete=false

help_menu () {
  echo "Usage: $0 [flag] /path/to/directory"
  echo -e
  echo " -h         Show help options"
  echo " -r         Pull files out of subdirectories and delete empty directories"
  exit 0
}

convert_heic () {
  echo "Converting $1 to ${1%.*}.jpg"
  original_t=$(stat -c %y "$1")
  magick "$1" "${1%.*}.jpg"
  touch -d "$original_t" "${1%.*}.jpg"
  rm "$1"
}

while getopts ":hr" opt; do
  case $opt in
    h)
      help_menu
      ;;
    r)
      delete=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo -e
      help_menu
      ;;
  esac
done

shift $((OPTIND - 1))

if [ -z "$1" ]; then
    help_menu
fi

DIR="$1"

export -f convert_heic

find "$DIR" -iname "*.heic" -exec sh -c 'convert_heic "$1"' _ {} \;

find "$DIR" -iname "*.AAE" -exec sh -c 'echo "Removing $1" && rm "$1"' _ {} \;

if [ "$delete" = true ]; then
  find "$DIR" -mindepth 1 -type d | while read -r subdir; do
    find "$subdir" -type f | while read -r file; do
      original_t=$(stat -c %y "$file")
      mv "$file" "$DIR"
      touch -d "$original_t" "$DIR/$(basename "$file")"
    done
  done
  
  find "$DIR" -mindepth 1 -type d -empty -print | while read -r dir; do
    rmdir -v "$dir"
  done
fi
