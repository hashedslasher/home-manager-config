local opt = vim.opt
--Appearance
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10

--Behavior
opt.errorbells = false
opt.splitright = true
opt.autochdir = false
opt.clipboard:append('unnamedplus')
opt.encoding = 'UTF-8'
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000
vim.cmd[[set wildmenu]]

--Tab / Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

--Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

--shell
opt.shell = 'zsh'
--vimwiki
--vim.g.vimwiki_list = {{path = '~/Documents/vimwiki'}}

--[[latex preview
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_view_method = 'zathura'
vim.g.livepreview_previewer = 'zathura'
vim.g.livepreview_enabled = 1
]]
