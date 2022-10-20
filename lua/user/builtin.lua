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

M.codes = {
  no_matching_function = {
    message = " Can't find a matching function",
    "redundant-parameter",
    "ovl_no_viable_function_in_call",
  },
  different_requires = {
    message = " Buddy you've imported this before, with the same name",
    "different-requires",
  },
  empty_block = {
    message = " That shouldn't be empty here",
    "empty-block",
  },
  missing_symbol = {
    message = " Here should be a symbol",
    "miss-symbol",
  },
  expected_semi_colon = {
    message = " Remember the `;` or `,`",
    "expected_semi_declaration",
    "miss-sep-in-table",
    "invalid_token_after_toplevel_declarator",
  },
  redefinition = {
    message = " That variable was defined before",
    "redefinition",
    "redefined-local",
  },
  no_matching_variable = {
    message = " Can't find that variable",
    "undefined-global",
    "reportUndefinedVariable",
  },
  trailing_whitespace = {
    message = " Remove trailing whitespace",
    "trailing-whitespace",
    "trailing-space",
  },
  unused_variable = {
    message = " Don't define variables you don't use",
    "unused-local",
  },
  unused_function = {
    message = " Don't define functions you don't use",
    "unused-function",
  },
  useless_symbols = {
    message = " Remove that useless symbols",
    "unknown-symbol",
  },
  wrong_type = {
    message = " Try to use the correct types",
    "init_conversion_failed",
  },
  undeclared_variable = {
    message = " Have you delcared that variable somewhere?",
    "undeclared_var_use",
  },
  lowercase_global = {
    message = " Should that be a global? (if so make it uppercase)",
    "lowercase-global",
  },
}

M.show_documentation = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.fn.expand "%:t" == "Cargo.toml" then
    require("crates").show_popup()
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
  elseif filetype == "rust" then
    local found, rt = pcall(require, "rust-tools")
    if found then
      rt.hover_actions.hover_actions()
    else
      vim.lsp.buf.hover()
    end
  else
    vim.lsp.buf.hover()
  end
end

M.lsp_on_attach_callback = function(client, _)
  local wkstatus_ok, which_key = pcall(require, "which-key")
  if not wkstatus_ok then
    return
  end
  local mappings = {}

  local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  }
  -- local opts = { noremap = true, silent = true }
  if client.name == "clangd" then
    mappings["H"] = {
      "<Cmd>ClangdSwitchSourceHeader<CR>",
      "Swich Header/Source",
    }
  elseif client.name == "gopls" then
    mappings["H"] = {
      "<Cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go vet .;read',count=2,direction='float'})<CR>",
      "Go Vet",
    }
    if lvim.builtin.go_programming.active then
      mappings["li"] = { "<cmd>GoInstallDeps<cr>", "Install Dependencies" }
      mappings["lT"] = { "<cmd>GoMod tidy<cr>", "Tidy" }
      mappings["lt"] = { "<cmd>GoTestAdd<cr>", "Add Test" }
      mappings["tA"] = { "<cmd>GoTestsAll<cr>", "Add All Tests" }
      mappings["le"] = { "<cmd>GoTestsExp<cr>", "Add Exported Tests" }
      mappings["lg"] = { "<cmd>GoGenerate<cr>", "Generate" }
      mappings["lF"] = { "<cmd>GoGenerate %<cr>", "Generate File" }
      mappings["lc"] = { "<cmd>GoCmt<cr>", "Comment" }
      mappings["dT"] = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test" }
    end
  elseif client.name == "jdtls" then
    mappings["rf"] = {
      "<cmd>lua require('toggleterm.terminal').Terminal:new {cmd='mvn package;read', hidden =false}:toggle()<CR>",
      "Maven Package",
    }
    mappings["mf"] = {
      "<cmd>lua require('toggleterm.terminal').Terminal:new {cmd='mvn compile;read', hidden =false}:toggle()<CR>",
      "Maven Compile",
    }
  elseif client.name == "rust_analyzer" then
    mappings["H"] = {
      "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo clippy;read',count=2,direction='float'})<CR>",
      "Clippy",
    }
    if lvim.builtin.rust_programming.active then
      mappings["lA"] = { "<Cmd>RustHoverActions<CR>", "Hover Actions" }
      mappings["lm"] = { "<Cmd>RustExpandMacro<CR>", "Expand Macro" }
      mappings["lH"] = { "<Cmd>RustToggleInlayHints<CR>", "Toggle Inlay Hints" }
      mappings["le"] = { "<Cmd>RustRunnables<CR>", "Runnables" }
      mappings["lD"] = { "<cmd>RustDebuggables<Cr>", "Debuggables" }
      mappings["lP"] = { "<cmd>RustParentModule<Cr>", "Parent Module" }
      mappings["lv"] = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" }
      mappings["lR"] = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "Reload Workspace",
      }
      mappings["lc"] = { "<Cmd>RustOpenCargo<CR>", "Open Cargo" }
      mappings["lo"] = { "<Cmd>RustOpenExternalDocs<CR>", "Open External Docs" }
    end
  elseif client.name == "taplo" then
    if lvim.builtin.rust_programming.active then
      mappings["lt"] = { "<Cmd>lua require('crates').toggle()<CR>", "Toggle Crate" }
      mappings["lu"] = { "<Cmd>lua require('crates').update_crate()<CR>", "Update Crate" }
      mappings["lU"] = { "<Cmd>lua require('crates').upgrade_crate()<CR>", "Upgrade Crate" }
      mappings["lg"] = { "<Cmd>lua require('crates').update_all_crates()<CR>", "Update All" }
      mappings["lG"] = { "<Cmd>lua require('crates').upgrade_all_crates()<CR>", "Upgrade All" }
      mappings["lH"] = { "<Cmd>lua require('crates').open_homepage()<CR>", "Open HomePage" }
      mappings["lD"] = { "<Cmd>lua require('crates').open_documentation()<CR>", "Open Documentation" }
      mappings["lR"] = { "<Cmd>lua require('crates').open_repository()<CR>", "Open Repository" }
      mappings["lv"] = { "<Cmd>lua require('crates').show_versions_popup()<CR>", "Show Versions" }
      mappings["lF"] = { "<Cmd>lua require('crates').show_features_popup()<CR>", "Show Features" }
      mappings["lD"] = { "<Cmd>lua require('crates').show_dependencies_popup()<CR>", "Show Dependencies" }
    end
  elseif client.name == "tsserver" then
    mappings["lA"] = { "<Cmd>TSLspImportAll<CR>", "Import All" }
    mappings["lR"] = { "<Cmd>TSLspRenameFile<CR>", "Rename File" }
    mappings["lO"] = { "<Cmd>TSLspOrganize<CR>", "Organize Imports" }
    mappings["li"] = { "<cmd>TypescriptAddMissingImports<Cr>", "AddMissingImports" }
    mappings["lo"] = { "<cmd>TypescriptOrganizeImports<cr>", "OrganizeImports" }
    mappings["lu"] = { "<cmd>TypescriptRemoveUnused<Cr>", "RemoveUnused" }
    mappings["lF"] = { "<cmd>TypescriptFixAll<Cr>", "FixAll" }
    mappings["lg"] = { "<cmd>TypescriptGoToSourceDefinition<Cr>", "GoToSourceDefinition" }
  elseif client.name == "pyright" then
    if lvim.builtin.python_programming.active then
      mappings["df"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" }
      mappings["dm"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" }
      mappings["dS"] = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" }
      mappings["P"] = {
        name = "Python",
        i = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Pick Env" },
        d = { "<cmd>lua require('swenv.api').get_current_venv()<cr>", "Show Env" },
      }
    end
  elseif client.name == "jsonls" then
    if lvim.builtin.web_programming.active then
      mappings["ls"] = { "<cmd>lua require('package-info').show()<cr>", "Show pkg info" }
      mappings["lc"] = { "<cmd>lua require('package-info').hide()<cr>", "Hide pkg info" }
      mappings["lu"] = { "<cmd>lua require('package-info').update()<cr>", "Update dependency" }
      mappings["ld"] = { "<cmd>lua require('package-info').delete()<cr>", "Delete dependency" }
      mappings["li"] = { "<cmd>lua require('package-info').install()<cr>", "Install dependency" }
      mappings["lC"] = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
    end
  end
  which_key.register(mappings, opts)
end


return M
