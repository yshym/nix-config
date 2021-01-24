stackline = require "stackline.stackline.stackline"
local stacklineConfig = {
    appearance = {
        color = {
            white = 0,
        },
        showIcons = true,
    },
    paths = {
        jq = "/Users/yevhenshymotiuk/.nix-profile/bin/jq",
        yabai = "/run/current-system/sw/bin/yabai",
    },
}
stackline:init(stacklineConfig)

keyboardLayout = require "keyboardLayout"
keyboardLayout:init()
