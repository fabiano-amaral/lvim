local M = {}

M.set_wezterm_keybindings = function()
  lvim.keys.insert_mode["å"] = lvim.keys.insert_mode["<A-a>"]
  lvim.keys.insert_mode["ß"] = lvim.keys.insert_mode["<A-s>"]
  lvim.keys.insert_mode["´"] = lvim.keys.insert_mode["<A-e>"]
  lvim.keys.insert_mode["∆"] = lvim.keys.insert_mode["<A-j>"]
  lvim.keys.insert_mode["˚"] = lvim.keys.insert_mode["<A-k>"]
  lvim.keys.normal_mode["å"] = lvim.keys.normal_mode["<A-a>"]
  lvim.keys.normal_mode["≈"] = lvim.keys.normal_mode["<A-x>"]
  lvim.keys.visual_mode["å"] = lvim.keys.visual_mode["<A-a>"]
  lvim.keys.visual_mode["≈"] = lvim.keys.visual_mode["<A-x>"]
end

M.set_hop_keymaps = function()
  local opts = { noremap = true, silent = true }

  -- buffer swap
  vim.api.nvim_set_keymap("n", "<s-h>", ":BufferLineCyclePrev<cr>", opts)
  vim.api.nvim_set_keymap("n", "<s-l>", ":BufferLineCycleNext<cr>", opts)

  vim.api.nvim_set_keymap("n", "<s-tab>", ":BufferLineCyclePrev<cr>", opts)
  vim.api.nvim_set_keymap("n", "<tab>", ":BufferLineCycleNext<cr>", opts)

  vim.api.nvim_set_keymap("n", "s", ":HopChar2MW<cr>", opts)
  vim.api.nvim_set_keymap("n", "S", ":HopWordMW<cr>", opts)
  vim.api.nvim_set_keymap('', 'w',
    "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>"
    , {})
  vim.api.nvim_set_keymap('', 'b',
    "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>"
    , {})
  vim.api.nvim_set_keymap(
    "n",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "n",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
  )
end

M.set_task_runner_keymaps = function()
  if lvim.builtin.task_runner == "async_tasks" then
    lvim.builtin.which_key.mappings["m"] = {
      name = " Make",
      f = { "<cmd>AsyncTask file-build<cr>", "File" },
      p = { "<cmd>AsyncTask project-build<cr>", "Project" },
      e = { "<cmd>AsyncTaskEdit<cr>", "Edit" },
      l = { "<cmd>AsyncTaskList<cr>", "List" },
    }
    lvim.builtin.which_key.mappings["r"] = {
      name = " Run",
      f = { "<cmd>AsyncTask file-run<cr>", "File" },
      p = { "<cmd>AsyncTask project-run<cr>", "Project" },
    }
  elseif lvim.builtin.task_runner == "overseer" then
    lvim.builtin.which_key.mappings["m"] = {
      name = " Tasks",
      l = { "<cmd>OverseerLoadBundle<CR>", "Load Bundle" },
      s = { "<cmd>OverseerSaveBundle<CR>", "Save Bundle" },
      n = { "<cmd>OverseerBuild<CR>", "New Task" },
      q = { "<cmd>OverseerQuickAction<CR>", "Quick Action" },
      f = { "<cmd>OverseerTaskAction<CR>", "Task Action" },
      t = { "<cmd>OverseerToggle<cr>", "Toggle Output" },
    }
    lvim.builtin.which_key.mappings["r"] = {
      name = " Run",
      f = { "<cmd>OverseerRun<cr>", "Run" },
      p = { "<cmd>OverseerRunCmd<cr>", "Run with Cmd" },
      t = { "<cmd>OverseerToggle<cr>", "Toggle" },
    }
  else
    lvim.builtin.which_key.mappings["m"] = "Make"
    lvim.builtin.which_key.mappings["r"] = "Run"
  end
end

M.config = function()
  lvim.keys.normal_mode["<CR>"] = {
    "<cmd>lua require('user.neovim').maximize_current_split()<CR>",
    { noremap = true, silent = true, nowait = true },
  }
  lvim.keys.insert_mode["<A-a>"] = "<ESC>ggVG<CR>"

  if lvim.builtin.tag_provider == "symbols-outline" then
    lvim.builtin.which_key.mappings["o"] = { "<cmd>SymbolsOutline<cr>", " Symbol Outline" }
  elseif lvim.builtin.tag_provider == "vista" then
    lvim.builtin.which_key.mappings["o"] = { "<cmd>Vista!!<cr>", "Vista" }
  end

  local user = vim.env.USER
  if user and user == "abz" then
    M.set_wezterm_keybindings()
  end

  -- WhichKey keybindings
  -- =========================================
  M.set_task_runner_keymaps()
  local status_ok_comment, cmt = pcall(require, "Comment.api")
  if status_ok_comment and cmt["toggle"] ~= nil then
    lvim.builtin.which_key.mappings["/"] = {
      "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
      " Comment",
    }
  else
    lvim.builtin.which_key.mappings["/"] = { "<Plug>(comment_toggle_linewise_current)", " Comment" }
  end
  lvim.builtin.which_key.mappings[";"] = { "<cmd>Alpha<CR>", "舘Dashboard" }
  if lvim.builtin.dap.active then
    lvim.builtin.which_key.mappings["de"] = { "<cmd>lua require('dapui').eval()<cr>", "Eval" }
    lvim.builtin.which_key.mappings["dU"] = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" }
  end
  if lvim.builtin.fancy_diff.active then
    lvim.builtin.which_key.mappings["gd"] = { "<cmd>DiffviewOpen<cr>", "diffview: diff HEAD" }
    lvim.builtin.which_key.mappings["gh"] = { "<cmd>DiffviewFileHistory<cr>", "diffview: filehistory" }
  else
    lvim.builtin.which_key.mappings["gh"] = { "<cmd>Telescope git_bcommits<cr>", "file history" }
  end
  if lvim.builtin.cheat.active then
    lvim.builtin.which_key.mappings["?"] = { "<cmd>Cheat<CR>", " Cheat.sh" }
  end
  if lvim.builtin.lsp_lines then
    M.set_lsp_lines_keymap()
  end
  if lvim.builtin.tree_provider == "neo-tree" then
    lvim.builtin.which_key.mappings["e"] = { ":NeoTreeRevealToggle<CR>", " Explorer" }
  end
  lvim.builtin.which_key.mappings["F"] = {
    name = " Find",
    b = { "<cmd>lua require('user.telescope').builtin()<cr>", "Builtin" },
    f = { "<cmd>lua require('user.telescope').curbuf()<cr>", "Current Buffer" },
    g = { "<cmd>lua require('user.telescope').git_files()<cr>", "Git Files" },
    i = { "<cmd>lua require('user.telescope').installed_plugins()<cr>", "Installed Plugins" },
    l = {
      "<cmd>lua require('telescope.builtin').resume()<cr>",
      "Last Search",
    },
    p = { "<cmd>lua require('user.telescope').project_search()<cr>", "Project" },
    s = { "<cmd>lua require('user.telescope').git_status()<cr>", "Git Status" },
    z = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "Certain Filetype" },
  }
  if lvim.builtin.legendary.active then
    lvim.builtin.which_key.mappings["C"] =
    { "<cmd>lua require('legendary').find('commands')<cr>", " Command Palette" }
    lvim.keys.normal_mode["<c-P>"] = "<cmd>lua require('legendary').find()<cr>"
  end

  if lvim.builtin.file_browser.active then
    lvim.builtin.which_key.mappings["se"] = { "<cmd>Telescope file_browser<cr>", "File Browser" }
  end
  lvim.builtin.which_key.mappings["H"] = " Help"
  lvim.builtin.which_key.mappings["h"] = { "<cmd>nohlsearch<CR>", " No Highlight" }
  lvim.builtin.which_key.mappings.g.name = " Git"
  lvim.builtin.which_key.mappings.l.name = " LSP"
  lvim.builtin.which_key.mappings["f"] = {
    require("user.telescope").find_project_files,
    " Find File",
  }
  local ok, _ = pcall(require, "vim.diagnostic")
  if ok then
    lvim.builtin.which_key.mappings["l"]["j"] = {
      "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
      "Next Diagnostic",
    }
    lvim.builtin.which_key.mappings["l"]["k"] = {
      "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
      "Prev Diagnostic",
    }
  end

  if status_ok_comment and cmt["toggle"] ~= nil then
    lvim.builtin.which_key.vmappings["/"] =
    { "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Comment" }
  end

  lvim.builtin.which_key.vmappings["l"] = {
    name = "+Lsp",
    r = { "<ESC><CMD>lua vim.lsp.buf.rename()<CR>", "Rename" },
  }
  lvim.builtin.which_key.mappings["lp"] = {
    name = "Peek",
    d = { "<cmd>lua require('user.peek').Peek('definition')<cr>", "Definition" },
    t = { "<cmd>lua require('user.peek').Peek('typeDefinition')<cr>", "Type Definition" },
    i = { "<cmd>lua require('user.peek').Peek('implementation')<cr>", "Implementation" },
  }
  lvim.builtin.which_key.mappings["lh"] = {
    "<cmd>hi LspReferenceRead cterm=bold ctermbg=red guibg=#24283b<cr><cmd>hi LspReferenceText cterm=bold ctermbg=red guibg=#24283b<cr><cmd>hi LspReferenceWrite cterm=bold ctermbg=red guibg=#24283b<cr>",
    "Clear HL",
  }

  lvim.builtin.which_key.mappings["n"] = {
    name = " Neogen",
    c = { "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", "Class Documentation" },
    f = { "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", "Function Documentation" },
    t = { "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", "Type Documentation" },
    F = { "<cmd>lua require('neogen').generate({ type = 'file'})<CR>", "File Documentation" },
  }

  lvim.builtin.which_key.mappings["N"] = { "<cmd>Telescope file_create<CR>", " Create new file" }

  if lvim.builtin.tag_provider == "symbols-outline" then
    lvim.builtin.which_key.mappings["o"] = { "<cmd>SymbolsOutline<cr>", " Symbol Outline" }
  elseif lvim.builtin.tag_provider == "vista" then
    lvim.builtin.which_key.mappings["o"] = { "<cmd>Vista!!<cr>", "Vista" }
  end

  lvim.builtin.which_key.mappings.L.name = " LunarVim"
  lvim.builtin.which_key.mappings.p.name = " Packer"
  lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", " Projects" }
  lvim.builtin.which_key.mappings.s.name = " Search"
  lvim.builtin.which_key.mappings["ss"] = {
    "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
    "String",
  }

  lvim.builtin.which_key.mappings["T"] = {
    name = "飯Trouble",
    d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnosticss" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    t = { "<cmd>TodoLocList <cr>", "Todo" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnosticss" },
  }

  lvim.builtin.which_key.mappings["z"] = { "<cmd>ZenMode<cr>", " Zen" }
  lvim.builtin.which_key.mappings["w"] = { "<cmd>w!<CR>", " Save" }
  lvim.builtin.which_key.vmappings["g"] = {
    name = " Git",
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    g = { "<cmd>:w<cr>", "LazyGit" }
  }
end

return M
