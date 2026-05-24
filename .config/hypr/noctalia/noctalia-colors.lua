local primary        = "rgb(8fbcbb)"
local surface        = "rgb(2e3440)"
local secondary      = "rgb(88c0d0)"
local error_color    = "rgb(bf616a)"
local tertiary       = "rgb(5e81ac)"
local surface_lowest = "rgb(303643)"

hl.config({
    general = {
        col = {
            active_border   = primary,
            inactive_border = surface,
        },
    },

    group = {
        col = {
            border_active          = secondary,
            border_inactive        = surface,
            border_locked_active   = error_color,
            border_locked_inactive = surface,
        },

        groupbar = {
            col = {
                active          = secondary,
                inactive        = surface,
                locked_active   = error_color,
                locked_inactive = surface,
            },
        },
    },
})
