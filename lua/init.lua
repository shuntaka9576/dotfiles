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

-- devlopment plugin
vim.api.nvim_set_keymap("n", "<leader>r", ":luafile dev/init.lua<cr>", { noremap = true, silent = false })

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
vim.api.nvim_command("autocmd BufWritePre *.ts,*.tsx :Prettier")
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
vim.api.nvim_command("set cmdheight=1")
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
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
    config = function()
      vim.cmd([[
        " nodeのPATHを指定
        let g:os = substitute(system('arch -arm64e uname'), '\n', '', '')
        let g:arch = substitute(system('arch -arm64e uname -m'), '\n', '', '')
        if g:os ==# 'Darwin' && g:arch ==# 'x86_64'
          let g:coc_node_path = expand('~/.anyenv/envs/nodenv/shims/node')
        elseif g:os ==# 'Darwin' && g:arch ==# 'arm64'
          let g:coc_node_path = expand('~/.anyenv/envs/nodenv/shims/node')
        endif

        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
        " Make <CR> to accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " リファクタリング機能
        nmap <silent>gr <Plug>(coc-rename)
        " コードジャンプ
        nmap <silent>gd <Plug>(coc-definition)
        " 型情報の表示
        nmap <silent>gy <Plug>(coc-type-definition)
        " 実装の表示
        nmap <silent>gi <Plug>(coc-implementation)
        " リファレンス表示
        nmap <silent>gf <Plug>(coc-references)
        " diagnosticジャンプ
        nmap <silent><C-n> <Plug>(coc-diagnostic-next)
        nmap <silent><C-p> <Plug>(coc-diagnostic-prev)
        " 警告の一覧表示
        nnoremap <silent><space>a :<C-u>CocList diagnostics<cr>
        nnoremap <silent><space>t :CocList floaterm<CR>
        command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
      ]])
    end,
  },

  { "mattn/vim-goimports", lazy = true },

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
        command! D execute(":lua require'telescope.builtin'.live_grep{ vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden' } }")
      ]])
    end,
  },

  {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    opt = true,
    event = { "VimEnter" },
    config = function()
      local nvim_tree = require("nvim-tree")
      nvim_tree.setup({
        vim.api.nvim_set_keymap("n", "<Leader>d", ":NvimTreeToggle<CR>", { noremap = true, silent = true }),
        view = {
          mappings = {
            list = {
              { key = "<C-e>", action = "" },
            },
          },
        },
      })
      vim.g.nvim_tree_refresh_wait = 100
      nvim_tree.open()
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
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  {
    "phaazon/hop.nvim",
    name = "hop",
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      vim.api.nvim_set_keymap("n", "f", ":HopChar1<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
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

  { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  { "simeji/winresizer" },

  { "kyazdani42/nvim-web-devicons" },
  {
    "akinsho/bufferline.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      vim.opt.termguicolors = true

      local groups = require("bufferline.groups")

      require("bufferline").setup({
        options = {
          close_command = "bdelete! %d",
          diagnostics = "coc",
          diagnostics_indicator = function(count, level, _, _)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = { { filetype = "NvimTree" } },
          groups = {
            options = {
              toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
            },
            items = {
              groups.builtin.ungrouped,
              {
                name = "Docs",
                auto_close = true,
                matcher = function(buf)
                  return buf.filename:match("%.md")
                end,
              },
            },
          },
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
          lualine_a = { "g:coc_status", "bo:filetype" },
          lualine_c = { "%=", "%t%m", "%3p" },
        },
      })
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    "vim-denops/denops.vim"
  },

  {
    "shuntaka9576/preview-hozi-dev"
  },

  {
    "ziglang/zig.vim",
    config = function()
      vim.cmd([[
        let g:zig_fmt_autosave = 1
      ]])
    end,
  }
})
