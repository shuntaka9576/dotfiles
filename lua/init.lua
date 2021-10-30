----------------------------
-- key mapping settings
----------------------------
vim.g.mapleader = ","
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>j', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>k', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>l', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>h', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>r', '<C-w>r', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>w', '<C-w>w', {noremap = true})

-- tab control
vim.api.nvim_set_keymap('n', 'te', ':tabedit<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>', ':tabnext<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-tab>', ':tabprevious<CR>',
                        {noremap = true, silent = true})

-- move when one line is wrapped
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'gk', 'k', {noremap = true})
vim.api.nvim_set_keymap('n', 'gj', 'j', {noremap = true})
vim.api.nvim_set_keymap('n', '<Down>', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', '<Up>', 'gk', {noremap = true})

----------------------------
-- filetype settings
----------------------------
local extension_list = {
  "ts", "pl", "lua", "c", "cpp", "tsx", "html", "css", "scss", "md", "go",
  "vim", "yml", "toml", "dart", "mjs"
}
vim.api.nvim_command('augroup MyTabStop')
vim.api.nvim_command('autocmd!')
for i = 1, #extension_list do
  vim.api.nvim_command('autocmd BufNewFile,BufRead *.' .. extension_list[i] ..
                         ' setlocal tabstop=2 shiftwidth=2 expandtab')
end
vim.api.nvim_command('autocmd BufNewFile,BufRead Makefile setlocal noexpandtab')
vim.api.nvim_command('augroup END')

----------------------------
-- display content settings
----------------------------
-- visualize line number
vim.api.nvim_command('set number')
-- visualize control characters
vim.api.nvim_command('set list')
-- control characters setting char
vim.api.nvim_command(
  'set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲,trail:~')
-- display vertical and horizontal cursors
vim.api.nvim_command('set cursorline')
vim.api.nvim_command('set cursorcolumn')
-- clear search result
vim.api.nvim_set_keymap('n', '<Space><Space>', ':nohlsearch<CR><Esc>',
                        {noremap = true, silent = true})

----------------------------
-- other settings
----------------------------
-- save yank results to clipboard
vim.api.nvim_command('set clipboard+=unnamed')

----------------------------
-- Package manager settings
----------------------------
vim.cmd [[packadd packer.nvim]]
local use = require('packer').use

require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  -- fuzzy finder plugin
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}},
    config = function()
      vim.api.nvim_set_keymap("n", "<C-j><C-p>",
                              ":lua require('telescope.builtin').find_files()<CR>",
                              {noremap = true, silent = true})
      vim.api.nvim_set_keymap("n", "<C-j><C-d>",
                              ":lua require('telescope.builtin').live_grep()<CR>",
                              {noremap = true, silent = true})
      vim.api.nvim_set_keymap("n", "<C-j><C-b>",
                              ":lua require('telescope.builtin').buffers()<CR>",
                              {noremap = true, silent = true})
    end

  }

  -- file explorer  plugin
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup {
        vim.api.nvim_set_keymap('n', '<Leader>d', ':NvimTreeToggle<CR>',
                                {noremap = true, silent = true}),
        vim.api.nvim_set_keymap('n', '<Leader>r', ':NvimTreeRefresh<CR>',
                                {noremap = true, silent = true})
      }
      -- key mapping
      -- local tree_cb = require('nvim-tree.config').nvim_tree_callback
      -- local list = {
      --   {},
      -- }
    end
  }
  -- color theme and syntax plugin
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {ensure_installed = "maintained"}
    end
  }
  use {
    'folke/tokyonight.nvim',
    config = function() vim.cmd [[colorscheme tokyonight]] end
  }
  use {'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer'}
  -- autocomplete plugin
  use {
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline", "hrsh7th/nvim-cmp"
  }
  use {'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip'}
  use {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup {} end
  }

  -- easy-motion like plugin
  use {
    'phaazon/hop.nvim',
    as = 'hop',
    config = function()
      require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'}
      vim.api.nvim_set_keymap('n', 'f', ':HopChar1<CR>',
                              {noremap = true, silent = true})
    end
  }

  -- seamless navigation between tmux panes and vim splits plugin
  use {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true -- defaults to false
      }

      vim.api.nvim_set_keymap('n', "<C-w>j",
                              ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<CR>",
                              {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', "<C-w>k",
                              ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<CR>",
                              {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', "<C-w>l",
                              ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<CR>",
                              {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', "<C-w>h",
                              ":lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<CR>",
                              {noremap = true, silent = true})

    end
  }

  -- formatter plugin
  use {
    "mhartington/formatter.nvim",
    config = function()
      require('formatter').setup({
        filetype = {
          lua = {
            function()
              return {exe = "lua-format", args = {}, stdin = true}
            end
          }
        }
      })
      vim.api.nvim_exec([[
        augroup FormatAutogroup
          autocmd!
          autocmd BufWritePost *.lua FormatWrite
        augroup END
        ]], true)
    end
  }

  -- term plugin
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({cmd = "lazygit", hidden = true})

      function _lazygit_toggle() lazygit:toggle() end

      vim.api.nvim_set_keymap("n", "<leader>g",
                              "<cmd>lua _lazygit_toggle()<CR>",
                              {noremap = true, silent = true})
    end
  }
end)

----------------------------
-- nvim-lspconfig settings
----------------------------
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}

  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa',
                 '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr',
                 '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl',
                 '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                 opts)
  -- buf_set_keymap('n', '<space>D',
  --             '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
  -- opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<space>e',
  --                '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
  --                opts)
  buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                 opts)
  -- buf_set_keymap('n', '<C-N>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
  -- opts)
  buf_set_keymap('n', '<space>q',
                 '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

----------------------------
-- autocomplete settings
----------------------------
local cmp = require('cmp')

cmp.setup({
  snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
    ['<CR>'] = cmp.mapping.confirm({select = true})
  },
  sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}},
                               {{name = 'buffer'}}),
  experimental = {ghost_text = true}
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                   .protocol
                                                                   .make_client_capabilities())

-- nvim-cmp and lsp settings
local lspconfig = require('lspconfig')
lspconfig['tsserver'].setup {capabilities = capabilities}
lspconfig['pylsp'].setup {capabilities = capabilities}
-- sumeneko_lua does not read .luacheckrc. Disables warnings, luacheck does otherwise
lspconfig['sumneko_lua'].setup {
  capabilities = capabilities,
  settings = {Lua = {diagnostics = {enable = false}}}
}
lspconfig['clangd'].setup {capabilities = capabilities}