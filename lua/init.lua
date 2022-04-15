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
-- init packer.nvim(first time only)
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = nil
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

-- vim.cmd [[packadd packer.nvim]]
local packer = require("packer")
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "double" })
    end,
  },
})

packer.startup(function(use)
  use({ "wbthomason/packer.nvim" })
  use({
    "neoclide/coc.nvim",
    run = "yarn install --frozen-lockfile",
    config = function()
      vim.cmd([[
        " nodeのPATHを指定
        let g:os = substitute(system('arch -arm64e uname'), '\n', '', '')
        let g:arch = substitute(system('arch -arm64e uname -m'), '\n', '', '')
        if g:os ==# 'Darwin' && g:arch ==# 'x86_64'
          let g:coc_node_path = expand('~/.anyenv/envs/nodenv/shims/node')
        elseif g:os ==# 'Darwin' && g:arch ==# 'arm64'
          let g:coc_node_path = expand('/usr/local/bin/node')
        endif
        " コード補完時にEnterで確定した際に改行しない
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
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
  })

  use({
    "mattn/vim-goimports",
  })

  -- fuzzy finder plugin
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
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
        "<cmd>lua require('telescope.builtin').find_files()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<Space>a",
        "<cmd>Telescope lsp_workspace_diagnostics<cr>",
        { noremap = true, silent = true }
      )
      vim.cmd([[
        command! D execute(":lua require('telescope.builtin').live_grep()")
      ]])
    end,
  })

  -- file explorer plugin
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    ---[[ packer.nvim floating window for sync result cannot be deleted without this setting.
    opt = true,
    event = { "VimEnter" },
    -- ]]
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
  })
  -- color theme and syntax plugin
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = { enable = true },
        -- additional_vim_regex_highlighting = true
      })
    end,
  })

  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  })

  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })

  -- easy-motion like plugin
  use({
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      vim.api.nvim_set_keymap("n", "f", ":HopChar1<CR>", { noremap = true, silent = true })
    end,
  })

  use({
    "lambdalisue/reword.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>R", ":%Reword", { noremap = true, silent = false })
    end,
  })

  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  -- seamless navigation between tmux panes and vim splits plugin
  use({
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
  })

  -- term plugin
  use({
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
  })

  -- Git utility
  use({ "airblade/vim-gitgutter" })
  use({ "tpope/vim-fugitive" })
  use({ "simeji/winresizer" })

  -- preview utils
  use({ "shuntaka9576/preview-asciidoc.nvim", run = "yarn install" })
  use({ "shuntaka9576/preview-swagger.nvim", run = "yarn install" })
  use({ "hozi-dev/preview-hozi-dev.nvim", run = "yarn install" })

  -- tab
  use({ "kyazdani42/nvim-web-devicons" })
  use({
    "akinsho/bufferline.nvim",
    requires = "kyazdani42/nvim-web-devicons",
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
  })

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
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
  })

  if packer_bootstrap then
    packer.sync()
  else
  end
end)
