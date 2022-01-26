local M = {}

M.config = function()
  lvim.builtin.dap = {
    active = true,
    on_config_done = nil,
    breakpoint = {
      text = "",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    breakpoint_rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }
end

-- dap-ui setup mehtod
local dap_ui_setup = function ()

  require("dapui").setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
      },
      sidebar = {
        -- You can change the order of elements in the sidebar
        elements = {
          -- Provide as ID strings or tables with "id" and "size" keys
          -- Size can be float or integer > 1
          { id = "scopes", size = 0.40, },
          { id = "watches", size = 0.35 },
          { id = "breakpoints", size = 0.25 },
        },
        size = 40,
        -- Position can be "left", "right", "top", "bottom"
        position = "left",
      },
      tray = {
        elements = { "stacks" },
        size = 10,
        -- Position can be "left", "right", "top", "bottom"
        position = "bottom",
      },
      floating = {
        -- These can be integers or a float between 0 and 1.
        max_height = nil,
        -- Floats will be treated as percentage of your screen.
        max_width = nil,
        -- Border style. Can be "single", "double" or "rounded"
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
    })
end

-- nvim-dap-virtual-text setup method
local dap_vir_test_setup = function ()

    require("nvim-dap-virtual-text").setup {
        enabled = true,                     -- enable this plugin (the default)
        enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle,
                                            -- (DapVirtualTextForceRefresh for refreshing when debug adapter
                                            -- did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged,
                                            -- else always NvimDapVirtualText
        highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables
                                            -- (if highlight_changed_variables)
        show_stop_reason = true,            -- show stop reason when stopped for exceptions
        commented = false,                  -- prefix virtual text with comment string
                                            -- experimental features:
        virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = true,                 -- show virtual text for all stack frames not only current.
                                            -- Only works for debugpy on my machine.
        virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil             -- position the virtual text at a fixed window column
                                            -- (starting from the first text column) ,
                                            -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }
end


M.setup = function()

  local dap = require "dap"
  dap_ui_setup()
  dap_vir_test_setup()

  vim.fn.sign_define("DapBreakpoint", lvim.builtin.dap.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", lvim.builtin.dap.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", lvim.builtin.dap.stopped)

  dap.defaults.fallback.terminal_win_cmd = "tabnew"

  lvim.builtin.which_key.mappings["d"] = {
    name = "Debug",
    -- dap mappings
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint" },
    -- b = { "<cmd>lua require'dap'.step_back()<CR>", "Step Back" },
    c = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
    C = { "<cmd>lua require'dap'.run_to_cursor()<CR>", "Run To Cursor" },
    -- d = { "<cmd>lua require'dap'.disconnect()<CR>", "Disconnect" },
    -- g = { "<cmd>lua require'dap'.session()<CR>", "Get Session" },
    i = { "<cmd>lua require'dap'.step_into()<CR>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<CR>", "Step Over" },
    u = { "<cmd>lua require'dap'.step_out()<CR>", "Step Out" },
    -- p = { "<cmd>lua require'dap'.pause.toggle()<CR>", "Pause" },
    -- r = { "<cmd>lua require'dap'.repl.toggle()<CR>", "Toggle Repl" },
    s = { "<cmd>lua require'dap'.continue()<CR>", "Start" },
    q = { "<cmd>lua require'dap'.close()<CR>", "Quit" },

    -- dap-ui mappings
    v = { "<cmd>lua require'dapui'.toggle()<CR>", "OpenUI" },
    e = { "<cmd>lua require'dapui'.eval()<CR>", "Eval" },
    k = { "<cmd>lua require'dapui'.float_element('stacks')<CR>", "stacks"},
    p = { "<cmd>lua require'dapui'.float_element('scopes')<CR>", "scopes"},
    r = { "<cmd>lua require'dapui'.float_element('repl')<CR>", "repl"},

    -- dap-virtual-text mappings
    -- e = { "<cmd>lua require'nvim-dap-virtual-text'.toggle()<CR>", "VirtualText"},

    -- telescope-dap mappings
    T = {
      name = "Telescope",
      c = {"<cmd>lua require'telescope'.extensions.dap.commands{}<CR>","Commands"},
      n = {"<cmd>lua require'telescope'.extensions.dap.configurations{}<CR>","Configurations"},
      v = {"<cmd>lua require'telescope'.extensions.dap.variables{}<CR>","Variables"},
      f = {"<cmd>lua require'telescope'.extensions.dap.frames{}<CR>","Frames"},
    },
    f = {"<cmd>lua require'telescope'.extensions.dap.frames{}<CR>","Frames"},
  }

  if lvim.builtin.dap.on_config_done then
    lvim.builtin.dap.on_config_done(dap)
  end
end

return M
