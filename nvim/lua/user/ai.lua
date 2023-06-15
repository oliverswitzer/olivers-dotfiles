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
