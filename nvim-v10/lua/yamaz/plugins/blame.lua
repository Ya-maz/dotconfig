return {
    {
        "f-person/git-blame.nvim",
        config = function()
            vim.keymap.set("n", "<leader>bb", "<cmd>GitBlameToggle<cr>",
            { silent = true, noremap = true })
        end,
    }
}
