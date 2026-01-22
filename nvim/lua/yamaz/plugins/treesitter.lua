return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = "v0.9.3", -- 🔒 стабильная версия
		build = ":TSUpdate",

		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				lazy = false,
			},
			{
				"windwp/nvim-ts-autotag",
				lazy = false,
			},
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				lazy = false,
			},
		},

		config = function()
            vim.g.skip_ts_context_commentstring_module = true
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"go",
					"gomod",
				},

				highlight = { enable = true },
				indent = { enable = true },

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						node_decremental = "<bs>",
					},
				},

				autotag = { enable = true },

				-- context_commentstring = {
				-- 	enable = true,
				-- 	enable_autocmd = false,
				-- },

				textobjects = {
					select = {
						enable = true,
						lookahead = true,
					},
				},
			})
		end,
	},
}
