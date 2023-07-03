local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local module = {}

local generate_filter = function(t)
	return function(c, scr)
		local ctags = c:tags()
		for _, v in ipairs(ctags) do
			if v == t then
				return true
			end
		end
		return false
	end
end

local fancytasklist = function(cfg, t)
	return awful.widget.tasklist({
		screen = cfg.screen or awful.screen.focused(),
		filter = generate_filter(t),
		buttons = cfg.tasklist_buttons,
		widget_template = {
			{
				id = "clienticon",
				widget = awful.widget.clienticon,
			},
			layout = wibox.layout.stack,
			create_callback = function(self, c, _, _)
				self:get_children_by_id("clienticon")[1].client = c
				awful.tooltip({
					objects = { self },
					timer_function = function()
						return c.name
					end,
				})
			end,
		},
	})
end

function module.new(config)
	local cfg = config or {}

	local s = cfg.screen or awful.screen.focused()
	local taglist_buttons = cfg.taglist_buttons

	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = {
			-- shape = gears.shape.powerline
			shape = gears.shape.rounded_rect
		},
		layout = {
			spacing = 10,
			spacing_widget = {
				color = beautiful.bg_normal .. "00",
				shape = gears.shape.partially_rounded_rect,
				widget = wibox.widget.separator
			},
			layout = wibox.layout.fixed.horizontal
		},
		widget_template = {
			{
				{
					widget = wibox.container.margin,
					left = 8,
					right = 10,
					{
						layout = wibox.layout.fixed.horizontal,
						-- tag
						{
							widget = wibox.container.margin,
							left = 8,
							{
								id = "text_role",
								widget = wibox.widget.textbox,
								align = "center",
							},
						},
						-- tasklist
						{
							widget = wibox.container.margin,
							left = 4,
							top = 2,
							bottom = 2,
							{
								id = "tasklist_placeholder",
								layout = wibox.layout.fixed.horizontal
							}
						}
					}
				},
				id = "background_role",
				widget = wibox.container.background,
				bg = "#ff0000"
			},
			layout = wibox.layout.fixed.horizontal,
			create_callback = function(self, _, index, _)
				local t = s.tags[index]
				self:get_children_by_id("tasklist_placeholder")[1]:add(fancytasklist(cfg, t))
			end,
		},
		buttons = taglist_buttons,
	})
end

return module