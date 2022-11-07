-- general

lvim.log.level = "warn"
lvim.leader = "space"
lvim.format_on_save = true
lvim.colorscheme = "gruvbox-material"
lvim.builtin.time_based_themes = true -- set false to use your own configured theme
lvim.transparent_window = false -- enable/disable transparency
lvim.debug = false
vim.lsp.set_log_level "error"
lvim.log.level = "warn"

require("user.neovim").config()
-- lvim.lsp.diagnostics.virtual_text = false -- remove this line if you want to see inline errors

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false


lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.code_lens_refresh = false
lvim.builtin.sell_your_soul_to_devil = { active = false, prada = false } -- if you want microsoft to abuse your soul
lvim.builtin.tabnine = { active = true } -- change to false if you don't like tabnine
lvim.builtin.fancy_wild_menu = { active = true } -- enable/disable cmp-cmdline
lvim.builtin.fancy_diff = { active = false }

lvim.builtin.indentlines = {
  active = true
}

lvim.builtin.noice = { active = false }
require("user.builtin").config()
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "custom"
lvim.builtin.noice = { active = false }
lvim.builtin.tag_provider = "symbols-outline" -- change this to use different tag providers ( symbols-outline or vista )
lvim.builtin.lsp_lines = false -- enable/disable lsp_lines to display lsp virtual text below instead of behind

if lvim.builtin.lsp_lines then
  lvim.lsp.diagnostics.virtual_text = false
end

lvim.builtin.cheat = { active = false }
lvim.builtin.legendary = { active = false }
lvim.builtin.file_browser = { active = false } -- enable/disable telescope file browser
lvim.builtin.editorconfig = { active = true } -- enable/disable editorconfig
lvim.builtin.test_runner = { active = false, runner = "ultest" } -- change this to enable/disable ultest or neotest

-- some coment
require("user.plugins").config()
require("user.keybindings").config()
lvim.keys.normal_mode["m"] = {
  "<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>",
  { noremap = true, silent = true, nowait = true },
}
