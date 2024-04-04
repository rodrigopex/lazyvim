return {
    {
        "kkoomen/vim-doge",
    },
    {
        "nvim-treesitter/nvim-treesitter",
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
        "klen/nvim-test",
        opts = {
            run = true, -- run tests (using for debug)
            commands_create = true, -- create commands (TestFile, TestLast, ...)
            filename_modifier = ":.", -- modify filenames before tests run(:h filename-modifiers)
            silent = false, -- less notifications
            term = "terminal", -- a terminal to run ("terminal"|"toggleterm")
            termOpts = {
                direction = "vertical", -- terminal's direction ("horizontal"|"vertical"|"float")
                width = 96, -- terminal's width (for vertical|float)
                height = 24, -- terminal's height (for horizontal|float)
                go_back = false, -- return focus to original window after executing
                stopinsert = "auto", -- exit from insert mode (true|false|"auto")
                keep_one = true, -- keep only one terminal for testing
            },
            runners = { -- setup tests runners
                cs = "nvim-test.runners.dotnet",
                go = "nvim-test.runners.go-test",
                haskell = "nvim-test.runners.hspec",
                javascriptreact = "nvim-test.runners.jest",
                javascript = "nvim-test.runners.jest",
                lua = "nvim-test.runners.busted",
                python = "nvim-test.runners.pytest",
                ruby = "nvim-test.runners.rspec",
                rust = "nvim-test.runners.cargo-test",
                typescript = "nvim-test.runners.jest",
                typescriptreact = "nvim-test.runners.jest",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Ensure mason installs the server
                pyright = {},
                ruff_lsp = {
                    keys = {
                        {
                            "<leader>co",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.organizeImports" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Organize Imports",
                        },
                    },
                },
                clangd = {
                    keys = {
                        {
                            "<leader>cR",
                            "<cmd>ClangdSwitchSourceHeader<cr>",
                            desc = "Switch Source/Header (C/C++)",
                        },
                    },
                    root_dir = function(fname)
                        return require("lspconfig.util").root_pattern(
                            "Makefile",
                            "configure.ac",
                            "configure.in",
                            "config.h.in",
                            "meson.build",
                            "meson_options.txt",
                            "build.ninja"
                        )(fname) or require("lspconfig.util").root_pattern(
                            "compile_commands.json",
                            "compile_flags.txt"
                        )(fname) or require("lspconfig.util").find_git_ancestor(
                            fname
                        )
                    end,
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--header-insertion=never",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
            },
            setup = {
                clangd = function(_, opts)
                    local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
                    require("clangd_extensions").setup(
                        vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
                    )
                    return false
                end,
                ruff_lsp = function()
                    require("lazyvim.util").lsp.on_attach(function(client, _)
                        if client.name == "ruff_lsp" then
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                        end
                    end)
                end,
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = function()
            local plugin = require("lazy.core.config").plugins["conform.nvim"]
            -- if plugin.config ~= M.setup then
            --     Util.error({
            --         "Don't set `plugin.config` for `conform.nvim`.\n",
            --         "This will break **LazyVim** formatting.\n",
            --         "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
            --     }, { title = "LazyVim" })
            -- end
            ---@class ConformOpts
            local opts = {
                -- LazyVim will use these options when formatting with the conform.nvim formatter
                format = {
                    timeout_ms = 3000,
                    async = false, -- not recommended to change
                    quiet = false, -- not recommended to change
                },
                ---@type table<string, conform.FormatterUnit[]>
                formatters_by_ft = {
                    lua = { "stylua" },
                    fish = { "fish_indent" },
                    sh = { "shfmt" },
                    proto = { "buf" },
                    options = { "buf" },
                    python = { "autopep8" },
                },
                -- The options you set here will be merged with the builtin formatters.
                -- You can also define any custom formatters here.
                ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
                formatters = {
                    injected = { options = { ignore_errors = true } },
                    -- # Example of using dprint only when a dprint.json file is present
                    -- dprint = {
                    --   condition = function(ctx)
                    --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                    --   end,
                    -- },
                    --
                    -- # Example of using shfmt with extra args
                    -- shfmt = {
                    --   prepend_args = { "-i", "2", "-ci" },
                    -- },
                },
            }
            return opts
        end,
    },
}
