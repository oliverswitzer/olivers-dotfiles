
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
