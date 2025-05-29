-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "h", "dts" },
    callback = function()
        vim.opt_local.commentstring = "// %s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "conf", "ini" },
    callback = function()
        vim.opt_local.commentstring = "# %s"
    end,
})

-- vim.api.nvim_create_autocmd("BufRead", {
--     group = vim.api.nvim_create_augroup("detect_conf", { clear = true }),
--     desc = "Set filetype for *.conf files",
--     pattern = { "*.conf", ".config", ".config.sysbuild" },
--     callback = function()
--         vim.cmd("set filetype=ini")
--         vim.opt_local.commentstring = "# %s"
--     end,
-- })
