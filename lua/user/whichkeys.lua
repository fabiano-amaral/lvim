local M = {}
M.config = function()
  lvim.builtin.which_key.mappings["t"] = {
    name = "Telescope",
    p = {
      name = "Projects"
    }
  }
end

return M
