vim.opt.rtp:prepend("$HOME/.config/nvim-v10")
vim.opt.rtp:prepend("$HOME/.config/nvim-v10/lua")

-- code
require("yamaz.core")
require("yamaz.lazy")
-- langmapper break next keymap:
-- ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
-- ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
-- A plugin that makes Neovim more friendly to non-English input methods 🤝
-- require('langmapper').automapping({ global = true, buffer = true })
-- end of init.lua
--
-- https://github.com/folke/lazy.nvim/tree/main
-- config from :
-- https://github.com/josean-dev/dev-environment-files/tree/main
--
--
-- use font
-- Hack Nerd Font
-- https://www.nerdfonts.com/font-downloads
--
local info = debug.getinfo(1, "S")
local config_file = info.source:sub(2)  -- убираем '@'



-- Динамическая версия Neovim
local v = vim.version()
local version_str = string.format("%d.%d.%d", v.major, v.minor, v.patch)

-- Если нужно, можно и в :messages
print(string.format("[NVIM-CONFIG]: %s", config_file))
print(string.format("[NVIM-VERSION]: %s", version_str))

