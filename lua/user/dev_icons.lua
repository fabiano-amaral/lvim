local M = {}

M.set_icon = function()
  require("nvim-web-devicons").set_icon {
    toml = {
      icon = "📦",
      color = "#8FAA54",
      name = "Toml",
    },
    rs = {
      icon = "🦀",
      color = "#d28445",
      name = "Rust",
    },
  }
end

M.use_my_icons = function()
  for _, sign in ipairs(lvim.lsp.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end
  if lvim.builtin.tree_provider == "nvimtree" then
    lvim.builtin.nvimtree.setup.diagnostics.enable = true
    lvim.builtin.nvimtree.setup.renderer.icons.webdev_colors = true
    lvim.builtin.nvimtree.setup.renderer.icons.show = {
      git = true,
      folder = true,
      file = true,
      folder_arrow = true,
    }
  end
  if lvim.builtin.bufferline.active then
    lvim.builtin.bufferline.options.show_buffer_icons = true
    lvim.builtin.bufferline.options.show_buffer_close_icons = true
  end
end

M.define_dap_signs = function()
  vim.fn.sign_define("DapBreakpoint", lvim.builtin.dap.breakpoint)
  vim.fn.sign_define("DapStopped", lvim.builtin.dap.stopped)
  vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
  )
  vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
  )
  vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
  )
end

return M

