local M = {}

M.config = function()
  lvim.plugins = {
    { "sainnhe/gruvbox-material" },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user/lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "vladdoster/remember.nvim",
      config = function()
        require("remember").setup {}
      end,
      event = "BufWinEnter",
    },
    {
      "folke/trouble.nvim",
      config = function()
        require("trouble").setup {
          auto_open = true,
          auto_close = true,
          padding = false,
          height = 10,
          use_diagnostic_signs = true,
        }
      end,
      cmd = "Trouble",
    },
    {
      "phaazon/hop.nvim",
      branch = "v2",
    },
  }
  -- não sei o poruqe, mas a função config do hop não funciona nem pelo satanás.
  require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }
  require("user.hop").config()
end

return M
