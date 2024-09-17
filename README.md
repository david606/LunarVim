### LunarVim

#### Install

**references** [official installing](https://www.lunarvim.org/01-installing.html#prerequisites)

```sh
sudo pacman -S yarn npm cargo fzf fd ripgrep
```

```sh
bash <(curl -s https://raw.githubusercontent.com/david606/LunarVim/support-popular-language/utils/installer/install.sh)
```

```sh
lvim +LvimUpdate +q
```

```shell
ln -sf $HOME/.local/bin/lvim $HOME/.local/bin/vim
ln -sf $HOME/.local/bin/lvim $HOME/.local/bin/vi
```

**update git url**

```sh
cd $HOME/.local/share/lunarvim/lvim
```

```shell
git remote set-url origin git@github.com:david606/LunarVim.git
```

>安装后 git 的远程地址是 https://github.com .. , 提交需要输密码比较麻烦，需要替换成 git@github ..

#### Install debug environments

构建测试环境，并拷贝语言模板到 `ftplugin`

```sh
bash <(curl -s https://raw.githubusercontent.com/david606/LunarVim/support-popular-language/utils/installer/install-lunarvim-debug-support.sh)
```

拷贝语言模板到 `ftplugin` (从上面单独提取的方法)

```sh
python <(curl -s https://raw.githubusercontent.com/david606/LunarVim/support-popular-language/utils/installer/copy-ftplugin.py)
```

#### Uninstall

```sh
bash <(curl -s https://raw.githubusercontent.com/david606/LunarVim/support-popular-language/utils/installer/uninstall.sh)
```

### LSP Server

```lua
:LspInstall clangd jdtls gopls  pyright cmake
```

或者

```sh
git clone https://github.com/clangd/clangd.git ~/.local/share/nvim/lsp_servers/clangd
```

```lua

```



### General Settings

**config** `~/.config/lvim/config`

```lua
local home = vim.loop.os_homedir()

lvim.debug_environments_home =home.."/.config/lunarvim-debug-support"

-- Lunarvim's home directory, including subdirectories such as lvim and site
lvim.lunarvim_home = home .. "/.local/share/lunarvim"

-- Lunarvim's core directory, some of the key core programs are in this directory
lvim.lvim_home = lvim.lunarvim_home .. "/lvim"

-- Lunarvim's extension directory, some referenced plugins, and ftpluin are in this directory
lvim.site_home = lvim.lunarvim_home .. "/site"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Carry current line to the new line in normal mode
lvim.keys.normal_mode["<CR>"] = "i<CR><Esc>"

-- Cursor movement in insert mode
lvim.keys.insert_mode["<C-j>"] = "<Down>"
lvim.keys.insert_mode["<C-k>"] = "<Up>"
lvim.keys.insert_mode["<C-h>"] = "<Left>"
lvim.keys.insert_mode["<C-l>"] = "<Right>

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
  "go",
  "cpp"
}
```

### Dap

 `<Leader>Lf` 搜索 `plugins.lua`

**plugins**  `$HOME/.local/share/lunarvim/lvim/plugins.lua`

```lua
 {
    "theHamsta/nvim-dap-virtual-text",
    disable = not lvim.builtin.dap.active,
  },
  {
    "rcarriga/nvim-dap-ui",
    disable = not lvim.builtin.dap.active,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    disable = not lvim.builtin.dap.active,
  },
```

  `<Leader>Lf` 搜索 `dap.lua`

**references** [dap-ui](https://github.com/rcarriga/nvim-dap-ui) [nvim-dap-virtaul-text](https://github.com/theHamsta/nvim-dap-virtual-text#nvim-dap-virtual-text)

**settings** `~/.local/share/lunarvim/lvim/lua/lvim/core/dap.lua`

```lua
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
```

### Java

#### Jdtls Client

实现查看 JDK 源码 。 `<Leader>Lf` 查找 `plugins.lua` 

**plugins** `$HOME/.local/share/lunarvim/lvim/lua/lvim/plugins.lua`

```lua
  -- Lsp java client
  {
    "mfussenegger/nvim-jdtls"
  },
```

#### java-debug installation

- Clone [java-debug](https://github.com/microsoft/java-debug)
- Navigate into the cloned repository (`cd java-debug`)
- Run `./mvnw clean install`
- Set or extend the `initializationOptions` (= `init_options` of the `config` from [configuration](https://github.com/mfussenegger/nvim-jdtls#Configuration)) 

```sh
git clone https://github.com/microsoft/java-debug.git ~/.config/lunarvim-debug-support/java-debug
```

#### vscode-java-test installation

To be able to debug junit tests, it is necessary to install the bundles from [vscode-java-test](https://github.com/microsoft/vscode-java-test):

- Clone the repository
- Navigate into the folder (`cd vscode-java-test`)
- Run `npm install`
- Run `npm run build-plugin`
- Extend the bundles in the nvim-jdtls config:

```sh
git clone https://github.com/microsoft/vscode-java-test.git ~/.config/lunarvim-debug-support/vscode-java-test
```

#### Jdtls

 `<Leader>Lf` 查找  `java.lua`

**settings** `$HOME/.local/share/lunarvim/site/after/ftplugin/java.lua`

```lua
local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

local home = os.getenv "HOME"
-- find_root looks for parent directories relative to the current buffer containing one of the given arguments.
if vim.fn.has "mac" == 1 then
  WORKSPACE_PATH = home .. "/.workspace/"
elseif vim.fn.has "unix" == 1 then
  WORKSPACE_PATH = home .. "/.workspace/"
else
  print "Unsupported system"
end

local root_markers = { ".gitmodules", ".git/", "pom.xml","gradlw" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
JAVA_LS_EXECUTABLE = home .. "/.local/share/lunarvim/lvim/utils/bin/jdtls"

-- This bundles definition is the same as in the previous section (java-debug installation)
local bundles = {
  vim.fn.glob(lvim.debug_env_dir .."/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
};
-- This is the new part
vim.list_extend(bundles, vim.split(vim.fn.glob(lvim.debug_env_dir .."/vscode-java-test/server/*.jar"), "\n"))

lvim.lsp.code_lens_refresh = false

local on_attach = function(client, bufnr)
  require "lvim.lsp".common_on_attach(client, bufnr)
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.dap').setup_dap_main_class_configs()

  local dap = require "dap"
  dap.configurations.java = {
    {
      type = 'java';
      request = 'attach';
      name = "debug (attach) - remote";
      hostname = "127.0.0.1";
      port = 5005;
    },
  }
end

jdtls.start_or_attach {
  on_attach = on_attach,

  flags = {
    allow_incremental_sync = true,
  },

  root_dir = root_dir,

  cmd = { JAVA_LS_EXECUTABLE, WORKSPACE_PATH .. vim.fn.fnamemodify(root_dir, ":p:h:t") },

  settings = {
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = { starThreshold = 9999, staticStarThreshold = 9999, },
    },
    codeGeneration = {
      toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}", },
      useBlocks = true,
    },
    java = {
      eclipse = { downloadSources = true, },
      maven = { downloadSources = true, },
      implementationsCodeLens = { enabled = true, },
      referencesCodeLens = { enabled = true, },
      references = { includeDecompiledSources = true, },
      format = { enabled = true, },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
    },
    contentProvider = { preferred = "fernflower" },
  },
  init_options = { bundles = bundles },
}

local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local actions = require "telescope.actions"
local pickers = require "telescope.pickers"
local action_state = require "telescope.actions.state"

require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
  local opts = {
    winblend = 15,
    layout_config = { prompt_position = "top", width = 80, height = 12, },
  }

  pickers.new(opts, {
    prompt_title = prompt,

    finder = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return { value = entry, display = label_fn(entry), ordinal = label_fn(entry), }
      end,
    },

    sorter = sorters.get_generic_fuzzy_sorter(),

    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        cb(selection.value)
      end)

      return true
    end,
  }):find()
end

vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
vim.api.nvim_set_keymap("n", "<leader>la", ":lua require('jdtls').code_action()<CR>", { noremap = true, silent = true, })

vim.cmd "command! -buffer JdtCompile lua require('jdtls').compile()"
vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
-- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  j = {
    name = "Java",
    o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
    v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
    c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
  },
}

local vmappings = {
  j = {
    name = "Java",
    v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
    c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
    m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

vim.cmd [[setlocal shiftwidth=4]]
vim.cmd [[setlocal tabstop=4]]

-- require("lvim.lsp.manager").setup("jdtls")
```



### Python

**references**  [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)

#### Debugpy

```sh
mkdir $HOME/.config/lunarvim-debug-support/virtualenvs
cd $HOME/.config/lunarvim-debug-support/virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
```

#### Tree-sitter

```lua
:TSInstall python
```

**plugins**  `$HOME/.local/share/lunarvim/lvim/plugins.lua`

```lua
  {
    "mfussenegger/nvim-dap-python"
  },
```

**settings** `$HOME/.local/share/lunarvim/site/after/ftplugin/python.lua`

```lua
local dap = require('dap')
dap.adapters.python = {
  type = 'executable';
  command = lvim.debug_env_dir..'/virtualenvs/debugpy/bin/python';
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    justMyCode = false,
    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}
require("lvim.lsp.manager").setup("pyright")
```

### Golang

#### Install golang && Setting

download  [go1.17.6](https://go.dev/dl/go1.17.6.linux-amd64.tar.gz) from offical website and unpack it to `/usr/local`

```sh
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
```

```go
go version
```

```properties
export GO111MODULE=on
export GOROOT=/usr/local/env/go
export GOPATH=$HOME/Workspace/projects/GoProjects
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN  
```

```sh
cd $GOPATH && mkdir -p bin pkg src
```

```go
go install golang.org/x/tools/gopls@latest
```

> **NOTE**
>
> `gopls` 只在項目文件夾包含 `.git` 或 `go.mod` 才會識別，在項目文件夾上執行下面命令：
>
> ```sh
> git init 
> ```
>
> 或者
>
> ```go
> go mod init example.com/m/v2
> ```

#### Golang debug settings

**references** [Debug-Adapter-installation#Go](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Go)

- Install [delve](https://github.com/go-delve/delve/tree/master/Documentation/installation)

  - ```go
    go install github.com/go-delve/delve/cmd/dlv@latest
    ```

  - or via package manager (`pacman -S delve`)

- Install [vscode-go](https://github.com/golang/vscode-go)

  - `git clone https://github.com/golang/vscode-go.git  ~/.config/lunarvim-debug-support/vscode-go`
  - `cd vscode-go`
  - `npm install`
  - `npm run compile`

**settings** `$HOME/.local/share/lunarvim/site/after/ftplugin/go.lua`

```lua
local dap = require "dap"
dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = {lvim.debug_env_dir ..'/vscode-go/dist/debugAdapter.js'};
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
```



### Clang

#### Building lldb-vscode

**references** [Debug-Adapter-installation#ccrust-via-lldb-vscode](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode) 

```sh
sudo pacman -S cmake gcc zlib make clang ninja
```

```sh
git clone https://github.com/llvm/llvm-project.git  ~/.config/lunarvim-debug-support/llvm-project
```

```shell
LLVM_ROOT=~/.config/lunarvim-debug-support/llvm-project
```

```sh
cd $LLVM_ROOT && rm -rf $LLVM_ROOT/build &&  mkdir $LLVM_ROOT/build
```

```sh
cmake -S $LLVM_ROOT/llvm -B $LLVM_ROOT/build \
-DLLVM_ENABLE_PROJECTS="clang;lldb" \

-DCMAKE_BUILD_TYPE=Release \
-DLLVM_ENABLE_ASSERTIONS=On \
-G Ninja 
```

```sh
cmake --build $LLVM_ROOT/build --target lldb-vscode
```

```sh
cmake --build $LLVM_ROOT/build --target lldb-server
```

> **NOTE**
>
> 编译后，`lldb-vscode` 、`lldb-server` 会 copy 到 `/usr/bin` 目录下

#### C & CPP settings

`$HOME/.local/share/lunarvim/site/after/ftplugin/cpp.lua`

```lua
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
```

#### CMake settings

`$HOME/.local/share/lunarvim/site/after/ftplugin/cmake.lua`

```lua
local Path = require('plenary.path')
local script_path = Path:new(debug.getinfo(1).source:sub(2))

local config = {
  defaults = {
    cmake_executable = 'cmake',
    parameters_file = 'neovim.json',
    build_dir = tostring(Path:new('{cwd}', 'build')),
    samples_path = tostring(script_path:parent():parent():parent() / 'samples'),
    default_projects_path = tostring(Path:new(vim.loop.os_homedir(), 'Workspace/projects/ClionProjects/test')),
    configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
    build_args = {},
    quickfix_height = 10,
    dap_configuration = { type = 'cpp', request = 'launch' },
    -- dap_open_command = require('dap').repl.open,
  },
}

setmetatable(config, { __index = config.defaults })

require("lvim.lsp.manager").setup("cmake",config.defaults)
```

#### plugin

**references**  [neovim-cmake](https://github.com/Shatur/neovim-cmake)

```lua
  {
      "Shatur/neovim-cmake"
  },
```

> **NOTE**
>
> 如果上面 `cmake.lua` 配置没有作用，则直接修改插件的配置

`$HOME/.local/share/lunarvim/site/pack/packer/start/neovim-cmake/lua/cmake/config.lua`

```lua
local Path = require('plenary.path')
local script_path = Path:new(debug.getinfo(1).source:sub(2))

local config = {
  defaults = {
    cmake_executable = 'cmake',
    parameters_file = 'neovim.json',
    build_dir = tostring(Path:new('{cwd}', 'build')),
    samples_path = tostring(script_path:parent():parent():parent() / 'samples'),
    default_projects_path = tostring(Path:new(vim.loop.os_homedir(), 'Workspace/projects/ClionProjects')),
    configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
    build_args = {},
    quickfix_height = 10,
    dap_configuration = { type = 'cpp', request = 'launch' },
    -- dap_open_command = require('dap').repl.open,
  },
}

setmetatable(config, { __index = config.defaults })

return config
```

#### which-key

```lua
      k = {
        name = "CMake",
        -- Create a new project or open an existing
        n = { ":CMake create_project<cr>", "New project" },
        -- Configure project to create build folder and get targets information
        c = { ":CMake configure<cr>", "Configure project" },
        -- Select target to execute
        s = { ":CMake select_target<cr>", "Select target" },
        -- Compile selected target (via --build). Additional arguments will be passed to CMake
        b = { ":CMake build<cr>", "Build" },
        -- Execute clear target. Additional arguments will be passed to CMake.
        r = { ":CMake clean<cr>", "Remove target" },
        -- Delete CMakeCache.txt file from the build directory.
        d = { ":CMake clean<cr>", "Delete CMakeCache.txt" },
        -- Cancel current running CMake action like build or run.
        q = { ":CMake cancel<cr>", "Cancel build" },
      },
```



### Copy ftplugin && plugin

**settings** `$HOME/.local/share/lunarvim/lvim/lua/lvim/lsp/templates.lua`

```lua
---Generates ftplugin files based on a list of server_names
---The files are generated to a runtimepath: "$LUNARVIM_RUNTIME_DIR/site/after/ftplugin/template.lua"
---@param servers_names table list of servers to be enabled. Will add all by default
function M.generate_templates(servers_names)
  ...

  -- Call os.execute() to execute user-defined script and copy user-defined language template to ftplugin_dir
  local cp_ft_script = "/utils/installer/copy-ftplugin.py"
  local cp_ft_cmd = "python "..lvim.lvim_home.. cp_ft_script
  os.execute(cp_ft_cmd)

  -- Call os.execute() to execute user-defined script and copy specify plugin config to relevant plugin directory
  local cp_plugin_script = "/utils/installer/copy-plugin.py"
  local cp_plugin_cmd = "python "..lvim.lvim_home.. cp_plugin_script
  os.execute(cp_plugin_cmd)

  Log:debug "Templates installation is complete"
end
```

*LunarVim 每次更新核心配置后（或执行 `<leader>Lr` / `<leader>Lu` 手动更新），都会重置 ftplugin，将之前设置好的语言重置最初设置。*

*解决办法是，在生成 ftplugin 方法内加入 **`os.execute(command)`** ，执行COPY脚本，重置后拷贝之前设置好的语言模板到重新创建的 ftplugin 目录下。*



### Nvim Ranger

**plugins**  `$HOME/.local/share/lunarvim/lvim/plugins.lua`

```lua
  -- Ranger
  {
   "kevinhwang91/rnvimr"
  },
```

**which-key** `$HOME/.local/share/lunarvim/lvim/lua/lvim/core/which-key.lua`

```lua
      R = {
          name = "Ranger",
          t = { ":RnvimrToggle<cr>", "toggle" },
      },
```

### Symbols Outline

**plugins**  `$HOME/.local/share/lunarvim/lvim/plugins.lua`

```lua
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("lvim.core.symbols-outline").setup()
    end,
    disable = not lvim.builtin.symbols_outline.active,
  },
```

**bultins** `$HOME/.local/share/lunarvim/lvim/lua/lvim/core/builtins/init.lua`

```lua
local builtins = {
  ...
  "lvim.core.outline",
}
```

**settings** `$HOME/.local/share/lunarvim/lvim/lua/lvim/core/symbols-outline.lua`

```lua
local M = {}

M.config = function()
  lvim.builtin.symbols_outline = {
    active = true,
    on_config_done = nil,
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = 'right',
    relative_width = true,
    width = 50,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
  }
end

M.setup = function ()
  local symbols_outline = require"symbols-outline"
  symbols_outline.setup(lvim.builtin.symbols_outline)

  if lvim.builtin.symbols_outline.on_config_done then
    lvim.builtin.symbols_outline.on_config_done(symbols_outline)
  end
end

return M
```

**which-key** `$HOME/.local/share/lunarvim/lvim/lua/lvim/core/which-key.lua`

```lua
 o = { "<cmd>SymbolsOutline<cr>", "Outline" },
```

> **NOTE**
>
> 上面的配置不起作用，只有在插件目录里改变原始配置才起作用，以后重构吧

`$HOME/.local/share/lunarvim/site/pack/packer/start/symbols-outline.nvim/lua/symbols-outline/config.lua`

```lua
M.defaults = {
    highlight_hovered_item = true,
    show_guides = true,
    position = 'right',
    relative_width = true,
    width = 45,
    auto_close = false,
    auto_preview = true,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    ...
 }
```



### Project

```lua
patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".idea", "pom.xml", ".vscode", "gradlw", "go.mod"},
```



### Scripts

#### copy-ftplugin.py

```python
import os
import subprocess
HOME = os.path.expanduser('~')
LUNARVIM_DIR = os.path.join("$HOME",".local/share/lunarvim")
FTPLUGIN_DIR = os.path.join(LUNARVIM_DIR, "site/after/ftplugin")

def get_all_ft(dir):
    for _, _, filenames in os.walk(dir):
        for filename in filenames:
            yield filename 


def main():
    example_dir = os.path.join(LUNARVIM_DIR,"lvim/utils/installer/ftplugin-example")

    for example_ft in get_all_ft(example_dir):
        ft = str.replace(example_ft,".example","")
        origin_ft = os.path.join(FTPLUGIN_DIR,ft)
    
        if os.path.exists(origin_ft):
            subprocess.run(["rm","-f",origin_ft])

        subprocess.run(["cp",os.path.join(example_dir,example_ft),origin_ft])

if __name__ == "__main__":
    main()
```

#### copy-plugin.py

`$HOME/.local/share/lunarvim/lvim/utils/installer/copy-plugin.py`

```python
import os
import subprocess
from pathlib import Path

HOME = os.path.expanduser('~')
LUNARVIM_DIR = os.path.join("$HOME",".local/share/lunarvim")
PACKER_DIR = os.path.join(LUNARVIM_DIR, "site/pack/packer/start")
EXAMPLE_DIR = os.path.join(LUNARVIM_DIR,"lvim/utils/installer/plugin-example")

def main():
    example_dict = { } 

    for dirpath, _, filenames in os.walk(EXAMPLE_DIR):
        for filename in filenames:
            # $HOME/.local/share/lunarvim/lvim/utils/installer/plugin-example/cmake/config.lua
            absolute_path_example_config = os.path.join(dirpath, str.replace(filename, ".example",""))
            # cmake/config.lua
            pattern = os.path.join(Path(absolute_path_example_config).parent.name, Path(absolute_path_example_config).name)
           
            # key:cmake/config.lua; 
            # value:$HOME/.local/share/lunarvim/lvim/utils/installer/plugin-example/cmake/config.example.lua
            example_dict.__setitem__(pattern, os.path.join(dirpath, filename))

    for dirpath, _, filenames in os.walk(PACKER_DIR):
        for filename in filenames:
            absolute_path_config = os.path.join(dirpath, filename)
            pattern = os.path.join(Path(absolute_path_config).parent.name, Path(absolute_path_config).name)            
            if example_dict.get(pattern) != None:
                absolute_path_example_config = Path(example_dict.get(pattern,""))
                subprocess.run([ "cp", absolute_path_config, absolute_path_config + ".back" ])
                subprocess.run([ "cp", absolute_path_example_config, absolute_path_config ])


if __name__ == "__main__":
   main()
```



#### Install debug env  script

`$HOME/.local/share/lunarvim/lvim/utils/installer/install-lunarvim-debug-support.sh`

```bash
#!/usr/bin/env bash

# Declare support dir
declare -r DEBUG_BASE_DIR=${BASE_DIR:-"$HOME/.config"}
declare -r SUPPORT_DEBUG_HOME=${SUPPORT_DEBUG_HOME:-"$DEBUG_BASE_DIR/lunarvim-debug-support"}
readonly DEBUG_BASE_DIR SUPPORT_DEBUG_HOME

# Declare debug environment remote address
declare -r JAVA_DEBUG_REMOTE=${JAVA_DEBUG_REMOTE:-"https://github.com/microsoft/java-debug.git"}
declare -r JAVA_VSCODE_TEST_REMOTE=${JAVA_VSCODE_TEST_REMOTE:-"https://github.com/microsoft/vscode-java-test.git"}
declare -r GO_VSOCDE_REMOTE=${GO_VSOCDE_REMOTE:-"https://github.com/golang/vscode-go.git"}

declare -r LUNARVIM_DIR="${LUNARVIM_DIR:-"$HOME/.local/share/lunarvim"}"
declare -r FTPLUGIN="${FTPLUGIN:-"$LUNARVIM_DIR/site/after/ftplugin"}"
# clone repository to specify directory

declare TARGET_DIR=""

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function check_dir_exists(){
  if [ ! -e "$1" ] || [ ! -d "$1" ]; then
    msg "$1 is not exists, now creating..."
    mkdir -p "$1" 
  fi
}

function get_remote_dir_name(){
  dir=${1##*/} 
  TARGET_DIR=${dir%.*}
}

function clone_repository(){
  # change TARGET_DIR value
  get_remote_dir_name "$1"

  msg "Now cloning $TARGET_DIR ..."
  
  if ! git clone "$1" "$SUPPORT_DEBUG_HOME/$TARGET_DIR"; then
    msg "Faild to clone repository. Installation failed."
    exit 1
  fi
}

# $1 git address
# $2 command type
# $3 npm run named srcipt
function install_debug_env(){
  
  # change TARGET_DIR value
  get_remote_dir_name $1

  if [ ! -d $SUPPORT_DEBUG_HOME/$TARGET_DIR ]; then
    msg "$TARGET_DIR repository has not cloned to the local" 
    clone_repository $1
  fi

  msg "Now installing $TARGET_DIR ..."
  cd $SUPPORT_DEBUG_HOME/$TARGET_DIR
  
  if [ "$2" == "maven" ]; then
    mvn clean install 
  elif [ "$2" == "npm" ]; then
    npm install
    npm run $3 
  fi
}

function install_python_debug_env(){
  msg "Now installing debugpy ..."

  cd $SUPPORT_DEBUG_HOME
  if [ ! -d $SUPPORT_DEBUG_HOME/virtualenvs ]; then
    mkdir virtualenvs
  fi

  cd $SUPPORT_DEBUG_HOME/virtualenvs
  python -m venv debugpy
  debugpy/bin/python -m pip install debugpy
  debugpy/bin/python -m pip install --upgrade pip
}

function main(){ 
  check_dir_exists $SUPPORT_DEBUG_HOME
  
  # install java debug
  install_debug_env $JAVA_DEBUG_REMOTE maven
  install_debug_env $JAVA_VSCODE_TEST_REMOTE npm build-plugin

  # install go debug
  msg "Now installing go-delve ..."
  go install github.com/go-delve/delve/cmd/dlv@latest
  install_debug_env $GO_VSOCDE_REMOTE npm compile

  # install python debug
  install_python_debug_env

  msg "Copying language template to ftplugin ..."
  python $LUNARVIM_DIR/lvim/utils/installer/copy-ftplugin.py
}

main
```

#### install.sh

`$HOME/.local/share/lunarvim/lvim/utils/installer/install.sh`

```sh
#!/usr/bin/env bash
...
#Set branch to master unless specified by the user
declare LV_BRANCH="${LV_BRANCH:-"support-popular-language"}"
declare -r LV_REMOTE="${LV_REMOTE:-david606/lunarvim.git}"

...

function clone_lvim() {
  msg "Cloning LunarVim configuration"
  if ! git clone --branch "$LV_BRANCH" \
    --depth 1 "git@github.com:${LV_REMOTE}" "$LUNARVIM_BASE_DIR"; then
    echo "Failed to clone repository. Installation failed."
    exit 1
  fi
}
...
```

*使用 HTTPS 形式，提交代码时需要密码；相反，SSH 形式无需密码，所以这里替换成上面的 SSH 的形式*

>HTTPS：`--depth 1 "https://github.com/${LV_REMOTE}"`
>
>SSH: `--depth 1 "git@github.com:${LV_REMOTE}"`



### References

https://github.com/mfussenegger/nvim-dap/wiki/Java

https://www.lunarvim.org/community/faq.html#where-can-i-find-some-example-configs

https://www.lunarvim.org/configuration/



### FAQ

#### 1. Failed to update packer

✗ Failed to update wbthomason/packer.nvim

`<leader> ps` 更新 , `wbthomason/packer.nvim` 更新失败

进入 packer.nvim 目录，`git log` 查看更新日志，获取 commit num，替换到 plugins 下对应的 commit num

```sh
cd $HOME/.local/share/lunarvim/site/pack/packer/start/packer.nvim
```

```sh
git log 
```

**plugins**  `$HOME/.local/share/lunarvim/lvim/plugins.lua`

```lua
  packer = "7182f0ddbca2dd6f6723633a84d47f4d26518191",
```

或者

```sh
rm -rf ~/.local/share/nvim
```

> **NOTE**
>
> `~/.local/share/nvim` 下也有一份 `LSP` 存储 

#### 2. Autostart for gopls failed

Autostart for gopls failed : matching root directory not detected.

It turns out, the buffer doesn't get attached unless I have a `.git` folder in the project root directory, or a `go.mod` file.

```sh
git init
```

https://github.com/Tastyep/lunarvim.org/blob/master/docs/01-installing.md

#### 3. 重命名文件后缓存问题

```properties
packer.nvim: Error running config for symbols-outline.nvim: [string "..."]:0: module 'lvim.core.symbols-outline' not found:
^Ino field package.preload['lvim.core.symbols-outline']No cache entry
^Ino file './lvim/core/symbols-outline.lua'
^Ino file '/usr/share/luajit-2.0.5/lvim/core/symbols-outline.lua'
^Ino file '/usr/local/share/lua/5.1/lvim/core/symbols-outline.lua'
^Ino file '/usr/local/share/lua/5.1/lvim/core/symbols-outline/init.lua'
^Ino file '/usr/share/lua/5.1/lvim/core/symbols-outline.lua'
^Ino file '/usr/share/lua/5.1/lvim/core/symbols-outline/init.lua'
^Ino file '$HOME/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/lvim/core/symbols-outline.lua'
^Ino file '$HOME/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/lvim/core/symbols-outline/init.lua'
^Ino file '$HOME/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/lvim/core/symbols-outline.lua'
^Ino file '$HOME/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/lvim/core/symbols-outline/init.lua'
^Ino file './lvim/core/symbols-outline.so'
^Ino file '/usr/local/lib/lua/5.1/lvim/core/symbols-outline.so'
^Ino file '/usr/lib/lua/5.1/lvim/core/symbols-outline.so'
^Ino file '/usr/local/lib/lua/5.1/loadall.so'
^Ino file '$HOME/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/lvim/core/symbols-outline.so'
^Ino file './lvim.so'
^Ino file '/usr/local/lib/lua/5.1/lvim.so'
^Ino file '/usr/lib/lua/5.1/lvim.so'
^Ino file '/usr/local/lib/lua/5.1/loadall.so'
```

注释掉插件即可
