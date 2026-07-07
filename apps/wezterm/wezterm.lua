local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local tiling_opacity = 0.78
local stacking_opacity = 1

local session = io.popen("echo $XDG_CURRENT_DESKTOP"):read("*l")
if session == "mango" or session == "Hyprland" then
    config.window_background_opacity = tiling_opacity
else
    config.window_background_opacity = stacking_opacity
end

config.font_size = 12
config.font = wezterm.font 'JetBrainsMono NF'

config.default_cursor_style = 'SteadyBar'
config.colors = {
  cursor_bg = '#D3D3D3',
  cursor_border = '#D3D3D3', 
}

config.scrollback_lines = 100000
config.enable_wayland = true

local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })
  config.launch_menu = launch_menu
end

return config   
