vim.pack.add({
    { src = 'https://github.com/mfussenegger/nvim-dap', name = 'dap' },
    { src = 'https://github.com/igorlfs/nvim-dap-view', name = 'dap-view' },
})

local dap = require('dap')

dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/opt/lldb/bin/lldb-dap',
    name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

dap.configurations.rust = {
  {
    -- ... the previous config goes here ...,
    initCommands = function()
      -- Find out where to look for the pretty printer Python module.
      local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
      assert(
        vim.v.shell_error == 0,
        'failed to get rust sysroot using `rustc --print sysroot`: '
          .. rustc_sysroot
      )
      local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

      -- The following is a table/list of lldb commands, which have a syntax
      -- similar to shell commands.
      --
      -- To see which command options are supported, you can run these commands
      -- in a shell:
      --
      --   * lldb --batch -o 'help command script import'
      --   * lldb --batch -o 'help command source'
      --
      -- Commands prefixed with `?` are quiet on success (nothing is written to
      -- debugger console if the command succeeds).
      --
      -- Prefixing a command with `!` enables error checking (if a command
      -- prefixed with `!` fails, subsequent commands will not be run).
      --
      -- NOTE: it is possible to put these commands inside the ~/.lldbinit
      -- config file instead, which would enable rust types globally for ALL
      -- lldb sessions (i.e. including those run outside of nvim). However,
      -- that may lead to conflicts when debugging other languages, as the type
      -- formatters are merely regex-matched against type names. Also note that
      -- .lldbinit doesn't support the `!` and `?` prefix shorthands.
      return {
        ([[!command script import '%s']]):format(script_file),
        ([[command source '%s']]):format(commands_file),
      }
    end,
    -- ...,
  },
}

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'path/to/virtualenvs/debugpy/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

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
