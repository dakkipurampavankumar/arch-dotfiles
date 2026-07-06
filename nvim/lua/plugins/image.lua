return {
    "3rd/image.nvim",
    -- Load eagerly so it's available for alpha dashboard image
    lazy = false,
    opts = {
        backend = "sixel",
        max_width = 100,
        max_height = 12,
        max_width_window_percentage = 80,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    }
}
