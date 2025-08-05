local keymap = vim.keymap
local markdown_utils = require('yamaz.core.markdown-utils')

vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
--
keymap.set('n', '<leader><CR>', markdown_utils.link, { desc = 'Обработать Markdown-ссылку под курсором' })
keymap.set("v", "J", ":m '>+2<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--Do not yank with x
-- keymap.set("n", "x", "_x")

--Select all
keymap.set("n", "<leader>sa", "gg<S-v>G")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- --Move window
-- keymap.set("n", "rh", "<C-w>h")
-- keymap.set("n", "rk", "<C-w>k")
-- keymap.set("n", "rj", "<C-w>j")
-- keymap.set("n", "rl", "<C-w>l")
keymap.set("n", "fwh", "<C-w>h")
keymap.set("n", "fwj", "<C-w>j")
keymap.set("n", "fwk", "<C-w>k")
keymap.set("n", "fwl", "<C-w>l")

--Resize window
keymap.set("n", "<C-M-h>", "<C-w><")
keymap.set("n", "<C-M-l>", "<C-w>>")
keymap.set("n", "<C-M-k>", "<C-w>+")
keymap.set("n", "<C-M-j>", "<C-w>-")

-- Split line under cursor and second line
keymap.set("n", "J", "mzJ`z")

-- Navigation keymap
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-e>", "<C-u>zz")

keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])
keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
-- keymap.set("i", "<C-c>", "<Esc>")

-- keymap.set("n", "Q", "<nop>")

keymap.set("n", "<C-q>", ":bdelete<Return><C-w>w")
-- quicklist navigation
keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-m>", "<cmd>cprev<CR>zz")

-- change buffer(now change from telescope)
-- keymap.set("n", "<C-l>", "<cmd>bnext<CR>")
-- keymap.set("n", "<C-h>", "<cmd>bprevious<CR>")
-- keymap.set("n", "<C-l>", ":bnext<Return><C-w>w")
-- keymap.set("n", "<C-h>", ":bprev<Return><C-w>w")

-- quicklist navigation(old)
-- keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
keymap.set("n", "<leader>b", ":ls<cr>:b<space>")

keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "<leader>r", [[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
-- keymap.set("n", "<leader>x", ":.lua<CR>")
-- keymap.set("v", "<leader>x", ":lua<CR>")
keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

keymap.set("n", "<leader>rn", function()
    local file_name = vim.api.nvim_buf_get_name(0)
    local file_type = vim.bo.filetype

    print(file_name, file_type)

    if file_type == "lua" then
        vim.cmd(":terminal lua " .. file_name)
    elseif file_type == "javascript" then
        vim.cmd(":terminal node " .. file_name)
    end
end)

--
keymap.set("n", "<esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

--Identing
keymap.set("v", "<", "<gv", { silent = true, noremap = true })
keymap.set("v", ">", ">gv", { silent = true, noremap = true })

-- tab management
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab

-- terminal term
local job_id = 0
keymap.set('t', '<leader>q', "<C-\\><C-n>", { silent = true }) -- exit from termial mode
keymap.set("n", "<leader>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")

    job_id = vim.bo.channel
end)

keymap.set("n", "<leader>test", function()
    -- any other command 
    -- ls
    -- echo "hello world"
   vim.fn.chansend(job_id, { "npm run test \r\n" })
end)
-- setting for current job project 
keymap.set("n", "<leader>style", function()
    -- any other command 
    -- ls
    -- echo "hello world"
   vim.fn.chansend(job_id, { "npx stylelint src/apps/**/**.scss --fix \r\n" })
end)

-- Маппинги для терминала открывает файл под курсором
vim.keymap.set("n", "<C-LeftMouse>", [[<C-\><C-n>:lua require("yamaz.core.utils").open_file_under_cursor()<CR>]], { noremap = true })
vim.keymap.set("n", "<leader>o", [[<C-\><C-n>:lua require("yamaz.core.utils").open_file_under_cursor()<CR>]], { noremap = true })
