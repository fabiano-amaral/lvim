local M = {}

M.config = function()
  local kind = require("user.lsp_kind")


  -- if lvim.builtin.bufferline.active then
  --   require("user.bufferline").config()
  -- end

  -- CMP
  lvim.builtin.cmp.sources = {
    { name = "nvim_lsp" },
    { name = "cmp_tabnine", max_item_count = 3 },
    { name = "buffer", max_item_count = 5, keyword_length = 5 },
    { name = "path", max_item_count = 5 },
    { name = "luasnip", max_item_count = 3 },
    { name = "nvim_lua" },
    { name = "calc" },
    { name = "emoji" },
    { name = "treesitter" },
    { name = "latex_symbols" },
    { name = "crates" },
    { name = "orgmode" },
  }
  lvim.builtin.cmp.experimental = {
    ghost_text = false,
    native_menu = false,
    custom_menu = true,
  }
  local cmp_sources = {
    ["vim-dadbod-completion"] = "(DadBod)",
    buffer = "(Buffer)",
    cmp_tabnine = "(TabNine)",
    crates = "(Crates)",
    latex_symbols = "(LaTeX)",
    nvim_lua = "(NvLua)",
  }
  lvim.builtin.cmp.formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      if entry.source.name == "cmdline" then
        vim_item.kind = "⌘"
        vim_item.menu = ""
        return vim_item
      end
      vim_item.menu = cmp_sources[entry.source.name] or vim_item.kind
      vim_item.kind = kind.cmp_kind[vim_item.kind] or vim_item.kind
      return vim_item
    end,
  }
  local cmp_ok, cmp = pcall(require, "cmp")
  if not cmp_ok or cmp == nil then
    cmp = {
      mapping = function(...) end,
      setup = { filetype = function(...) end, cmdline = function(...) end },
      config = { sources = function(...) end },
    }
  end
  if lvim.builtin.fancy_wild_menu.active then
    local cmdline_opts = {
      mapping = cmp.mapping.preset.cmdline {},
      sources = {
        { name = "cmdline" },
        { name = "path" },
      },
    }
    if lvim.builtin.noice.active then
      cmdline_opts.window = {
        completion = {
          border = {
            { "╭", "CmpBorder" },
            { "─", "CmpBorder" },
            { "╮", "CmpBorder" },
            { "│", "CmpBorder" },
            { "╯", "CmpBorder" },
            { "─", "CmpBorder" },
            { "╰", "CmpBorder" },
            { "│", "CmpBorder" },
          },
          winhighlight = "Search:None",
        },
      }
    end
    cmp.setup.cmdline(":", cmdline_opts)
  end
  cmp.setup.filetype("toml", {
    sources = cmp.config.sources({
      { name = "nvim_lsp", max_item_count = 8 },
      { name = "crates" },
      { name = "luasnip", max_item_count = 5 },
    }, {
      { name = "buffer", max_item_count = 5, keyword_length = 5 },
    }),
  })
  cmp.setup.filetype("tex", {
    sources = cmp.config.sources({
      { name = "latex_symbols", max_item_count = 3, keyword_length = 3 },
      { name = "nvim_lsp", max_item_count = 8 },
      { name = "luasnip", max_item_count = 5 },
    }, {
      { name = "buffer", max_item_count = 5, keyword_length = 5 },
    }),
  })
  if lvim.builtin.sell_your_soul_to_devil.active then
    local function t(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    lvim.builtin.cmp.mapping["<c-h>"] = cmp.mapping(function()
      vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t "<Tab>"), "n", true)
    end)
    lvim.keys.insert_mode["<M-]>"] = { "<Plug>(copilot-next)", { silent = true } }
    lvim.keys.insert_mode["<M-[>"] = { "<Plug>(copilot-previous)", { silent = true } }
    lvim.keys.insert_mode["<M-\\>"] = { "<Cmd>vertical Copilot panel<CR>", { silent = true } }
    lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "c" })
    lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "c" })
  end

  -- dashboard
  lvim.builtin.alpha.mode = "custom"
  local alpha_opts = require("user.dashboard").config()
  lvim.builtin.alpha["custom"] = { config = alpha_opts }

  --git signs
  lvim.builtin.gitsigns.opts._threaded_diff = true
  lvim.builtin.gitsigns.opts._extmark_signs = true
  lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time> · <summary>"

  -- IndentBlankline
  -- =========================================
  require("user.indent_blankline").config()

  -- NvimTree
  -- =========================================
  lvim.builtin.nvimtree.setup.diagnostics = {
    enable = true,
    icons = {
      hint = kind.icons.hint,
      info = kind.icons.info,
      warning = kind.icons.warn,
      error = kind.icons.error,
    },
  }

  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
  lvim.builtin.nvimtree.on_config_done = function(_)
    lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", " Explorer" }
  end

  -- -- Toggleterm
  -- -- =========================================
  lvim.builtin.terminal.active = true
  lvim.builtin.terminal.execs = {
    direction = "horizontal",
  }
  lvim.builtin.terminal.autochdir = true
  -- lvim.builtin.terminal.open_mapping = nil
  lvim.builtin.terminal.size = vim.o.columns * 0.4
  lvim.builtin.terminal.on_config_done = function()
    M.create_terminal(2, "<c-\\>", 20, "float")
    M.create_terminal(3, "<A-0>", vim.o.columns * 0.4, "vertical")
  end

  -- Treesitter
  -- =========================================
  lvim.builtin.treesitter.context_commentstring.enable = true
  lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "yaml",
    "hcl",
    "comment",
    "go",
    "gomod",
    "vim",
  }
  lvim.builtin.treesitter.highlight.disable = { "org" }
  lvim.builtin.treesitter.highlight.aditional_vim_regex_highlighting = { "org" }
  lvim.builtin.treesitter.ignore_install = { "haskell", "norg" }
  lvim.builtin.treesitter.incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      scope_incremental = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  }
  lvim.builtin.treesitter.indent = { enable = true, disable = { "python" } } -- treesitter is buggy :(
  lvim.builtin.treesitter.matchup.enable = true
  lvim.builtin.treesitter.textsubjects = {
    enable = true
  }
  lvim.builtin.treesitter.playground.enable = true
  lvim.builtin.treesitter.query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  }
  lvim.builtin.treesitter.textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aA"] = "@attribute.outer",
        ["iA"] = "@attribute.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
        ["at"] = "@class.outer",
        ["it"] = "@class.inner",
        ["a/"] = "@comment.outer",
        ["i/"] = "@comment.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["aF"] = "@frame.outer",
        ["iF"] = "@frame.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["is"] = "@scopename.inner",
        ["as"] = "@statement.outer",
        ["av"] = "@variable.outer",
        ["iv"] = "@variable.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader><M-a>"] = "@parameter.inner",
        ["<leader><M-f>"] = "@function.outer",
        ["<leader><M-e>"] = "@element",
      },
      swap_previous = {
        ["<leader><M-A>"] = "@parameter.inner",
        ["<leader><M-F>"] = "@function.outer",
        ["<leader><M-E>"] = "@element",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]p"] = "@parameter.inner",
        ["]f"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[p"] = "@parameter.inner",
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  }

  -- WhichKey
  -- =========================================
  lvim.builtin.which_key.setup.window.winblend = 10
  lvim.builtin.which_key.setup.window.border = "none"
  lvim.builtin.which_key.setup.plugins.presets.z = true
  lvim.builtin.which_key.setup.plugins.presets.g = true
  lvim.builtin.which_key.setup.plugins.presets.windows = true
  lvim.builtin.which_key.setup.plugins.presets.nav = true
  lvim.builtin.which_key.setup.plugins.marks = true
  lvim.builtin.which_key.setup.plugins.registers = true
  lvim.builtin.which_key.setup.icons = {
    breadcrumb = "/", -- symbol used in the command line area that shows your active key combo
    separator = "·", -- symbol used between a key and it's label
    group = "", -- symbol prepended to a group
  }
  lvim.builtin.which_key.setup.ignore_missing = true

  -- Telescope
  -- =========================================
  -- lvim.builtin.telescope.defaults.path_display = { "smart", "absolute", "truncate" }
  lvim.builtin.telescope.defaults.dynamic_preview_title = true
  lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
  lvim.builtin.telescope.defaults.prompt_prefix = "  "
  lvim.builtin.telescope.defaults.borderchars = {
    prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    results = { "─", "▐", "─", "│", "╭", "▐", "▐", "╰" },
    -- results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    preview = { " ", "│", " ", "▌", "▌", "╮", "╯", "▌" },
  }
  lvim.builtin.telescope.defaults.selection_caret = "  "
  lvim.builtin.telescope.defaults.cache_picker = { num_pickers = 3 }
  lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
  lvim.builtin.telescope.defaults.file_ignore_patterns = {
    "vendor/*",
    "%.lock",
    "__pycache__/*",
    "%.sqlite3",
    "%.ipynb",
    "node_modules/*",
    "%.jpg",
    "%.jpeg",
    "%.png",
    "%.svg",
    "%.otf",
    "%.ttf",
    ".git/",
    "%.webp",
    ".dart_tool/",
    ".github/",
    ".gradle/",
    ".idea/",
    ".settings/",
    ".vscode/",
    "__pycache__/",
    "build/",
    "env/",
    "gradle/",
    "node_modules/",
    "target/",
    "%.pdb",
    "%.dll",
    "%.class",
    "%.exe",
    "%.cache",
    "%.ico",
    "%.pdf",
    "%.dylib",
    "%.jar",
    "%.docx",
    "%.met",
    "smalljre_*/*",
    ".vale/",
    "%.burp",
    "%.mp4",
    "%.mkv",
    "%.rar",
    "%.zip",
    "%.7z",
    "%.tar",
    "%.bz2",
    "%.epub",
    "%.flac",
    "%.tar.gz",
  }
  local user_telescope = require "user.telescope"
  lvim.builtin.telescope.defaults.layout_config = user_telescope.layout_config()
  local actions = require "telescope.actions"
  lvim.builtin.telescope.defaults.mappings = {
    i = {
      ["<c-c>"] = require("telescope.actions").close,
      ["<c-y>"] = require("telescope.actions").which_key,
      ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
      ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
      ["<cr>"] = user_telescope.multi_selection_open,
      ["<c-v>"] = user_telescope.multi_selection_open_vsplit,
      ["<c-s>"] = user_telescope.multi_selection_open_split,
      ["<c-t>"] = user_telescope.multi_selection_open_tab,
      ["<c-j>"] = actions.move_selection_next,
      ["<c-k>"] = actions.move_selection_previous,
      ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    },
    n = {
      ["<esc>"] = actions.close,
      ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
      ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
      ["<cr>"] = user_telescope.multi_selection_open,
      ["<c-v>"] = user_telescope.multi_selection_open_vsplit,
      ["<c-s>"] = user_telescope.multi_selection_open_split,
      ["<c-t>"] = user_telescope.multi_selection_open_tab,
      ["<c-j>"] = actions.move_selection_next,
      ["<c-k>"] = actions.move_selection_previous,
      ["<c-n>"] = actions.cycle_history_next,
      ["<c-p>"] = actions.cycle_history_prev,
      ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      ["dd"] = require("telescope.actions").delete_buffer,
    },
  }
  local telescope_actions = require "telescope.actions.set"
  lvim.builtin.telescope.pickers.git_files = {
    hidden = true,
    show_untracked = true,
    layout_strategy = "horizontal",
  }
  lvim.builtin.telescope.pickers.live_grep = {
    only_sort_text = true,
    layout_strategy = "horizontal",
  }
  lvim.builtin.telescope.pickers.find_files = {
    layout_strategy = "horizontal",
    attach_mappings = function(_)
      telescope_actions.select:enhance {
        post = function()
          vim.cmd ":normal! zx"
        end,
      }
      return true
    end,
    find_command = { "fd", "--type=file", "--hidden" },
  }

  -- lvim.builtin.telescope.on_config_done = function(telescope)
  --   telescope.load_extension "file_create"
  --   if lvim.builtin.file_browser.active then
  --     telescope.load_extension "file_browser"
  --   end
  -- end

  local default_exe_handler = vim.lsp.handlers["workspace/executeCommand"]
  vim.lsp.handlers["workspace/executeCommand"] = function(err, result, ctx, config)
    -- supress NULL_LS error msg
    if err and vim.startswith(err.message, "NULL_LS") then
      return
    end
    return default_exe_handler(err, result, ctx, config)
  end
  if not lvim.use_icons and lvim.builtin.custom_web_devicons then
    require("user.dev_icons").use_my_icons()
  end

  lvim.builtin.terminal.execs = {
    { "lazygit", "<leader>gg", "LazyGit", "horizontal" },
  }
end

--- Create a new toggleterm
---@param num number the terminal number must be > 1
---@param keymap string the keymap to toggle the terminal
---@param size number the size of the terminal
---@param direction string can be 'float','vertical','horizontal'
M.create_terminal = function(num, keymap, size, direction)
  local terms = require "toggleterm.terminal"
  local ui = require "toggleterm.ui"
  local dir = vim.loop.cwd()
  vim.keymap.set({ "n", "t" }, keymap, function()
    local term = terms.get_or_create_term(num, dir, direction)
    ui.update_origin_window(term.window)
    term:toggle(size, direction)
  end, { noremap = true, silent = true })
end

return M
