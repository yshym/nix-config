config_path="$(find . -name pyproject.toml || echo \"$HOME/.config/black/pyproject.toml\")"
echo "Using '$config_path'"

black --config="$config_path" "$1"
