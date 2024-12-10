return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local fg_gutter = "#627E97" -- current line number colors
            --   local comment = "#735689"

            require("tokyonight").setup({
                -- style = "moon" })
                -- style = "night" })
                -- style = "day" })
                style = "storm",
                on_colors = function(colors)
                    colors.fg_gutter = fg_gutter
                end,

                -- on_highlights = function(hl, color)
                --     hl.Comment = {
                --         fg = comment
                --     }
                -- end,
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
        opts = {},
    },
}
