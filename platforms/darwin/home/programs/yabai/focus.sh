#!/usr/bin/env bash
# Focus a window in the given cardinal direction with smart fallbacks.
#
# Usage: focus.sh {east|west|north|south}
#
# east/west   - BSP window focus; if none, focus the first/last window on the
#               next/prev display's visible space (wrapping around displays).
# north/south - in stacked spaces, cycle stack prev/next (wrapping around);
#               otherwise plain BSP window focus.

dir="$1"

# Stack navigation (north/south in stacked spaces)
if [[ "$dir" == "north" || "$dir" == "south" ]]; then
    if [[ "$(yabai -m query --spaces --space | jq -r '.type')" == "stack" ]]; then
        case "$dir" in
            north) yabai -m window --focus stack.prev || yabai -m window --focus stack.last ;;
            south) yabai -m window --focus stack.next || yabai -m window --focus stack.first ;;
        esac
        exit
    fi
    yabai -m window --focus "$dir"
    exit
fi

# Cross-display navigation (east/west)
yabai -m window --focus "$dir" && exit

case "$dir" in
    east) disp=next; wrap=first; win=first-window ;;
    west) disp=prev; wrap=last;  win=last-window  ;;
esac

spaces=$(yabai -m query --spaces --display "$disp" 2>/dev/null \
    || yabai -m query --spaces --display "$wrap")
wid=$(printf '%s' "$spaces" | jq -re ".[] | select(.\"is-visible\" == true).\"$win\" // empty")

if [[ -n "$wid" ]] && yabai -m window --focus "$wid"; then
    exit
fi
yabai -m display --focus "$disp" || yabai -m display --focus "$wrap"
