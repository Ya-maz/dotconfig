return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            -- This will not install any breaking changes.
            -- For major updates, this must be adjusted manually.
            version = "^1.0.0",
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require('telescope.builtin')

        telescope.setup({
            defaults = {
                path_display = { "truncate " },
                file_ignore_patterns = { "node_modules" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-d>"] = actions.delete_buffer
                    },
                },
            },
        })
        -- then load the extension
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")

        -- скрипт для поиска целой строки
        vim.api.nvim_create_user_command('LiveGrepLiteral', function()
            builtin.live_grep({
                additional_args = function()
                    return { "-F", "--no-ignore", "--hidden" }
                end
            })
        end, {})

        local edit_config_options = {
            cwd = vim.fn.stdpath('config'),
            results_title = 'config'
        }

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffere", noremap = true })
        keymap.set("n", "<C-p>", "<cmd>Telescope git_files<cr>", { desc = "Fuzzy find git files" })
        keymap.set("n", "<leader>fs", telescope.extensions.live_grep_args.live_grep_args, { noremap = true })
        keymap.set("n", "<leader>en", function()
            builtin.find_files(edit_config_options)
        end, { desc = "Fuzzy find [K]onfig files" })
        keymap.set('n', '<leader>lg', ':LiveGrepLiteral<CR>', { desc = 'Live Grep (Literal)' })

    end,
}
