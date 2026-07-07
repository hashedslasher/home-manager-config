if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h12"
  vim.cmd('cd ' .. vim.fn.expand('~'))
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_cursor_animation_length = 0.10
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_cursor_animate_command_line = false
end
