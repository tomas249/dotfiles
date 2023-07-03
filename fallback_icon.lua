local cairo = require("lgi").cairo
local gears = require("gears")
local naughty = require("naughty")

local ICONS_PATH = gears.filesystem.get_configuration_dir() .. "fallback_icons/"
local FALLBACK_ICONS = {
    DEFAULT = 'default.png',
    spotify = 'Spotify.png',
    obsidian = 'obsidian.png',
}

local function notify_error(title, text)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = title,
        text = text,
    })
end

local function use_icon(icon_path)
    local s = gears.surface(icon_path)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
    local cr = cairo.Context(img)
    cr:set_source_surface(s, 0, 0)
    cr:paint()

    return img._native
end

local function get_icon_path(icon_name)
    local icon_path = ICONS_PATH .. icon_name
    if gears.filesystem.file_readable(icon_path) then
        return icon_path
    end
    return nil
end

local function render_fallback_icon(c)
    if c and c.valid and not c.icon then
        local app_class = c.class:lower()
        local icon_name = FALLBACK_ICONS[app_class] or FALLBACK_ICONS.DEFAULT
        local icon_path = get_icon_path(icon_name)

        if icon_path then
            c.icon = use_icon(icon_path)
        else
            notify_error('Fallback icon not found!', 'Class:' .. app_class .. '\nIcon:' .. icon_name .. '\nUsing default fallback icon')
            icon_path = get_icon_path(FALLBACK_ICONS.DEFAULT)
            if icon_path then
                c.icon = use_icon(icon_path)
            else
                notify_error('Default fallback icon not found!')
            end
        end
    end
end

return render_fallback_icon