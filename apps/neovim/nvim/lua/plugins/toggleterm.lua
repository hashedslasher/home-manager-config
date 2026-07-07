local config = function()
  require("toggleterm").setup{
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
