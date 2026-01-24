-- Функция для проверки режима
-- В системе есть alias такого вида
-- alias nn='nvim --cmd "let g:weak_mode = 1"'
local function is_weak_mode()
    return vim.g.weak_mode == 1
end

local function is_ultra_weak_mode()
        return vim.g.ultra_weak_mode == 1
end

local function get_keymap_opts(desc)
    return {
        noremap = true,
        silent = true,
        buffer = true,
        desc = desc
    }
end

local function apply_snippets(snippets)
    for _, snippet in ipairs(snippets) do
        vim.keymap.set(
            snippet.mode,
            snippet.key_map,
            snippet.command,
            get_keymap_opts(snippet.desc)
        )
    end
end

return {
    is_weak_mode = is_weak_mode,
    is_ultra_weak_mode = is_ultra_weak_mode,
    apply_snippets = apply_snippets,
}

