haxelib install formatter

# Check if any arguments were passed
if [ $# -eq 0 ]; then
  echo "No files passed in, formatting /source directory"
  haxelib run formatter -s source/
  exit 0
fi

ARGS=()
for file in $@; do
  # echo "Staged file: $file"
  if [[ -f "$file" ]]; then
    # echo "Adding arg file: $file"
    ARGS+=("-s" "$file")  # Each file gets prefixed with -s
  fi
done
echo "Checking formatting on $# .hx files..."
haxelib run formatter "${ARGS[@]}"
