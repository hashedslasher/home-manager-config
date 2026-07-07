DIR="${1:-.}"

if [[ ! -d "$DIR" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

for INPUT_FILE in "$DIR"/*; do
    [ -f "$INPUT_FILE" ] || continue

    BASENAME=$(basename "$INPUT_FILE")

    MOD_TIME=$(stat -c %Y "$INPUT_FILE")
    DATE_STR=$(date -d "@$MOD_TIME" '+%Y-%m-%d-%H-%M-%S')

    if [[ "$BASENAME" == *.* && "$BASENAME" != .* ]]; then
        EXT=".${BASENAME##*.}"
    else
        EXT=""
    fi

    NEW_NAME="$DIR/${DATE_STR}${EXT}"

    n=1
    while [[ -e "$NEW_NAME" && "$NEW_NAME" != "$INPUT_FILE" ]]; do
        NEW_NAME="$DIR/${DATE_STR}_$n${EXT}"
        ((n++))
    done

    mv -- "$INPUT_FILE" "$NEW_NAME"
done
