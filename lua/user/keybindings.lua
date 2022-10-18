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
  vim.api.nvim_set_keymap("n", "s", ":HopChar2MW<cr>", opts)
  vim.api.nvim_set_keymap("n", "S", ":HopWordMW<cr>", opts)
  vim.api.nvim_set_keymap('', 'm',
    "<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>"
    , {})
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

M.config = function()
  lvim.keys.normal_mode["<CR>"] = {
    "<cmd>lua require('user.neovim').maximize_current_split()<CR>",
    { noremap = true, silent = true, nowait = true },
  }
  lvim.keys.insert_mode["<A-a>"] = "<ESC>ggVG<CR>"
  lvim.builtin.which_key.mappings["o"] = { "<cmd>SymbolsOutline<cr>", " Symbol Outline" }
  local user = vim.env.USER
  if user and user == "abz" then
    M.set_wezterm_keybindings()
  end
end

return M
