local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- Oliver's plugins
  -- Following three plugins are for quick navigation between elixir test and src
  -- files. See https://github.com/andyl/vim-projectionist-elixir. Tag: go to test
  use { "benfowler/telescope-luasnip.nvim" }
  use {'tpope/vim-projectionist'}
  use {'c-brenn/fuzzy-projectionist.vim'}
  use {'andyl/vim-projectionist-elixir'}

  use {
    "jcdickinson/codeium.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
        })
    end
  }
  --[[ use {"Exafunction/codeium.vim"} ]]
  use {"mg979/vim-visual-multi", branch='master'} -- Multi-selection using Ctrl + N
  use {"mbbill/undotree"} -- Shows undo history tracked by built-in :earlier and :later commands

  use {"kristijanhusak/vim-dadbod-ui"}
  use {"tpope/vim-dotenv"}
  use {"tpope/vim-dadbod"}
  use {"tpope/vim-abolish"}
  use {"brooth/far.vim"}

  -- Use g<, g> to swap parameters in a function https://github.com/machakann/vim-swap
  -- gs will start "swap mode" which will allow you to interactively swap things
  -- around using hl to navigate items, jk to choose item, and 1-9 to select an
  -- item
  use "machakann/vim-swap"


  -- Used for better, language-aware use of the % operator in Vim. Language-aware feature depends on treesitter
  use 'andymass/vim-matchup'

  -- Default plugins: 
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim"
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "folke/which-key.nvim"
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  use "benmills/vimux"
  use "janko/vim-test"
  use "christoomey/vim-tmux-navigator"
  use "flazz/vim-colorschemes"

  -- Colorschemes
  use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use  "ray-x/lsp_signature.nvim" -- signatures while typing

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  -- Lua
  use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
