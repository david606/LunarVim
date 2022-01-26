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
