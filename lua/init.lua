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
  "java",
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
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
        -- conflict winresizer
        -- vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
        vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
        vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
        vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
        vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
        vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
        vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
        vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
        vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
        vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
        vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
        vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
        vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
        vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
        vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
        vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
        vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
        vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
        vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
        vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
        vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
        vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
        -- END_DEFAULT_ON_ATTACH

        -- Mappings migrated from view.mappings.list
        vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))

        vim.keymap.set('n', 'Z', api.node.run.system, opts('Run System'))
      end

      local nvim_tree = require("nvim-tree")
      nvim_tree.setup({
        on_attach = on_attach,
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

  -- conflict coc.nvim <CR> settings
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function()
  --     require("nvim-autopairs").setup({})
  --   end,
  -- },

  -- easy motion
  -- {
  --   "phaazon/hop.nvim",
  --   name = "hop",
  --   config = function()
  --     require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
  --     vim.api.nvim_set_keymap("n", "f", ":HopChar1<CR>", { noremap = true, silent = true })
  --   end,
  -- },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  --   config = function()
  --     require("flash").jump {
  --       mode = vim.fn["kensaku#query"]
  --     }
  --   end,
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
  --     { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
  --     {
  --       "R",
  --       mode = { "o", "x" },
  --       function() require("flash").treesitter_search() end,
  --       desc =
  --       "Treesitter Search"
  --     },
  --     {
  --       "<c-s>",
  --       mode = { "c" },
  --       function() require("flash").toggle() end,
  --       desc =
  --       "Toggle Flash Search"
  --     },
  --   },
  -- },
  {
    "yuki-yano/fuzzy-motion.vim",
    config = function()
      vim.keymap.set('n', 'f', '<cmd>FuzzyMotion<CR>')
      vim.cmd("let g:fuzzy_motion_matchers = ['kensaku', 'fzf']")
    end,
    dependencies = {
      "lambdalisue/kensaku.vim"
    }
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
      require("bufferline").setup({
        options = {
          close_command = "bdelete! %d",
          diagnostics = "coc",
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
          lualine_a = { "g:coc_status", "bo:filetype" },
          lualine_c = { "%=", "%t%m", "%3p" },
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
    lazy = false
  },
  {
    'lambdalisue/kensaku-search.vim',
    lazy = false,
    config = function()
      vim.keymap.set('c', '<CR>', '<Plug>(kensaku-search-replace)<CR>')
    end,
    dependencies = {
      "lambdalisue/kensaku.vim"
    }
  },
  { 'lambdalisue/kensaku.vim', lazy = false },

  {
    "vim-skk/skkeleton",
    config = function()
      vim.cmd([[
call skkeleton#config({ 'globalJisyo': '~/.skk/SKK-JISYO.L' })

imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

call skkeleton#config({
\'eggLikeNewline':v:true
\})

augroup skkeleton-coc
  autocmd!
  autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
  autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
augroup END

call ddc#custom#patch_global('sources', ['skkeleton'])
call ddc#custom#patch_global('sourceOptions', {
    \   '_': {
    \     'matchers': ['matcher_head'],
    \     'sorters': ['sorter_rank']
    \   },
    \   'skkeleton': {
    \     'mark': 'skkeleton',
    \     'matchers': ['skkeleton'],
    \     'sorters': [],
    \     'minAutoCompleteLength': 2,
    \   },
    \ })
call ddc#enable()
]]
      )
    end,
    dependencies = {
      "Shougo/ddc.vim",
      "Shougo/ddc-matcher_head",
      "Shougo/ddc-sorter_rank",
      "Shougo/pum.vim",
      "vim-denops/denops.vim",
    }
  },

  {
    "Shougo/pum.vim",
  },

  {
    "Shougo/ddc.vim",
    dependencies = {
      "vim-denops/denops.vim",
    }
  },
  {
    "Shougo/ddc-matcher_head"
  },
  {
    "Shougo/ddc-sorter_rank"
  },

  {
    "shuntaka9576/preview-hozi-dev",
    dependencies = {
      "vim-denops/denops.vim",
    }
  },

  {
    "shuntaka9576/preview-asciidoc.vim",
    dependencies = {
      "vim-denops/denops.vim",
    }
  },

  {
    "shuntaka9576/deno-fmt.vim",
    dependencies = {
      "vim-denops/denops.vim",
    }
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
