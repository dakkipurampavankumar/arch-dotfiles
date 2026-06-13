return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    lazy = 'true',
    cmd = {
        "Leet"
    }, 
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",
        -- optional
        "nvim-treesitter/nvim-treesitter",
        "rcarriga/nvim-notify",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- configuration goes here
        arg = "leetcode.nvim",
        lang = "c", -- or "c" based on your preference
        image_support = true,
    },
}
