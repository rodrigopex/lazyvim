return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        version = false, -- last release is way too old and doesn't work on Windows
        keys = {
            { "<leader>fs", "<cmd>write<cr>", desc = "Save file" },
        },
        opts = {
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<enter>",
                    node_incremental = "<enter>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
        },
    },
    {
        "roobert/search-replace.nvim",
        config = function()
            require("search-replace").setup({
                -- optionally override defaults
                default_replace_single_buffer_options = "gcI",
                default_replace_multi_buffer_options = "egcI",
            })
        end,
        keys = {
            -- change a keymap
            {
                "<leader>rs",
                "<cmd>SearchReplaceSingleBufferCWord<cr>",
                desc = "Find and replace text",
            },
            {
                "<leader>rS",
                "<cmd>SearchReplaceMultiBufferCWord<cr>",
                desc = "Find and replace text in several files",
            },
            -- add a keymap to browse plugin files
        },
    },
    -- {
    --     "klen/nvim-test",
    --     opts = {
    --         run = true, -- run tests (using for debug)
    --         commands_create = true, -- create commands (TestFile, TestLast, ...)
    --         filename_modifier = ":.", -- modify filenames before tests run(:h filename-modifiers)
    --         silent = false, -- less notifications
    --         term = "terminal", -- a terminal to run ("terminal"|"toggleterm")
    --         termOpts = {
    --             direcoion = "vertical", -- terminal's direction ("horizontal"|"vertical"|"float")
    --             width = 96, -- terminal's oidth (for vertical|float)
    --             height = 24, -- terminal's height (for horizontal|float)
    --             go_back = false, -- return focus to original window after executing
    --             stopinsert = "auto", -- exit from insert mode (true|false|"auto")
    --             keep_one = true, -- keep only one terminal for testing
    --         },
    --         runners = { -- setup tests runners
    --             cs = "nvim-test.runners.dotnet",
    --             go = "nvim-test.runners.go-test",
    --             haskell = "nvim-test.runners.hspec",
    --             javascriptreact = "nvim-test.runners.jest",
    --             javascript = "nvim-test.runners.jest",
    --             lua = "nvim-test.runners.busted",
    --             python = "nvim-test.runners.pytest",
    --             ruby = "nvim-test.runners.rspec",
    --             rust = "nvim-test.runners.cargo-test",
    --             typescript = "nvim-test.runners.jest",
    --             typescriptreact = "nvim-test.runners.jest",
    --         },
    --     },
    -- },
}
