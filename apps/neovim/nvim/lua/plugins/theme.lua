local config = function()
require('gruvbox-material').setup {
    style = 'dark'
}
end

return {
  'f4z3r/gruvbox-material.nvim',
  priority = 999,
  lazy = false,
  config = config
}
