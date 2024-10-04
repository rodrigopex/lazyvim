return {
    "mfussenegger/nvim-dap",
    opts = function()
        local dap = require("dap")
        if not dap.adapters["codelldb"] then
            require("dap").adapters["codelldb"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = {
                        "--port",
                        "${port}",
                    },
                },
            }
        end
        dap.configurations.c = {
            {
                name = "Attach to Jlink gdbserver :2331",
                type = "cppdbg",
                request = "launch",
                target = "localhost:2331",
                cwd = "${workspaceFolder}",
                program = "${workspaceFolder}/build/zephyr/zephyr.elf",
                stopAtEntry = false,
                MIMode = "gdb",
                miDebuggerServerAddress = "localhost:2331",
                miDebuggerPath = "/Users/rodrigopeixoto/.local/zephyr-sdk-0.16.8/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb",
                postRemoteConnectCommands = {
                    {
                        text = "file ./build/zephyr/zephyr.elf",
                        ignoreFailures = false,
                    },
                    {
                        text = "load",
                        ignoreFailures = false,
                    },
                },
            },
        }
    end,
}
