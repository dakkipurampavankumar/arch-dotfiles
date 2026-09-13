return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- UI for the debugger - splits showing variables, call stack, breakpoints, console
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
      opts = {},
      config = function(_, opts)
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup(opts)

        -- Automatically open/close the UI when a debug session starts/stops
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
      end,
    },
  },

  -- Only load when you press a debug keybind - zero overhead otherwise
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Conditional Breakpoint' },
    { '<F8>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>dr', function() require('dap').repl.open() end, desc = 'Open Debug REPL' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Re-run Last Debug Session' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle Debug UI' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate Debug Session' },
    { '<leader>dk', function() require('dapui').eval() end, desc = 'Evaluate Expression', mode = { 'n', 'v' } },
  },

  config = function()
    local dap = require('dap')

    -- ═══════════════════════════════════════════
    -- Find codelldb path (installed by Mason)
    -- ═══════════════════════════════════════════
    local mason_registry = require('mason-registry')
    local codelldb = mason_registry.get_package('codelldb')
    local codelldb_path = codelldb:get_install_path() .. '/extension/adapter/codelldb'

    -- ═══════════════════════════════════════════
    -- C / C++ adapter configuration
    -- ═══════════════════════════════════════════
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = codelldb_path,
        args = { '--port', '${port}' },
      },
    }

    local compile_and_run = function()
      -- 1. Save the file before debugging
      vim.cmd('silent! write')

      local file = vim.fn.expand('%:p')
      local exec = vim.fn.expand('%:p:r')
      local ext = vim.fn.expand('%:e')
      
      local compiler = (ext == 'cpp' or ext == 'cc' or ext == 'cxx') and 'g++' or 'gcc'
      
      vim.notify("Compiling " .. vim.fn.expand('%:t') .. "...", vim.log.levels.INFO)
      
      -- 2. Compile with the same flags as your F5 keybind
      local out = vim.fn.system({compiler, '-g', '-Wall', '-Wextra', file, '-o', exec})
      
      if vim.v.shell_error ~= 0 then
        vim.notify("Compilation failed:\n" .. out, vim.log.levels.ERROR)
        return nil -- Abort debugging
      end
      
      return exec
    end

    dap.configurations.c = {
      {
        name = 'Compile & Launch',
        type = 'codelldb',
        request = 'launch',
        program = compile_and_run,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- C++ uses the same configuration
    dap.configurations.cpp = dap.configurations.c

    -- ═══════════════════════════════════════════
    -- Breakpoint visual indicators
    -- ═══════════════════════════════════════════
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'DapStoppedLine', numhl = '' })

    -- Highlight the line where the debugger is paused
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#304030' })
  end,
}
