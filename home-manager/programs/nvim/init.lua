----------------------------
-- key mapping settings
----------------------------
vim.g.mapleader = ","
vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>j", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>k", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>l", "<C-w>l", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>h", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>r", "<C-w>r", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>w", "<C-w>w", { noremap = true })

-- tab control
vim.api.nvim_set_keymap("n", "te", ":tabedit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true })

-- Use Tab for buffer (tab) switching with bufferline
-- vim.api.nvim_set_keymap("n", "<tab>", "<cmd>BufferLineCycleNext<cr>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<S-tab>", "<cmd>BufferLineCyclePrev<cr>", { noremap = true, silent = true })

-- move when one line is wrapped
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true })
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true })
vim.api.nvim_set_keymap("n", "gj", "j", { noremap = true })
vim.api.nvim_set_keymap("n", "<Down>", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "<Up>", "gk", { noremap = true })
vim.o.cmdheight = 0

-- devlopment plugin
-- vim.api.nvim_set_keymap("n", "<leader>r", ":luafile dev/init.lua<cr>", { noremap = true, silent = false })
vim.api.nvim_exec(
  [[
  augroup QuickFixEnter
    autocmd!
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
  augroup END
]],
  false
)

----------------------------
-- filetype settings
----------------------------
local extension_list = {
  "ts",
  "pl",
  "lua",
  "c",
  "cpp", -- apply .h file
  "tsx",
  "html",
  "css",
  "scss",
  "md",
  "vim",
  "yml",
  "toml",
  "dart",
  "java",
  "svelte",
  "hs",
  "nix",
  "mts",
  "mjs",
}
vim.api.nvim_command("augroup MyTabStop")
vim.api.nvim_command("autocmd!")
for i = 1, #extension_list do
  vim.api.nvim_command(
    "autocmd BufNewFile,BufRead *." .. extension_list[i] .. " setlocal tabstop=2 shiftwidth=2 expandtab"
  )
end
vim.api.nvim_command("autocmd BufNewFile,BufRead *.go setlocal tabstop=4 shiftwidth=4 noexpandtab")
vim.api.nvim_command("autocmd BufNewFile,BufRead *.zig setlocal tabstop=4 shiftwidth=4 expandtab")
vim.api.nvim_command("autocmd BufNewFile,BufRead *.php set filetype=php")
vim.api.nvim_command("autocmd FileType php setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4 autoindent")
vim.api.nvim_command("autocmd BufNewFile,BufRead Makefile setlocal noexpandtab")
-- vim.api.nvim_command("autocmd BufWritePre *.ts,*.tsx :Prettier")
-- JS/TS 以外は従来通り formatter.nvim でフォーマット
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.rs", "*.hs", "*.lua", "*.toml", "*.svelte", "*.py", "*.java", "*.c", "*.h", "*.nix", "*.scala" },
  callback = function()
    vim.cmd("FormatWrite")
  end,
})

-- JS/TS 系は設定ファイルがある場合のみ LSP でフォーマット
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.mts", "*.js", "*.jsx" },
  callback = function()
    local root_dir = vim.fn.getcwd()
    -- biome, oxfmt, deno のいずれかの設定ファイルがある場合のみフォーマット
    if
      vim.fn.filereadable(root_dir .. "/biome.jsonc") == 1
      or vim.fn.filereadable(root_dir .. "/biome.json") == 1
      or vim.fn.filereadable(root_dir .. "/.oxfmtrc.json") == 1
      or vim.fn.filereadable(root_dir .. "/deno.jsonc") == 1
      or vim.fn.filereadable(root_dir .. "/deno.json") == 1
    then
      vim.lsp.buf.format({
        async = false,
        filter = function(client)
          -- oxfmt > biome > denols の優先順位
          local formatters = { "oxfmt", "biome", "denols" }
          for _, name in ipairs(formatters) do
            if client.name == name then
              return true
            end
          end
          return false
        end,
      })
    end
  end,
})
vim.api.nvim_command("augroup END")

----------------------------
-- display content settings
----------------------------
-- visualize line number
vim.api.nvim_command("set number")
-- visualize control characters
vim.api.nvim_command("set list")
-- control characters setting char
vim.api.nvim_command("set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲,trail:~")
-- display vertical and horizontal cursors
vim.api.nvim_command("set cursorline")
vim.api.nvim_command("set cursorcolumn")
-- vim.api.nvim_command("set cmdheight=1")
-- tab title always display
vim.api.nvim_command("set showtabline=2")
-- clear search result
vim.api.nvim_set_keymap("n", "<Space><Space>", ":nohlsearch<CR><Esc>", { noremap = true, silent = true })

----------------------------
-- other settings
----------------------------
-- save yank results to clipboard
vim.api.nvim_command("set clipboard+=unnamed")

-- Configure Deno LSP (runs when package.json doesn't exist)
vim.lsp.config("denols", {
  cmd = { "deno", "lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- Use current directory as root
  root_markers = { "deno.json", "deno.jsonc", ".git", "." },
  single_file_support = true,
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
    suggest = {
      completeFunctionCalls = true,
      names = true,
      paths = true,
      autoImports = true,
      imports = {
        autoDiscover = true,
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.skypack.dev"] = true,
          ["https://esm.sh"] = true,
        },
      },
    },
    documentPreload = {
      enable = true,
      limit = 10,
    },
    inlayHints = {
      parameterNames = {
        enabled = "all",
      },
      parameterTypes = {
        enabled = true,
      },
      variableTypes = {
        enabled = true,
      },
      propertyDeclarationTypes = {
        enabled = true,
      },
      functionLikeReturnTypes = {
        enabled = true,
      },
      enumMemberValues = {
        enabled = true,
      },
    },
  },
  settings = {
    deno = {
      enable = true,
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
})

-- Configure TypeScript LSP (only runs when package.json exists)
vim.lsp.config("ts_ls", {
  init_options = { hostInfo = "neovim" },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- package.json is required for ts_ls to start
  root_markers = { "package.json" },
})

-- Function to check and enable appropriate LSP
local function setup_lsp_for_buffer()
  local root_dir = vim.fn.getcwd()
  local package_json = root_dir .. "/package.json"
  if vim.fn.filereadable(package_json) == 1 then
    -- Only try to enable ts_ls if package.json exists
    pcall(function()
      vim.lsp.enable("ts_ls")
    end)
  else
    -- Enable Deno LSP when no package.json
    vim.lsp.enable("denols")
  end
end

-- Helper function to find local executable or fallback to global
local function get_local_or_global_cmd(root_dir, cmd_name)
  local local_cmd = root_dir .. "/node_modules/.bin/" .. cmd_name
  if vim.fn.executable(local_cmd) == 1 then
    return local_cmd
  end
  return cmd_name
end

-- Function to check and enable oxlint/oxfmt/biome based on config files
local function setup_js_tools_lsp()
  local root_dir = vim.fn.getcwd()

  if vim.fn.filereadable(root_dir .. "/.oxlintrc.json") == 1 then
    vim.lsp.config("oxlint", {
      cmd = { get_local_or_global_cmd(root_dir, "oxlint"), "--lsp" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_markers = { ".oxlintrc.json" },
      init_options = {
        settings = {
          fixKind = "all",
          typeAware = true,
        },
      },
    })
    vim.lsp.enable("oxlint")
  end

  if vim.fn.filereadable(root_dir .. "/.oxfmtrc.json") == 1 then
    vim.lsp.config("oxfmt", {
      cmd = { get_local_or_global_cmd(root_dir, "oxfmt"), "--lsp" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_markers = { ".oxfmtrc.json" },
      init_options = {
        options = {
          ["fmt.experimental"] = true,
        },
      },
    })
    vim.lsp.enable("oxfmt")
  end

  if vim.fn.filereadable(root_dir .. "/biome.jsonc") == 1 or vim.fn.filereadable(root_dir .. "/biome.json") == 1 then
    vim.lsp.enable("biome")
  end
end

-- Setup LSP when entering TypeScript/JavaScript files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    setup_lsp_for_buffer()
    setup_js_tools_lsp()
  end,
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("hls", {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell", "lhaskell", "cabal" },
})
vim.lsp.enable("hls")

-- vim.lsp.config("pyre", {
--   cmd = { "pyre", "persistent" },
--   filetypes = { "python" },
--   root_markers = { ".pyre_configuration" },
-- })
-- vim.lsp.enable("pyre")
vim.diagnostic.config({
  virtual_lines = true,
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = "always",
    border = "rounded",
  },
})

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "pyrightconfig.json",
    ".venv",
    "setup.py",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})
vim.lsp.enable("pyright")

vim.lsp.config("ruff_lsp", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
  init_options = {
    settings = {
      organizeImports = true,
      fixAll = true,
      lint = {
        enable = true,
        run = "onType",
      },
      format = {
        enable = true,
      },
    },
  },
})
vim.lsp.enable("ruff_lsp")

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go" },
  root_markers = { "go.mod" },
  init_options = {
    gofumpt = true,
  },
})
vim.lsp.enable("gopls")

-- oxlint LSP (linter) - configured dynamically in setup_js_tools_lsp
-- oxfmt LSP (formatter) - configured dynamically in setup_js_tools_lsp

-- biome LSP (linter + formatter)
vim.lsp.config("biome", {
  cmd = { "biome", "lsp-proxy" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "json",
    "jsonc",
  },
  root_markers = { "biome.jsonc", "biome.json" },
  capabilities = {
    general = {
      positionEncodings = { "utf-16" },
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = nil
    vim.bo[ev.buf].tagfunc = nil
    vim.bo[ev.buf].formatexpr = nil

    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Add oxlint fix all command
    if client.name == "oxlint" then
      vim.api.nvim_buf_create_user_command(ev.buf, "LspOxlintFixAll", function()
        client:exec_cmd({
          title = "Apply Oxlint automatic fixes",
          command = "oxc.fixAll",
          arguments = { { uri = vim.uri_from_bufnr(ev.buf) } },
        })
      end, {
        desc = "Apply Oxlint automatic fixes",
      })
    end

    local set = vim.keymap.set

    set("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
    set("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")

    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local keyopts = { remap = true, silent = true }
    if client:supports_method("textDocument/implementation") then
      set("n", "gD", vim.lsp.buf.implementation, keyopts)
    end
    if client:supports_method("textDocument/hover") then
      set("n", "K", vim.lsp.buf.hover, keyopts)
    end
    if client:supports_method("textDocument/definition") then
      -- Deno LSPの場合は特別な処理
      if client.name == "denols" then
        set("n", "gd", function()
          -- まず通常の定義ジャンプを試みる
          local params = vim.lsp.util.make_position_params()
          vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
            if err or not result or (vim.tbl_islist(result) and #result == 0) then
              -- 定義が見つからない場合はホバーで情報を表示
              vim.lsp.buf.hover()
              return
            end

            -- 結果を確認
            local locations = result
            if not vim.tbl_islist(locations) then
              locations = { locations }
            end

            -- deno:スキームのURIをチェック
            local has_deno_uri = false
            for _, loc in ipairs(locations) do
              if loc.uri and vim.startswith(loc.uri, "deno:") then
                has_deno_uri = true
                break
              end
            end

            if has_deno_uri then
              -- 組み込み型の場合はホバーで型情報を表示
              vim.lsp.buf.hover()
              vim.notify("Built-in type - showing hover info instead", vim.log.levels.INFO)
            else
              -- 通常のファイルの場合は定義にジャンプ
              vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
            end
          end)
        end, keyopts)
      else
        set("n", "gd", vim.lsp.buf.definition, keyopts)
      end
    end
    if client:supports_method("textDocument/typeDefinition*") then
      set("n", "gt", vim.lsp.buf.type_definition, keyopts)
    end
    if client:supports_method("textDocument/references") then
      set("n", "gr", vim.lsp.buf.references, keyopts)
    end
    if client:supports_method("textDocument/rename") then
      set("n", "rn", vim.lsp.buf.rename, keyopts)
    end
    if client:supports_method("textDocument/codeAction") then
      set("n", "<Leader>k", vim.lsp.buf.code_action, keyopts)
    end
    if client:supports_method("textDocument/signatureHelp") then
      vim.api.nvim_create_autocmd("CursorHoldI", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.signature_help({ focus = false, silent = true })
        end,
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_lines = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end
  end,
})

----------------------------
-- Package manager settings
----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- vim.cmd([[colorscheme tokyonight]])
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
  },
  { "mattn/vim-goimports" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
        defaults = { layout_strategy = "horizontal" },
      })
      require("telescope").load_extension("fzf")

      vim.api.nvim_set_keymap(
        "n",
        "<C-j><C-p>",
        "<cmd>Telescope find_files find_command=rg,--glob=!.git/,--hidden,--files prompt_prefix=🔍<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<Space>a",
        "<cmd>Telescope lsp_workspace_diagnostics<cr>",
        { noremap = true, silent = true }
      )
      vim.cmd([[
        command! D execute(":lua require'telescope.builtin'.live_grep{ vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '--glob', '!.git' } }")
      ]])
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    opt = true,
    event = { "VimEnter" },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
        -- conflict winresizer
        -- vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        -- vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))  -- Disable Tab in nvim-tree
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
        vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
        vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
        vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
        vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
        -- END_DEFAULT_ON_ATTACH

        -- Mappings migrated from view.mappings.list
        vim.keymap.set("n", "A", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))

        vim.keymap.set("n", "Z", api.node.run.system, opts("Run System"))
      end

      local nvim_tree = require("nvim-tree")
      nvim_tree.setup({
        on_attach = on_attach,
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,
            eject = true,
            resize_window = true,
            window_picker = {
              enable = true,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
      })
      vim.api.nvim_set_keymap("n", "<Leader>d", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- Flash.nvimのデフォルトマッピングを無効化
      modes = {
        char = {
          enabled = false,
        },
      },
    },
  -- stylua: ignore
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup({})
    end,
  },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup()
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
        },
        indent = {
          enable = false,
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },
  {
    "mhartington/formatter.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local Path = require("plenary.path")

      -- Function to check if deno.jsonc exists in the project root
      local function use_deno_fmt()
        local current_dir = vim.fn.getcwd()
        local deno_config_path = Path:new(current_dir, "deno.jsonc")
        return deno_config_path:exists()
      end

      -- Function to get the local biome executable path
      local function get_biome_exe()
        local current_dir = vim.fn.getcwd()
        local biome_path = Path:new(current_dir, "node_modules", ".bin", "biome")
        if biome_path:exists() then
          return biome_path:absolute()
        else
          return "biome" -- fallback to global biome if local not found
        end
      end

      local util = require("formatter.util")

      require("formatter").setup({
        filetype = {
          javascript = {
            function()
              if use_deno_fmt() then
                return {
                  exe = "deno",
                  args = { "fmt", "-" },
                  stdin = true,
                }
              else
                local file_path = util.get_current_buffer_file_path()
                return {
                  exe = get_biome_exe(),
                  args = {
                    "check",
                    "--write",
                    -- "--unsafe",
                    "--stdin-file-path",
                    util.escape_path(file_path),
                  },
                  stdin = true,
                  cwd = vim.fn.fnamemodify(file_path, ":h"), -- Set the working directory to the file's directory
                }
              end
            end,
          },
          nix = {
            function()
              return {
                exe = "nixfmt",
                stdin = true,
              }
            end,
          },
          java = {
            function()
              return {
                exe = "google-java-format",
                args = {
                  "-",
                },
                stdin = true,
              }
            end,
          },
          python = {
            function()
              return {
                exe = "uv",
                args = { "run", "ruff", "format", "-" },
                stdin = true,
              }
            end,
          },
          javascriptreact = {
            function()
              if use_deno_fmt() then
                return {
                  exe = "deno",
                  args = { "fmt", "-" },
                  stdin = true,
                }
              else
                -- local file_path = util.get_current_buffer_file_path()
                -- return {
                --   exe = get_biome_exe(),
                --   args = {
                --     "check",
                --     "--write",
                --     -- "--unsafe",
                --     "--stdin-file-path",
                --     util.escape_path(file_path),
                --   },
                --   stdin = true,
                --   cwd = vim.fn.fnamemodify(file_path, ":h"), -- Set the working directory to the file's directory
                -- }
              end
            end,
          },
          svelte = {
            function()
              return { exe = "prettier", args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) }, stdin = true }
            end,
          },
          -- typescript = {
          --   function()
          --     return { exe = "prettier", args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) }, stdin = true }
          --   end,
          -- },
          -- go = {
          --   function()
          --     local file_path = util.get_current_buffer_file_path()
          --     return {
          --       exe = "go",
          --       args = { "fmt", "-" },
          --       stdin = true,
          --       cwd = vim.fn.fnamemodify(file_path, ":h"), -- Set the working directory to the file's directory
          --     }
          --   end,
          -- },
          -- typescript = {
          --   function()
          --     if use_deno_fmt() then
          --       return {
          --         exe = "deno",
          --         args = { "fmt", "-" },
          --         stdin = true,
          --       }
          --     else
          --       local file_path = util.get_current_buffer_file_path()

          --       return {
          --         exe = get_biome_exe(),
          --         args = {
          --           "check",
          --           "--write",
          --           -- "--unsafe",
          --           "--stdin-file-path",
          --           util.escape_path(file_path),
          --         },
          --         stdin = true,
          --         cwd = vim.fn.fnamemodify(file_path, ":h"), -- Set the working directory to the file's directory
          --       }
          --     end
          --   end,
          -- },
          typescriptreact = {
            function()
              if use_deno_fmt() then
                return {
                  exe = "deno",
                  args = { "fmt", "-" },
                  stdin = true,
                }
              else
                local file_path = util.get_current_buffer_file_path()

                return {
                  exe = get_biome_exe(),
                  args = {
                    "check",
                    "--write",
                    -- "--unsafe",
                    "--stdin-file-path",
                    util.escape_path(file_path),
                  },
                  stdin = true,
                  cwd = vim.fn.fnamemodify(file_path, ":h"), -- Set the working directory to the file's directory
                }
              end
            end,
          },
          c = {
            function()
              return {
                exe = "clang-format",
                args = { "-i" },
              }
            end,
          },
          cpp = {
            function()
              return {
                exe = "clang-format",
                args = { "-i" },
              }
            end,
          },
          toml = {
            function()
              return {
                exe = "taplo",
                args = { "format" },
              }
            end,
          },
          haskell = {
            function()
              return {
                exe = "ormolu",
                args = { "--mode", "inplace" },
              }
            end,
          },
          lua = {
            function()
              return {
                exe = "stylua",
              }
            end,
          },
          rust = {
            function()
              return {
                exe = "rustfmt",
                args = { "--emit=stdout", "--edition=2021" },
                stdin = true,
              }
            end,
          },
          scala = {
            function()
              return {
                exe = "scalafmt",
              }
            end,
          },
        },
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- defaults to false
      })

      vim.api.nvim_set_keymap(
        "n",
        "<C-w>j",
        ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>k",
        ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>l",
        ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>h",
        ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal

      -- Create lazygit dynamically to use current directory
      function _LAZYGIT_TOGGLE()
        local lazygit = Terminal:new({
          cmd = "lazygit",
          -- Use current working directory instead of git_dir
          dir = vim.fn.getcwd(),
          direction = "float",
          on_close = function(_)
            -- nvim-treeをリロード（利用可能な場合）
            local ok, api = pcall(require, "nvim-tree.api")
            if ok then
              pcall(api.tree.reload)
            end
          end,
          float_opts = {
            border = "double",
          },
        })
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })
    end,
  },
  {
    -- FIXME: not work
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new({ elements = { "let", "const" } }),
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
      })

      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual("visual"), { noremap = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual("visual"), { noremap = true })
    end,
  },
  { "sindrets/diffview.nvim" },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  { "simeji/winresizer" },
  { "kyazdani42/nvim-web-devicons" },
  {
    "akinsho/bufferline.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          close_command = "bdelete! %d",
          diagnostics_indicator = function(count, level, _, _)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = { { filetype = "NvimTree" } },
        },
      })

      vim.api.nvim_set_keymap("n", "[b", "<cmd>BufferLineCycleNext<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "b]", "<cmd>BufferLineCyclePrev<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>BufferLineSortByTabs<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>BufferLinePick<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader><leader>r",
        "<cmd>BufferLineCloseRight<cr>",
        { noremap = true, silent = true }
      )
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
        },
        sections = {
          lualine_a = { "bo:filetype" },
          lualine_c = { { "filename", path = 1 } },
        },
        inactive_sections = { -- 非アクティブウィンドウの設定を追加
          lualine_a = { "bo:filetype" },
          lualine_c = { { "filename", path = 1 } },
        },
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install && cd - && git restore .",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "vim-denops/denops.vim",
    lazy = false,
  },
  {
    "lambdalisue/kensaku-search.vim",
    lazy = false,
    config = function()
      vim.keymap.set("c", "<CR>", "<Plug>(kensaku-search-replace)<CR>")
    end,
    dependencies = {
      "lambdalisue/kensaku.vim",
    },
  },
  { "lambdalisue/kensaku.vim", lazy = false },

  {
    "shuntaka9576/preview-asciidoc.vim",
    dependencies = {
      "vim-denops/denops.vim",
    },
  },
  {
    "skanehira/denops-docker.vim",
    dependencies = {
      "vim-denops/denops.vim",
    },
  },
  {
    "ziglang/zig.vim",
    config = function()
      vim.cmd([[
        let g:zig_fmt_autosave = 1
      ]])
    end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     local lspconfig = require("lspconfig")
  --     lspconfig.lua_ls.setup({
  --       settings = {
  --         Lua = {
  --           completion = {
  --             callSnippet = "Replace",
  --           },
  --         },
  --       },
  --     })
  --     lspconfig.jsonls.setup({})
  --     lspconfig.ts_ls.setup({})

  --     vim.lsp.config("*", {
  --       capabilities = require("cmp_nvim_lsp").default_capabilities(),
  --     })
  --   end,
  -- },
  -- {
  --   "mrcjkb/haskell-tools.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   version = "^3", -- Recommended
  --   ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  --   init = function()
  --     vim.g.haskell_tools = {}
  --   end,
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "main",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" },
  --     { "nvim-lua/plenary.nvim" },
  --   },
  --   build = "make tiktoken",
  --   opts = {
  --     debug = true,
  --   },
  --   opts = function()
  --     vim.keymap.set("n", "<leader>cA", "<cmd>CopilotChat<CR>", { noremap = true, silent = true })
  --     vim.keymap.set("n", "<leader>cS", "<cmd>CopilotChatCommitStaged<CR>", { noremap = true, silent = true })
  --     vim.keymap.set("n", "<leader>cC", "<cmd>CopilotChatClose<CR>", { noremap = true, silent = true })
  --   end,
  -- },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     -- The following are optional:
  --     { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  --   },
  --   config = true,
  -- },
  { "lambdalisue/vim-gin" },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      -- { "zbirenbaum/copilot-cmp" },
      -- { "zbirenbaum/copilot.lua" },
      { "onsails/lspkind.nvim" },
    },
    opts = function()
      local cmp = require("cmp")

      -- require("copilot_cmp").setup()
      -- please setup :Copilot auth
      -- require("copilot").setup({
      --   suggestion = { enabled = false },
      --   panel = { enabled = false },
      -- })

      local lspkind = require("lspkind")
      lspkind.init({
        symbol_map = {
          Copilot = "",
        },
      })

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

      local conf = {
        sources = {
          -- { name = "copilot" },
          { name = "buffer" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "vsnip" },
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      }

      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      return conf
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup({--[[ your config ]]
      })
    end,
  },
})
