require("items.widgets.calendar")
require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.wifi")


local sbar = require("sketchybar")

-- Add Tailscale
local tailscale = sbar.add("alias", "Tailscale", {
    position = "right",
    alias = {
        scale = 0.85 -- Slightly shrink it to fit your bar's height better
    }
})

-- Add 1Password
local one_password = sbar.add("alias", "1Password", {
    position = "right",
    padding_left = 10,
    alias = {
        scale = 0.85
    }
})

sbar.add("bracket", "system_apps", { "Tailscale", "1Password" }, {
    background = {
        color = 0x44ffffff,
        corner_radius = 5,
        drawing = true
    },
    padding_left = 10,
    padding_right = 10
})
