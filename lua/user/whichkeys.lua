local M = {}
M.config = function()
  lvim.builtin.which_key.mappings["t"] = {
    name = "Telescope",
    p = {
      name = "Projects"
    }
  }
  lvim.builtin.which_key.mappings["u"] = {
    name = " Octo",
    c = { "<cmd>Octo comment add", "Add comment" },
    i = {
      name = "Issues",
      l    = { "<cmd>Octo issue list<cr>", "List" }
    },
    p = {
      name = "Pull requests",
      l = { "<cmd>Octo pr list<cr>", "List" },
      c = { "<cmd>Octo pr checkout<cr>", "Checkout" },
      r = { "<cmd>Octo pr reload<cr>", "Refresh" },
      m = { "<cmd>Octo pr merge<cr>", "Merge PR" },
      b = { "<cmd>Octo pr browser<cr>", "Open current PR" },
    },
    r = {
      name = "Review",
      s = { "<cmd>Octo review start<cr>", "Start a review" },
      u = { "<cmd>Octo review submit<cr>", "Submit a review" }
    }
  }
end

return M
