return {
    { "navarasu/onedark.nvim", opts = { style = "cool" } },
    { "rebelot/kanagawa.nvim", opts = { style = "lotus" } },
    { "ellisonleao/gruvbox.nvim", opts = { background = "dark" } },
    { "catppuccin/nvim", name = "catppuccin", opts = { style = "frappe" } },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
            -- colorscheme = "kanagawa-wave",
        },
    },
}
