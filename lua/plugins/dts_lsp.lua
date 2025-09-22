local function dts_include_folders()
    -- The find command to execute. Using '-print0' is good practice for scripting.
    local root_dir = vim.fn.system("west topdir")

    -- The system() function returns an extra newline, so we need to trim it.
    root_dir = root_dir:gsub("\n", "")

    -- If the command failed, or the directory doesn't exist, show an error.
    if root_dir == "" or not vim.fn.isdirectory(root_dir) then
        vim.notify(
            "Could not find the 'west topdir'. Make sure you are in a valid project.",
            vim.log.levels.ERROR
        )
        return
    end

    local defaultIncludePaths = {
        -- "./zephyr/dts",
        "./zephyr/dts/arm",
        "./zephyr/dts/arm64/",
        "./zephyr/dts/riscv",
        "./zephyr/dts/common",
        "./zephyr/dts/vendor",
        "./zephyr/include",
    }

    local command = [[find `west topdir` -type d \( -name "dts" -o -name "fdts" -o -name "plat" \)]]

    -- Execute the command and capture the output.
    -- The `string.split` function can be used to split the output.
    -- Note: This is a synchronous call and will block Neovim.
    local result = vim.fn.system(command)

    -- Split the output by the null character (used with -print0).
    local files = vim.split(result, "\n", { plain = true })

    for _, value in ipairs(files) do
        if value ~= "" then
            local nv = value:gsub(root_dir, ".")
            table.insert(defaultIncludePaths, nv)
        end
    end

    -- Process the list of files.

    local log_file = io.open("/tmp/dts_lsp_nvim.log", "w")
    if log_file then
        log_file:write(result)
        log_file:write(vim.inspect(defaultIncludePaths))
        log_file:close()
    end

    return defaultIncludePaths
end

return {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
        -- Don't let Mason try to handle this custom server
        opts.servers.devicetree_ls = nil

        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Enable semantic tokens
        capabilities.textDocument = capabilities.textDocument or {}
        capabilities.textDocument.semanticTokens = {
            dynamicRegistration = false,
            requests = {
                range = false,
                full = true,
            },
            tokenTypes = {
                "namespace",
                "class",
                "enum",
                "interface",
                "struct",
                "typeParameter",
                "type",
                "parameter",
                "variable",
                "property",
                "enumMember",
                "decorator",
                "event",
                "function",
                "method",
                "macro",
                "label",
                "comment",
                "string",
                "keyword",
                "number",
                "regexp",
                "operator",
            },
            tokenModifiers = {
                "declaration",
                "definition",
                "readonly",
                "static",
                "deprecated",
                "abstract",
                "async",
                "modification",
                "documentation",
                "defaultLibrary",
            },
            formats = { "relative" },
        }

        -- Enable formatting
        capabilities.textDocument.formatting = {
            dynamicRegistration = false,
        }

        -- Enable folding range support
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        if not configs.devicetree_ls then
            configs.devicetree_ls = {
                default_config = {
                    cmd = { "devicetree-language-server", "--stdio" },
                    filetypes = { "dts", "dtsi", "overlay" },
                    root_dir = lspconfig.util.root_pattern("zephyr", ".git", "."),
                    settings = {
                        devicetree = {
                            defaultIncludePaths = dts_include_folders(),
                            --     {
                            --     "./zephyr/dts",
                            --     "./zephyr/dts/arm",
                            --     "./zephyr/dts/arm64/",
                            --     "./zephyr/dts/riscv",
                            --     "./zephyr/dts/common",
                            --     "./zephyr/dts/vendor",
                            --     "./zephyr/include",
                            --     "./modules/tee/tf-a/trusted-firmware-a/include/plat",
                            --     "./modules/tee/tf-a/trusted-firmware-a/include/export/plat",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/rdn2/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/a5ds/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/rdn1edge/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/n1sdp/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/morello/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/rde1edge/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/tc/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/corstone1000/common/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/rdv1/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/fvp_ve/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/juno/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/sgi575/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/fvp/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/plat/arm/board/rdv1mc/fdts",
                            --     "./modules/tee/tf-a/trusted-firmware-a/docs/plat",
                            --     "./modules/tee/tf-a/trusted-firmware-a/fdts",
                            --     "./modules/hal/nxp/dts",
                            --     "./modules/hal/stm32/dts",
                            --     "./modules/hal/microchip/dts",
                            --     "./modules/hal/nuvoton/dts",
                            -- },
                            cwd = "${workspaceFolder}",
                            defaultBindingType = "Zephyr",
                            defaultZephyrBindings = {
                                "./zephyr/dts/bindings",
                            },
                            autoChangeContext = true,
                            allowAdhocContexts = true,
                            contexts = {},
                        },
                    },
                    capabilities = capabilities,
                },
            }
        end

        vim.notify("Custom devicetree_ls LSP loaded with semantic tokens & folding")

        -- Setup the LSP
        lspconfig.devicetree_ls.setup({
            capabilities = capabilities,
        })
    end,
}
