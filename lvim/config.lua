-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.format_on_save.enabled = true

lvim.builtin.which_key.mappings["o"] = {
  name = "Oliver's Keys",
  g = {
    name = "Open in Github",
    f = { "<cmd>:OpenInGHFile<CR>", "Open Current File" },
    r = { "<cmd>:OpenInGHRepo<CR>", "Open Github Repo" },
  },
  h = { "<cmd>UndotreeToggle<cr>", "Local history" },
  t = { "<cmd> :A<CR>", "Go to test" },
  v = { "<cmd> :AV<CR>", "Go to test with vertical split" },
  f = { "<cmd>lua require('telescope.builtin').find_files({hidden = true})<cr>", "Find all files" },
  d = { "<cmd>:DBUI<CR>", "Query Database" },
  s = { "<cmd>:Telescope luasnip<CR>", "Search snippets for current buffer" }
}

--- Keymaps

lvim.keys.normal_mode["<C-h>"] = "<C-w>h"
lvim.keys.normal_mode["<C-j>"] = "<C-w>j"
lvim.keys.normal_mode["<C-k>"] = "<C-w>k"
lvim.keys.normal_mode["<C-l>"] = "<C-w>l"

--- LSPs
-- Override settings in ~/.config/lvim/ftplugin/tailwindcss.lua
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tailwindcss" })

--- Formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    args = { "--print-width", "100" },
    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact" },
  },
}


--- Oliver's plugins
lvim.plugins = {
  {
    "aserowy/tmux.nvim",
    config = function() return require("tmux").setup() end
  },
  {
    "benfowler/telescope-luasnip.nvim",
  },
  {
    "tpope/vim-projectionist",
  },
  {
    "c-brenn/fuzzy-projectionist.vim",
  },
  {
    "andyl/vim-projectionist-elixir",
  },

  {
    "jcdickinson/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
      })
    end
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn["mkdp#util#install"]() end
  },
  {
    "Bryley/neoai.nvim",
    dependencies = { "MunifTanjim/nui.nvim" }
  },
  {
    "almo7aya/openingh.nvim",
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
  },
  {
    "mbbill/undotree",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
  },
  {
    "tpope/vim-dotenv",
  },
  {
    "tpope/vim-dadbod",
  },
  { "tpope/vim-fugitive" },
  {
    "tpope/vim-abolish",
  },
  {
    "brooth/far.vim",
  },
  {
    "machakann/vim-swap",
  }
}
