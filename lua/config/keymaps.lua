-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end
-- Move to window using the <alt> left up down and right keys
map("n", "<A-Left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<A-Down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<A-Up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<A-Right>", "<C-w>l", { desc = "Go to right window" })
-- Move between tabs (buffers)
if Util.has("bufferline.nvim") then
    map("n", "<S-A-Left>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "<S-A-Right>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
    map("n", "<S-A-Left>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<S-A-Right>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
-- remove "Resize window using <ctrl> arrow keys"
map("n", "<C-Up>", "k")
map("n", "<C-Down>", "j")
map("n", "<C-Left>", "b")
map("n", "<C-Right>", "e")

-- map("n", "<space>r", function()
--     require("spectre").open_file_search({ select_word = true })
-- end, { desc = "Replace current word on the current file" })

map("n", "[<space>", "<cmd>call append(line('.')-1, '')<cr>", { desc = "Add 1 line before" })
map("n", "]<space>", "<cmd>call append(line('.'), '')<cr>", { desc = "Add 1 line after" })
