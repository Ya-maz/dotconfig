return {
	{
		"f-person/git-blame.nvim",
		config = function()
			vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gbc", "<cmd>GitBlameCopySHA<cr>", { silent = false, noremap = true })
		end,
	},
}
