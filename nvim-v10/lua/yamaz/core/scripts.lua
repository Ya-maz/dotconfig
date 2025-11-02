local utils = require("yamaz.core.utils")
local snippets = require("yamaz.core.snippets")

-- #1
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (coping) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- -- #2
-- vim.api.nvim_create_autocmd('TermOpen', {
--     desc = 'Custom setting for term',
--     group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
--     callback = function()
--         vim.opt.number = false
--         vim.opt.relativenumber = false
--     end,
-- })

-- #3
vim.api.nvim_create_autocmd("FileType", {
	-- Для JS/TS файлов
	desc = "Apply custom snippets from snippets.lua file",
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		utils.apply_snippets(snippets.snippets)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		vim.bo.makeprg = "npm run test"
        vim.bo.errorformat = table.concat({
            [[%E%f:%l:%c\ -\ error\ %m,]],
            [[%Z%l%*\\s%m,]],
            [[%Z%*\\s%p^,]],
            [[%-G%.%#]],
        }, "")
	end,
})

-- #4
vim.api.nvim_create_autocmd({"BufReadPost"}, {
  group = vim.api.nvim_create_augroup("HighlightTODO", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for i, line in ipairs(lines) do
      for start_col, end_col in line:gmatch("()TODO()") do
        vim.api.nvim_buf_add_highlight(bufnr, -1, "Todo", i - 1, start_col - 1, end_col - 1)
      end
    end
  end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})
