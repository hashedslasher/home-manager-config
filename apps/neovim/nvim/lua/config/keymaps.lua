local keymap = vim.keymap
local api = vim.api
local opt = { noremap = true, silent = true }
--local telescope = { <cmd>lua require('telescope.builtin') }

--leader
vim.g.mapleader = ' '

--Tree
keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', opt)
--Toggleterm
keymap.set('n', '<C-/>', ':ToggleTerm<CR>', opt)

--Navigation
keymap.set('n', '<C-h>', '<C-w>h', opt)
keymap.set('n', '<C-j>', '<C-w>j', opt)
keymap.set('n', '<C-k>', '<C-w>k', opt)
keymap.set('n', '<C-l>', '<C-w>l', opt)

--Telescope
--api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], opt)
--api.nvim_set_keymap('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], opt)
--api.nvim_set_keymap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], opt)
--api.nvim_set_keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], opt)
