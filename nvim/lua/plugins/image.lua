return {
    "3rd/image.nvim",
    ft = { "markdown", "norg", "org" },
    opts = {
        backend = "kitty", -- or "ueberzug" if you don't use Kitty/Wezterm
        max_width = 100,
        max_height = 12,
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    }
}
