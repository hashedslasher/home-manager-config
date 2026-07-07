local config = function()
require('onedark').setup {
    style = 'dark'
}
require('onedark').load()
end

return {
  'navarasu/onedark.nvim',
  priority = 999,
  lazy = false,
  config = config
}
