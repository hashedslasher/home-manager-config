local config = function()
  require("toggleterm").setup{
    open_mapping = '<C-/>',
    insert_mappings = true,
    terminal_mappings = true,
    
    direction = 'float',
      float_opts = {
      border = 'single',
      winblend = 3,
    },
  }
end
return{
  "akinsho/toggleterm.nvim",
  lazy = false,
  config = config
}
