-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
-- Helpful tools:
-- * Print out a specific config, for example:
--   print(vim.inspect(lvim.builtin.which_key.mappings))

-- BEGIN: General LunarVim config
lvim.version = "stable"
lvim.log.level = "info"
lvim.format_on_save.enabled = true
lvim.colorscheme = "lunar"
-- END: General LunarVim config

-- BEGIN: General Vim config
vim.cmd('set foldmethod=indent')
vim.cmd('set nofoldenable')
-- END: General Vim config


-- BEGIN: nvim-tree config
lvim.builtin.project.active = false
lvim.builtin.nvimtree.setup.view = { side = "left", width = 30 }
local function open_nvim_tree()
  require("nvim-tree.api").tree.open()
end

lvim.builtin.nvimtree.setup.filters.custom = {} -- do not filter out node_modules from file explorer!

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
-- END: nvim-tree config


-- BEGIN: treesitter config
lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = "gnn",
    node_incremental = "grn",
    scope_incremental = "grc",
    node_decremental = "grm",
  }
}
-- Treesitter bindings for incremental selection
--   NOTE: Unclear to me why lvim.keys... didn't work here. But it didn't, so just went with nvim_set_keymap instead.
vim.api.nvim_set_keymap("n", "<S-Up>", "gnn", {})
vim.api.nvim_set_keymap("n", "<S-Down>", "grm", {})
vim.api.nvim_set_keymap("v", "<S-Up>", "grn", {})
vim.api.nvim_set_keymap("v", "<S-Down>", "grm", {})
-- END: treesitter config


-- BEGIN: whichkey config
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
lvim.builtin.which_key.mappings["r"] = {
  name = "Find and Replace All",
  r = { "<Plug>CtrlSFPrompt -R", "Regex find and replace all (begin typing after running this key to start typing out the find query)" },
  a = { "<Plug>CtrlSFPrompt", "Find and replace all (begin typing after running this key to start typing out the find query)" }
}
lvim.builtin.which_key.mappings["lu"] = {
  "<cmd>:Telescope lsp_references<CR>", "Find usage of symbol"
}
lvim.builtin.which_key.mappings["ld"] = {
  "<cmd>:Telescope lsp_definitions<CR>", "Find definition of symbol"
}
-- END: whichkey config


-- BEGIN: keymaps
lvim.keys.normal_mode["gt"] = "<cmd>BufferLineCycleNext<cr>"
lvim.keys.normal_mode["gT"] = "<cmd>BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>" -- Easier saving with Ctrl + S

-- Run test helpers - note that these commands come from vim-test
vim.cmd('let test#strategy = "vimux"')
lvim.keys.normal_mode["<C-t><C-n>"] = ":w <bar> TestNearest<cr>"
lvim.keys.normal_mode["<C-t><C-f>"] = ":w <bar> TestFile<cr>"
lvim.keys.normal_mode["<C-t><C-t>"] = ":w <bar> TestLast<cr>"
lvim.keys.normal_mode["<C-t><C-l>"] = ":w <bar> TestLast<cr>"
lvim.keys.normal_mode["<C-t><C-s>"] = ":w <bar> TestSuite<cr>"

-- Diagnostic key mappings for LunarVim
lvim.keys.normal_mode["gl"] = "<cmd>lua vim.diagnostic.open_float()<CR>"
lvim.keys.normal_mode["[d"] = '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>'
lvim.keys.normal_mode["]d"] = '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>'
lvim.keys.normal_mode["[e"] =
'<cmd>lua vim.diagnostic.goto_prev({ border = "rounded", severity = vim.diagnostic.severity.ERROR })<CR>'
lvim.keys.normal_mode["]e"] =
'<cmd>lua vim.diagnostic.goto_next({ border = "rounded", severity = vim.diagnostic.severity.ERROR})<CR>'
lvim.keys.normal_mode["<leader>q"] = "<cmd>lua vim.diagnostic.setloclist()<CR>"

-- Next git hunk navigation
lvim.keys.normal_mode["]c"] = ":Gitsigns next_hunk<CR>"
lvim.keys.normal_mode["[c"] = ":Gitsigns prev_hunk<CR>"

-- If text is selected, save it in the v buffer and send that buffer it to tmux
lvim.keys.visual_mode["<C-c><C-c>"] = "\"vy :call VimuxRunCommand(@v, 0)<CR>"

-- Select current paragraph and send it to tmux
lvim.keys.normal_mode["<C-c><C-c>"] = "vip\"vy :call VimuxRunCommand(@v)<CR>"
lvim.keys.normal_mode["<C-c><C-l>"] = ":wa <bar> VimuxRunLastCommand<CR>"

-- Easier navigation between vim panes
lvim.keys.normal_mode["<C-h>"] = "<C-w>h"
lvim.keys.normal_mode["<C-j>"] = "<C-w>j"
lvim.keys.normal_mode["<C-k>"] = "<C-w>k"
lvim.keys.normal_mode["<C-l>"] = "<C-w>l"
-- END: keymaps


-- BEGIN: LSP config
-- Override settings in ~/.config/lvim/ftplugin/tailwindcss.lua
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tailwindcss", "tsserver" })

-- Don't use tsserver formatter
require("lvim.lsp.manager").setup("tsserver", {
  -- capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  debug = true,
  { name = "black" },
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    -- args = { "--print-width", "100" },
    --- @usage only start in these filetypes, by default it will attach to all filetypes it supports
    -- filetypes = { "typescript", "typescriptreact" },
  }
}
-- END: LSP config


--- BEGIN: Plugins
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
  { "dyng/ctrlsf.vim" },
  {
    "machakann/vim-swap",
  },
  { "vim-test/vim-test" },
  { "preservim/vimux" },
  { "tpope/vim-surround" }
}
-- END: Plugins


-- BEGIN: Misc. vim config
vim.api.nvim_command("set clipboard=") -- don't yank to system clipboard

-- Codeium AI helper
lvim.builtin.cmp.formatting.source_names["codeium"] = "(Codeium)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "codeium" }) -- show a nicer view of Codeium completions in a dropdown
-- END: Misc. vim config
