return {
    "nvim-neorg/neorg",
    version = "5.0.0",
    ft = "norg",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {
                config = {
                    icon_preset = "diamond"
                }
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/Documents/nvim/neorg",
                    },
                    default_workspaces = "notes",
                    index = "index.norg"
                }
            }
        }
    }
}
