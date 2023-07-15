table.unpack = table.unpack or unpack for _, pkg in pairs({ "xclip", "clang-format"}) do
	local found = false
	for _, path in pairs(vim.fn.split(vim.env.PATH, ":")) do
		if vim.loop.fs_stat(path .. "/" .. pkg) then found = true end
	end
	if found == false then error(pkg .. "not found in PATH") end
end
local o = vim.opt
local function set_autocmds(autocmds)
	for _, autocmd in pairs(autocmds) do
		vim.api.nvim_create_autocmd(table.unpack(autocmd))
	end
end
local function set_options(options)
	for k, v in pairs(options) do
		o[k] = v
	end
end
local function set_keymaps(keymaps)
	for _, v in pairs(keymaps) do
		vim.keymap.set(v[1], v[2], v[3], v[4])
	end
end
set_options({
	cursorline = true,
	cursorlineopt = "screenline",
	number = true,
	relativenumber = true,
	scrolloff = 999,
	updatetime = 200,
	timeout = false,
	hlsearch = false,
	pumheight = 7,
	clipboard = o.clipboard + "unnamedplus",
})

set_keymaps({
	{ { "n", "v" }, "<right>", "<nop>",                     {} },
	{ {"n", "v" }, "<left>",  "<nop>",                     {} },
	{ {"n", "v" }, "<up>",    "<nop>",                     {} },
	{ {"n", "v" }, "<down>",  "<nop>",                     {} },
	{ { "c" },                "Q",       "q",                         { noremap = true } },
	{ { "c" },                "W",       "w",                         { noremap = true } },
	{ { "n", "v" },           "P",       [["+P]],                     { noremap = true } },
	{ { "n", "v" },           "p",       [["+p]],                     { noremap = true } },
	{ { "n", "v" },           "y",       [["+y]],                     { noremap = true } },
	{ { "n", "v" },           "x",       [["_x]],                     { noremap = true } },
	{ { "n", "v" },           "m",       [["+d]],                     { noremap = true } },
	{ { "n", "v" },           "mm",      [["+dd]],                    { noremap = true } },
	{ { "n", "v" },           "d",       [["_d]],                     { noremap = true } },
	{ { "n", "v" },           "c",       [["_c]],                     { noremap = true } },
	{ { "n", "v" },           "k",       "v:count == 0 ? 'gk' : 'k'", { expr = true,  noremap = true } },
	{ { "n", "v" },           "j",       "v:count == 0 ? 'gj' : 'j'", { expr = true,  noremap = true } },
})
local _lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(_lazypath) then
	os.execute("git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable " .. _lazypath)
end
vim.opt.rtp:prepend(_lazypath)
require("lazy").setup({
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"lua_ls",
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function() require("mason").setup() end,
	},
	{ "tpope/vim-surround", },
	{
		"easymotion/vim-easymotion",
		config = function()
			set_keymaps({
				{ { "n", "o", "v" }, "f", "<Plug>(easymotion-fl)", { noremap = true } },
				{ { "n", "o", "v" }, "F", "<Plug>(easymotion-Fl)", { noremap = true } },
				{ { "n", "o", "v" }, "t", "<Plug>(easymotion-tl)", { noremap = true } },
				{ { "n", "o", "v" }, "T", "<Plug>(easymotion-Tl)", { noremap = true } },
			})
		end,
	},
})
set_autocmds({
	{ { "TextYankPost" }, { pattern = "*", callback = function() vim.highlight.on_yank({ timeout = 500 }) end } },
})
