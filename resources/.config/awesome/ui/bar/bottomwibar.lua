local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

awful.screen.connect_for_each_screen(function(s)
	local awesome_icon = wibox.widget({
		widget = wibox.widget.imagebox,
		image = beautiful.awesome_logo,
		resize = true,
	})

	local launcher = wibox.widget({
		{
			awesome_icon,
			top = dpi(6),
			bottom = dpi(6),
			left = dpi(12),
			right = dpi(12),
			widget = wibox.container.margin,
		},
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(5))
		end,
		bg = beautiful.wibar_widget_bg,
		widget = wibox.container.background,
	})

	launcher:buttons(gears.table.join(awful.button({}, 1, function()
		central_panel:toggle()
	end)))

	helpers.add_hover_cursor(awesome_icon, "hand2")

	-- clock
	local hours = wibox.widget.textclock("%H")
	local minutes = wibox.widget.textclock("%M")

	local make_little_dot = function(color)
		return wibox.widget({
			bg = color,
			forced_width = dpi(2),
			forced_height = dpi(2),
			shape = gears.shape.circle,
			widget = wibox.container.background,
		})
	end

	local time = {
		{
			font = beautiful.font_name .. "Bold 12",
			align = "right",
			valign = "center",
			widget = hours,
		},
		{
			nil,
			{
				make_little_dot(beautiful.xforeground),
				make_little_dot(beautiful.xforeground),
				spacing = dpi(4),
				widget = wibox.layout.fixed.vertical,
			},
			expand = "none",
			widget = wibox.layout.align.vertical,
		},
		{
			font = beautiful.font_name .. "Bold 12",
			align = "left",
			valign = "center",
			widget = minutes,
		},
		spacing = dpi(4),
		layout = wibox.layout.fixed.horizontal,
	}

	local layoutbox_buttons = gears.table.join(
		-- Left click
		awful.button({}, 1, function(c)
			awful.layout.inc(1)
		end),

		-- Right click
		awful.button({}, 3, function(c)
			awful.layout.inc(-1)
		end),

		-- Scrolling
		awful.button({}, 4, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(1)
		end)
	)

	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(layoutbox_buttons)

	local layoutbox = wibox.widget({
		s.mylayoutbox,
		left = dpi(2),
		right = dpi(2),
		top = dpi(3),
		bottom = dpi(3),
		widget = wibox.container.margin,
	})

	helpers.add_hover_cursor(layoutbox, "hand2")

	local right_container = wibox.widget({
		{
			{
				time,
				vertical_separator,
				layoutbox,
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10),
			},
			top = dpi(4),
			bottom = dpi(4),
			left = dpi(8),
			right = dpi(8),
			widget = wibox.container.margin,
		},
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(5))
		end,
		bg = beautiful.wibar_widget_bg,
		widget = wibox.container.background,
	})

	right_container:connect_signal("mouse::enter", function()
		right_container.bg = beautiful.wibar_widget_bg .. 55
		tooltip_toggle()
	end)

	right_container:connect_signal("mouse::leave", function()
		right_container.bg = beautiful.wibar_widget_bg
		tooltip_toggle()
	end)

	-- Systray
	s.systray = wibox.widget.systray()
	s.systray.base_size = beautiful.systray_icon_size
	s.traybox = wibox({
		screen = s,
		width = dpi(100),
		height = dpi(150),
		bg = "#00000000",
		visible = false,
		ontop = true,
	})
	s.traybox:setup({
		{
			{
				nil,
				s.systray,
				direction = "west",
				widget = wibox.container.rotate,
			},
			margins = dpi(15),
			widget = wibox.container.margin,
		},
		bg = beautiful.wibar_bg,
		shape = helpers.rrect(beautiful.border_radius),
		widget = wibox.container.background,
	})
	awful.placement.top_right(s.traybox, {
		margins = {
			top = beautiful.useless_gap * 16,
			bottom = beautiful.useless_gap * 4,
			left = beautiful.useless_gap * 4,
			right = beautiful.useless_gap * 4,
		},
	})
	s.traybox:buttons(gears.table.join(awful.button({}, 2, function()
		s.traybox.visible = false
	end)))

	-- Create the wibox
	s.mywibar = awful.wibar({
		type = "dock",
		position = "bottom",
		screen = s,
		height = dpi(50),
		width = s.geometry.width - dpi(150),
		bg = beautiful.transparent,
		ontop = true,
		visible = true,
	})

	awful.placement.bottom(s.mywibar, { margins = beautiful.useless_gap * 0.5 })

	-- Remove wibar on full screen
	local function remove_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = false
		else
			c.screen.mywibar.visible = true
		end
	end

	-- Remove wibar on full screen
	local function add_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = true
		end
	end

	-- Hide bar when a splash widget is visible
	awesome.connect_signal("widgets::splash::visibility", function(vis)
		screen.primary.mywibar.visible = not vis
	end)

	client.connect_signal("property::fullscreen", remove_wibar)

	client.connect_signal("request::unmanage", add_wibar)

	-- Create the taglist widget
	s.mytaglist = require("ui.bar.taglist")(s)

	-- Add widgets to the wibox
	s.mywibar:setup({		
		{
			{
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{
					widget = s.mytaglist,
				},
				nil,
				{
					right_container,
					launcher,
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
			},
			margins = dpi(10),
			widget = wibox.container.margin,
		},
		bg = beautiful.wibar_bg,
		shape = helpers.rrect(beautiful.border_radius),
		widget = wibox.container.background,
	})
end)

-- Systray toggle
function systray_toggle()
	local s = awful.screen.focused()
	s.traybox.visible = not s.traybox.visible
end
