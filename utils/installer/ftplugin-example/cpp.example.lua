local dap = require('dap')

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    -- -- Enter the program to be executed through the console
    -- program = function()
    --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
    -- end,
    -- No input required, directly specify the program to be executed
    program = vim.fn.getcwd() .. '/build/project',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
      end
      return variables
    end,
    -- echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    runInTerminal = false,
  },
}

require("lvim.lsp.manager").setup("clangd")
