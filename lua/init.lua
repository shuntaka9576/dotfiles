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
vim.api.nvim_set_keymap("n", "<tab>", ":tabnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-tab>", ":tabprevious<CR>", { noremap = true, silent = true })

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

-- lsp keymap
local lsp_on_attach = function(client, bufnr)
  local set = vim.keymap.set
  set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  set("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  set("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
end

----------------------------
-- filetype settings
----------------------------
local extension_list = {
  "ts",
  "pl",
  "lua",
  "c",
  "cpp",
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
vim.api.nvim_command("autocmd BufWritePost *.ts,*.tsx,*.mts,*.rs,*.hs,*.lua,*.toml FormatWrite")
vim.api.nvim_command("autocmd BufWritePost *.scala FormatWrite")
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

----------------------------
-- Package manager settings
----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

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
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
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
              picker = require("window-picker").pick_window({
                hint = "floating-big-letter",
              }),
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
        ensure_installed = "all",
        -- highlight = { enable = true },
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
  -- {
  --   "yuki-yano/fuzzy-motion.vim",
  --   config = function()
  --     vim.keymap.set("n", "f", "<cmd>FuzzyMotion<CR>")
  --     vim.cmd("let g:fuzzy_motion_matchers = ['kensaku', 'fzf']")
  --   end,
  --   -- dependencies = {
  --   --   "lambdalisue/kensaku.vim",
  --   -- },
  -- },
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
  -- {
  --   "ahmedkhalf/project.nvim",
  --   config = function()
  --     require("project_nvim").setup({})
  --   end,
  -- },
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
          javascriptreact = {
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
          typescript = {
            function()
              return { exe = "prettier", args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) }, stdin = true }
            end,
          },
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
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        on_close = function(_)
          local nvim_tree_reloader = require("nvim-tree.actions.reloaders")
          nvim_tree_reloader.reload_explorer()
        end,
        float_opts = {
          border = "double",
        },
      })
      function _LAZYGIT_TOGGLE()
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
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     messages = {
  --       enabled = true,
  --       view = "mini",
  --       view_error = "mini",
  --       view_warn = "mini",
  --       view_history = "messages",
  --       view_search = false,
  --     },
  --     lsp = {
  --       progress = {
  --         enabled = false,
  --       },
  --     },
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   },
  -- },
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
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
    event = "VeryLazy",
    config = function()
      require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 10, -- columns
            position = "bottom",
          },
        },
      })
    end,
  },
  -- flutter
  {
    "akinsho/flutter-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        -- flutter_path = nil,
        -- flutter_lookup_cmd = "asdf where flutter",
        fvm = true,
        widget_guides = { enabled = true },
        lsp = {
          settings = {
            showtodos = true,
            completefunctioncalls = true,
            analysisexcludedfolders = {
              vim.fn.expand("$Home/.pub-cache"),
            },
            renamefileswithclasses = "prompt",
            updateimportsonrename = true,
            enablesnippets = false,
          },
          on_attach = lsp_on_attach,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          register_configurations = function(paths)
            local dap = require("dap")
            dap.adapters.dart = {
              type = "executable",
              command = paths.flutter_bin,
              args = { "debug-adapter" },
            }
            dap.configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
          end,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })
      lspconfig.jsonls.setup({})
      require("mason").setup()
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local nvim_lsp = require("lspconfig")
          vim.lsp.handlers["textDocument/publishDiagnostics"] =
            vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
              -- update_in_insert = false,
              virtual_text = false,
              -- virtual_text = {
              --   format = function(diagnostic)
              --     return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
              --   end,
              -- },
            })

          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          local opts = {
            capabilities = capabilities,
          }

          if server_name == "tsserver" then
            if file_exists(os.getenv("PWD") .. "/deno.jsonc") then
              return
            end

            opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
          elseif server_name == "eslint" then
            opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
          elseif server_name == "rust_analyzer" then
            -- opts.cmd = { vim.fn.expand("~/.rustup/toolchains/stable-aarch64-apple-darwin/bin/rust-analyzer") }
          elseif server_name == "denols" then
            if file_exists(os.getenv("PWD") .. "/package.json") then
              return
            end

            opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
            opts.settings = {
              deno = {
                suggest = {
                  imports = {
                    hosts = {
                      ["https://deno.land"] = true,
                      ["https://cdn.nest.land"] = true,
                      ["https://crux.land"] = true,
                    },
                  },
                },
              },
            }
          end

          opts.on_attach = lsp_on_attach
          nvim_lsp[server_name].setup(opts)
        end,
      })
    end,
  },
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    version = "^3", -- Recommended
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    init = function()
      vim.g.haskell_tools = {}
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      debug = true,
    },
    opts = function()
      vim.keymap.set("n", "<leader>cA", "<cmd>CopilotChat<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>cS", "<cmd>CopilotChatCommitStaged<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>cC", "<cmd>CopilotChatClose<CR>", { noremap = true, silent = true })
    end,
  },
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
      { "zbirenbaum/copilot-cmp" },
      { "zbirenbaum/copilot.lua" },
      { "onsails/lspkind.nvim" },
    },
    opts = function()
      local cmp = require("cmp")
      require("copilot_cmp").setup()
      -- please setup :Copilot auth
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })

      local lspkind = require("lspkind")
      lspkind.init({
        symbol_map = {
          Copilot = "",
        },
      })

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

      local conf = {
        sources = {
          { name = "copilot" },
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

      return conf
    end,
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        end,
      },
    },
    ft = { "scala", "sbt" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }
      metals_config.init_options.statusBarProvider = "off"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      metals_config.on_attach = lsp_on_attach

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
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
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   ft = { "java" },
  --   opts = function()
  --     local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
  --     local config = {
  --       cmd = { jdtls_bin },
  --       root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
  --     }
  --     require("jdtls").start_or_attach(config)

  --     -- local jdtls_setup = function()
  --     --   local jdtls = require('jdtls')
  --     --   local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
  --     --   -- local root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew"})

  --     --   local config = {
  --     --       cmd = { jdtls_bin },
  --     --       -- root_dir = root_dir,
  --     --       -- on_attach = lsp_on_attach,
  --     --   }
  --     --   jdtls.start_or_attach(config)
  --     -- end

  --     -- vim.api.nvim_create_autocmd('FileType', {
  --     --   -- group = java_cmds,
  --     --   pattern = {'java'},
  --     --   desc = 'Setup jdtls',
  --     --   callback = jdtls_setup,
  --     -- })
  --   end,
  -- },
})
