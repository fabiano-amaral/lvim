local M = {}

M.config = function()
  lvim.plugins = {
    { "leoluz/nvim-dap-go" },
    { "folke/zen-mode.nvim" },
    { "eddyekofo94/gruvbox-flat.nvim" },
    { 'cljoly/telescope-repo.nvim' },
    { "luisiacc/gruvbox-baby" },
    { "sainnhe/gruvbox-material" },
    {
      "ThePrimeagen/harpoon",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
      },
      disable = not lvim.builtin.harpoon.active,
    },
    {
      "folke/noice.nvim",
      event = "VimEnter",
      config = function()
        require("user.noice").config()
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      disable = not lvim.builtin.noice.active,
    },
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
    }, {
      "simrat39/symbols-outline.nvim",
      config = function()
        require("user.symbols_outline").config()
      end,
      event = "BufReadPost",
      disable = lvim.builtin.tag_provider ~= "symbols-outline",
    }, {
      "tzachar/cmp-tabnine",
      run = "./install.sh",
      requires = "hrsh7th/nvim-cmp",
      config = function()
        local tabnine = require "cmp_tabnine.config"
        tabnine:setup {
          max_lines = 1000,
          max_num_results = 10,
          sort = true,
        }
      end,
      opt = true,
      event = "InsertEnter",
      disable = not lvim.builtin.tabnine.active,
    }, {
      "folke/twilight.nvim",
      config = function()
        require("user.twilight").config()
      end,
      event = "BufRead",
    }, {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
      end,
      event = "BufRead",
      disable = not lvim.builtin.lsp_lines,
    }, {
      "danymat/neogen",
      config = function()
        require("neogen").setup {
          enabled = true,
        }
      end,
      event = "InsertEnter",
      requires = "nvim-treesitter/nvim-treesitter",
    },
    {
      "zbirenbaum/copilot.lua",
      after = "nvim-cmp",
      requires = { "zbirenbaum/copilot-cmp" },
      config = function()
        local cmp_source = { name = "copilot", group_index = 2 }
        table.insert(lvim.builtin.cmp.sources, cmp_source)
        vim.defer_fn(function()
          require("copilot").setup()
        end, 100)
      end,
      disable = not lvim.builtin.sell_your_soul_to_devil.prada,
    }, {
      "sindrets/diffview.nvim",
      opt = true,
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      module = "diffview",
      keys = { "<leader>gd", "<leader>gh" },
      config = function()
        require("user.diffview").config()
      end,
      disable = not lvim.builtin.fancy_diff.active,
    }, {
      "nvim-telescope/telescope-live-grep-args.nvim",
    }, {
      "editorconfig/editorconfig-vim",
      event = "BufRead",
      disable = not lvim.builtin.editorconfig.active,
    },
  }
  -- não sei o poruqe, mas a função config do hop não funciona nem pelo satanás.
  require('dap-go').setup()
  require("user.hop").config()
  require("neogen").setup {
    enabled = true,
  }
end

return M
