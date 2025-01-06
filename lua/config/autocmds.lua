-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
--
-- autocmd FileType cpp setlocal commentstring=// %s
-- Check if we need to reload the file when it changed
local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_rodrigopex_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    group = augroup("new_c_comment"),
    callback = function()
        vim.opt_local.commentstring = "// %s"
    end,
})
