-- options --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loeaded_netrwFileHandlers = 1

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.mouse = ""
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.tabstop = 4
vim.opt.vb = false

-- keymaps --

-- <leader>c will copy
-- <leader>v will paste
vim.keymap.set({ 'n', 'v' }, "<leader>c", [["+y]])
vim.keymap.set({ 'n', 'v' }, "<leader>v", [["+p]])

-- better navigation
vim.keymap.set('n', "<C-h>", "<C-w>h", { remap = true, silent = true })
vim.keymap.set('n', "<C-j>", "<C-w>j", { remap = true, silent = true })
vim.keymap.set('n', "<C-k>", "<C-w>k", { remap = true, silent = true })
vim.keymap.set('n', "<C-l>", "<C-w>l", { remap = true, silent = true })

-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', "gj")
vim.keymap.set('n', 'k', "gk")

-- no arrow keys --- force yourself to use home row
vim.keymap.set({ 'n', 'i' }, "<up>", "<nop>")
vim.keymap.set({ 'n', 'i' }, "<down>", "<nop>")
vim.keymap.set({ 'n', 'i' }, "<left>", "<nop>")
vim.keymap.set({ 'n', 'i' }, "<right>", "<nop>")

vim.keymap.set('n', "<leader>w", function()
	vim.lsp.buf.format()
	vim.cmd("write")
end)

-- plugins --
vim.pack.add({
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range('1.*')
	},
	{ src = "https://github.com/Saecki/crates.nvim" },
	{ src = "https://github.com/echasnovski/mini.pairs" }
})

-- auto completion
require("blink.cmp").setup({
	keymap = {
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-y>"] = { "select_and_accept" },
		["<C-e>"] = { "hide" },
		['<C-b>'] = { function(cmp) cmp.scroll_documentation_up(4) end },
		['<C-f>'] = { function(cmp) cmp.scroll_documentation_down(4) end },
		["<C-s>"] = { "show_signature" }
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" }
	},
	signature = { enabled = true },
	fuzzy = {
		implementation = "lua"
	}
})

require("nvim-web-devicons").setup()

require("nvim-treesitter.configs").setup({
	auto_install = true, -- Automatically installs missing parsers
	sync_install = { false },
	highlight = { enable = true },
	indent = { enable = true },
})

-- nvim-tree
require("nvim-tree").setup({
	vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<cr>", { noremap = true, silent = true }),
	view = {
		width = 30,
	}
})

require("mini.pairs").setup()
require("lualine").setup()
require("crates").setup()

local function prefix_diagnostic(prefix, diagnostic)
	return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
	virtual_text = {
		prefix = '',
		format = function(diagnostic)
			local severity = diagnostic.severity
			if severity == vim.diagnostic.severity.ERROR then
				return prefix_diagnostic('󰅚', diagnostic)
			end
			if severity == vim.diagnostic.severity.WARN then
				return prefix_diagnostic('⚠', diagnostic)
			end
			if severity == vim.diagnostic.severity.INFO then
				return prefix_diagnostic('ⓘ', diagnostic)
			end
			if severity == vim.diagnostic.severity.HINT then
				return prefix_diagnostic('󰌶', diagnostic)
			end
			return prefix_diagnostic('■', diagnostic)
		end,
		max_width = 60,
		truncate = true
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '󰅚',
			[vim.diagnostic.severity.WARN] = '⚠',
			[vim.diagnostic.severity.INFO] = 'ⓘ',
			[vim.diagnostic.severity.HINT] = '󰌶',
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = 'normal',
		border = 'single',
		source = 'if_many',
		header = '',
		prefix = '',
		wrap = false
	},
}

-- Trigger float on hover intelligently
vim.o.updatetime = 300
vim.api.nvim_create_augroup("DiagFloat", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = "DiagFloat",
	callback = function()
		-- Only open float if no other floating window is active
		for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_win_get_config(w).zindex then return end
		end
		vim.diagnostic.open_float(nil, { scope = "cursor" })
	end,
})

-- color
vim.cmd("colorscheme moonfly")

-- lsp

vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("solidity_ls_nomicfoundation")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("bashls")
vim.lsp.enable("taplo")
