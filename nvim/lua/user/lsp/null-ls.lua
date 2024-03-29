local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
    formatting.prettier.with({
      filetypes = {
        "json", "graphql", "markdown", "html", "javascriptreact", "typescriptreact", "markdown.mdx", "css", "scss", "jsonc", "less", "typescript", "javascript", "vue", "handlebars"
      },
    }),
		formatting.black.with({ extra_args = { "--fast" } }),
    formatting.shfmt
    -- formatting.rustywind.with({
    --   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "html", "elixir", "eelixir" },
    -- })
    -- formatting.stylua,
    -- diagnostics.flake8
	},
})
