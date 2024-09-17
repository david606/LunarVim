local dap = require "dap"

dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = {lvim.debug_environments_home ..'/vscode-go/dist/debugAdapter.js'};
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Debug';
    request = 'launch';
    showLog = false;
    program = "${file}";
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  },
}

require("lvim.lsp.manager").setup("gopls")
