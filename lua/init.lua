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

-- vim.api.nvim_set_keymap("n", "<Space>a",
--                         "<cmd>Telescope lsp_workspace_diagnostics<cr>",
--                         {noremap = true, silent = true})
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
      ]])
      vim.cmd([[command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument]])
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
      { "nvim-telescope/telescope-fzy-native.nvim" },
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
      require("telescope").load_extension("fzy_native")
      -- require("telescope").load_extension("neoclip")

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
      -- vim.api.nvim_set_keymap("i", "<C-j><C-n>", "<cmd>Telescope neoclip<cr>",
      --                         {noremap = true, silent = true})
      -- vim.api.nvim_set_keymap("n", "<C-j><C-n>", "<cmd>Telescope neoclip<cr>",
      --                         {noremap = true, silent = true})
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
        ensure_installed = "maintained",
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

  -- use({ "neovim/nvim-lspconfig" })

  -- autocomplete plugin
  use({
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
  })
  use({ "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" })
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

  -- -- formatter plugin
  -- use {
  --  "mhartington/formatter.nvim",
  --  config = function()

  --    require("formatter").setup({
  --      filetype = {
  --        lua = {
  --          function()
  --            return {exe = "lua-format", args = {}, stdin = true}
  --          end
  --        },
  --        go = {
  --          function()
  --            return {
  --              exe = "goimports",
  --              args = {vim.api.nvim_buf_get_name(0)},
  --              stdin = true
  --            }
  --          end
  --        },
  --        rust = {
  --          function()
  --            return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
  --          end
  --        }
  --      }
  --    })
  --    vim.api.nvim_exec([[
  --      augroup FormatAutogroup
  --        autocmd!
  --        autocmd BufWritePost *.lua,*.go,*.rs FormatWrite
  --      augroup END
  --      ]], true)
  --  end
  -- }

  -- term plugin
  use({
    "akinsho/toggleterm.nvim",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = { border = "double" },
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function(_)
          -- Allow nvim-tree to detect changes in lazygit immediately
          local nvim_tree = require("nvim-tree")
          nvim_tree.refresh()
        end,
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

  -- GitHub utility
  use({
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
  })

  -- debug tool
  -- TODO setting
  use({ "mfussenegger/nvim-dap" })
  use({ "jbyuki/one-small-step-for-vimkind" })

  use({ "shuntaka9576/preview-asciidoc.nvim", run = "yarn install" })
  use({ "shuntaka9576/preview-swagger.nvim", run = "yarn install" })
  --[[ preview markdown
  use {"ellisonleao/glow.nvim"}
  use {"shuntaka9576/bufpreview.vim", requires = {{"vim-denops/denops.vim"}}}
  use {
    "alvarosevilla95/luatab.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("luatab").setup({}) end
  }
  --]]

  -- regexp search and replace word
  use({
    "windwp/nvim-spectre",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("spectre").setup({})
    end,
  })

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
          diagnostics = "nvim_lsp",
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

  -- null-ls
  -- use({
  --   "jose-elias-alvarez/null-ls.nvim",
  --   config = function()
  --     local null_ls = require("null-ls")
  --     local sources = {
  --       null_ls.builtins.formatting.eslint,
  --       null_ls.builtins.formatting.prettier,
  --       null_ls.builtins.formatting.stylua,
  --       null_ls.builtins.diagnostics.eslint,
  --     }
  --     null_ls.setup({ debug = false, sources = sources })
  --   end,
  -- })

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  })

  ---[[
  use({
    "NTBBloodbath/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Highlight request on run
        highlight = { enabled = true, timeout = 150 },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
      })
    end,
  })

  use({ "MunifTanjim/nui.nvim" })
  -- ]]

  use({ "hozi-dev/preview-hozi-dev.nvim", run = "yarn install" })

  -- If you want to automatically install and set up packer.nvim on any machine you clone your configuration to, add the following snippet
  if packer_bootstrap then
    packer.sync()
  else
    -- start up packer sync disable
    -- packer.sync()
  end
end)

----------------------------
-- autocomplete settings
----------------------------
-- local cmp = require("cmp")
--
-- cmp.setup({
--   snippet = {
--     -- REQUIRED - you must specify a snippet engine
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--       -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--       -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--       -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--     end,
--   },
--   mapping = {
--     ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
--     ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
--     ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--     ["<C-y>"] = cmp.config.disable,
--     ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
--     ["<CR>"] = cmp.mapping.confirm({ select = true }),
--   },
--   sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "vsnip" } }, { { name = "buffer" } }),
--   experimental = { ghost_text = true },
-- })
--
-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
--
-- cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
-- cmp.setup.cmdline(":", {
--   sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
-- })

----------------------------
-- nvim-lspconfig settings
----------------------------
-- local nvim_lsp = require("lspconfig")
--
-- local on_attach = function(client, bufnr)
--   if client.name == "tsserver" then
--     client.resolved_capabilities.document_formatting = false
--   end
--
--   local function buf_set_keymap(...)
--     vim.api.nvim_buf_set_keymap(bufnr, ...)
--   end
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
--
--   local opts = { noremap = true, silent = true }
--
--   buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--   buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
--   buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--   buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
--   buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
--   buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
--   buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
--   buf_set_keymap("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--   buf_set_keymap("n", "<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
--   buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
--   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
--   vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
--   -- vim.api.nvim_set_keymap("n", "<leader>f", ":Format<cr>",
--   --                         {noremap = true, silent = false})
-- end
--
-- local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
--
-- local servers = { "sumneko_lua", "pyright", "tsserver", "denols", "rls", "gopls", "tailwindcss" }
--
-- for _, lsp in ipairs(servers) do
--   if lsp == "sumneko_lua" then
--     local sumneko_root_path = os.getenv("HOME") .. "/repos/github.com/sumneko/lua-language-server"
--     local sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"
--
--     local runtime_path = vim.split(package.path, ";")
--     table.insert(runtime_path, "lua/?.lua")
--     table.insert(runtime_path, "lua/?/init.lua")
--
--     nvim_lsp[lsp].setup({
--       on_attach = on_attach,
--       flags = { debounce_text_changes = 150 },
--       capabilities = capabilities,
--       cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
--       settings = {
--         Lua = {
--           runtime = { version = "LuaJIT", path = runtime_path },
--           diagnostics = { enable = true, globals = {} },
--           workspace = { library = vim.api.nvim_get_runtime_file("", true) },
--           telemetry = { enable = false },
--         },
--       },
--     })
--   elseif lsp == "pyright" then
--     nvim_lsp[lsp].setup({
--       on_attach = on_attach,
--       flags = { debounce_text_changes = 150 },
--       capabilities = capabilities,
--       settings = {
--         python = { venvPath = ".venv", pythonPath = ".venv/bin/python" },
--       },
--     })
--   elseif lsp == "rls" then
--     nvim_lsp[lsp].setup({
--       on_attach = on_attach,
--       flags = { debounce_text_changes = 150 },
--       capabilities = capabilities,
--       settings = {
--         rust = {
--           unstable_features = true,
--           build_on_save = false,
--           all_features = true,
--         },
--       },
--     })
--   elseif lsp == "gopls" then
--     nvim_lsp[lsp].setup({
--       on_attach = on_attach,
--       flags = { debounce_text_changes = 150 },
--       capabilities = capabilities,
--     })
--   elseif lsp == "tailwindcss" then
--     nvim_lsp[lsp].setup({
--       on_attach = on_attach,
--       flags = { debounce_text_changes = 150 },
--       capabilities = capabilities,
--     })
--   elseif lsp == "denols" or "tsserver" then
--     local package_json_file = require("plenary.path"):new("package.json")
--     local is_ts = package_json_file:exists()
--
--     if is_ts then
--       nvim_lsp["tsserver"].setup({
--         on_attach = on_attach,
--         flags = { debounce_text_changes = 150 },
--         capabilities = capabilities,
--       })
--     else
--       nvim_lsp["denols"].setup({ on_attach = on_attach })
--     end
--   end
-- end
