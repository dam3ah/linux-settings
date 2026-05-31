"Vim-Plug Plugins
call plug#begin()
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'sainnhe/gruvbox-material'
Plug 'neovim/nvim-lspconfig'
Plug 'stevearc/oil.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
call plug#end()
" Nvim Gruvbox Plugin config
set termguicolors
set background=dark
set clipboard=unnamedplus
color slate
highlight Normal guibg=none
" Key binding
nnoremap <C-q> :Oil <CR>
nnoremap <C-tab> :tabnew <CR>
nnoremap <M-x> :tabc <CR>
nnoremap <C-Right> gt <CR>
nnoremap <C-Left> gT <CR>
nnoremap <C-Up> :m .-2<CR>==
nnoremap <C-Down> :m .+1<CR>==
inoremap <C-Up> <Esc>:m .-2<CR>==gi
inoremap <C-Down> <Esc>:m .+1<CR>==gi
vnoremap <C-Up> :m '<-2<CR>gv==gv
vnoremap <C-Down> :m '>+1<CR>gv==gv
tnoremap <Esc> <C-\><C-n> <CR>

" Nvim Config
set number
"set cmdheight=0
" Auto reloads the config file after editing it
autocmd BufWritePost init.vim source init.vim


" Using Lua
lua << END
-- TODO Clone this repo https://github.com/MetalPhaeton/neo-easy-brackets and move its contents to ~/.config/nvim/lua
local cmp = require('cmp')
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
-- Setup cmp
cmp.setup({
    capabilities = lsp_capabilities,
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },  -- LSP suggestions (clangd)
        { name = 'buffer' },     -- Text from current file
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(), -- Trigger menu manually
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept selection
    }),
})

vim.lsp.enable('clangd')

vim.keymap.set('n', 'K', function() vim.diagnostic.open_float() end, {
	buffer = 0})

require("neo-easy-brackets"):map_insert():map_visual()
require('lualine').setup({
	options = {
		section_separators = '',
	},
	sections = {
		lualine_x = {'encoding', 'fileformat', 'lsp_status', 'filetype'},
	},
})
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	default_file_explorer = true,
	keymaps = {
		["<CR>"] = {
		callback = function()
			local entry = require("oil").get_cursor_entry()
			if entry and entry.type == "file" then
				require("oil.actions").select.callback({ tab = true ,close = true})
			else
				require("oil.actions").select.callback()
			end
		end,
		},
		["q"] = {
		callback = function()
			require("oil.actions").close.callback()
		end,
		},
	},
	
})
END
