project_root="$1"
config_path="$(find "$project_root" -name "pyproject.toml" || echo \"$HOME/.config/black/pyproject.toml\")"
echo "Using '$config_path'"

black --config="$config_path" "$2"
