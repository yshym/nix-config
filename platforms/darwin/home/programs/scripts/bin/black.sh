project_root="$1"

system_config_path="$HOME/.config/black/pyproject.toml"
project_config_path="$(find "$project_root" -name "pyproject.toml")"
project_config_contains_black_code="$(grep "\[tool\.black\]" < "$project_config_path" 1> /dev/null && echo "$?")"

config_path="$([ "$project_config_path" != "" ] && \
    [ "$project_config_contains_black_code" = 0 ] && \
    echo "$project_config_path" || \
    echo "$system_config_path")"

echo "Using '$config_path'"

black --config="$config_path" "$2"
