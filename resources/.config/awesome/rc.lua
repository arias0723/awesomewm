pcall(require, "luarocks.loader")

-- Standard awesome library
local gfs = require("gears.filesystem")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")
dpi = beautiful.xresources.apply_dpi
beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")

-- Default Applications
terminal = "kitty"
editor = terminal .. " -e " .. os.getenv("EDITOR")
vscode = "code"
browser = "firefox"
launcher = "rofi -show drun -theme " .. os.getenv("HOME") .. "/.config/awesome/theme/rofi.rasi"
file_manager = "nautilus"

-- Weather API
openweathermap_key = "faf00c97291fcf54f6d4869db0f86322" -- API Key
openweathermap_city_id = "3441575" -- City ID
weather_units = "metric" -- Unit

-- Global Vars
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Autostart
awful.spawn.with_shell(gfs.get_configuration_dir() .. "configuration/autostart")

-- Import Configuration
require("configuration")

-- Import Daemons and Widgets
require("signal")
require("ui")

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

