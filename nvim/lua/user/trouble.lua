
local status_ok, configs = pcall(require, "trouble.configs")
if not status_ok then
  return
end

-- local trouble_telescope = require("trouble.providers.telescope")
-- local telescope = require("telescope")
-- telescope.setup {
--   defaults = {
--     mappings = {
--       i = { ["<c-z>"] = trouble_telescope.open_with_trouble },
--       n = { ["<c-z>"] = trouble_telescope.open_with_trouble },
--     },
--   },
-- }

configs.setup {
}

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)
