local status_ok, neoai = pcall(require, "neoai")
if not status_ok then
	return
end

neoai.setup({
  models = {
    {
      name = "openai",
      model = "gpt-4-32k",
      params = nil,
    },
  },
  shortcuts = {
    {
        name = "textify",
        key = "<leader>as",
        desc = "fix text with AI",
        use_context = true,
        prompt = [[
            Please rewrite the text to make it more readable, clear,
            concise, and fix any grammatical, punctuation, or spelling
            errors
        ]],
        modes = { "v" },
        strip_function = nil,
    },
    {
        name = "gitcommit",
        key = "<leader>ag",
        desc = "generate git commit message",
        use_context = false,
        prompt = function ()
            return [[
                Using the following git diff generate a consise and
                clear git commit message, with a short title summary
                that is 75 characters or less:
            ]] .. vim.fn.system("git diff --cached")
        end,
        modes = { "n" },
        strip_function = nil,
    },
  }
})


local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
	return
end

copilot.setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})
