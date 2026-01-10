local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'


if not vim.uv.fs_stat(lazypath) then
    print('Installing lazy.nvim...')
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
    print('Done.')
end


-- prevent warnings
local vim = vim

vim.opt.rtp:prepend(lazypath)

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- tabs and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- basic search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

-- Behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = 'unnamedplus' -- System clipboard
vim.opt.undofile = true           -- Persistent undo
vim.opt.swapfile = false          -- No swap files
vim.opt.updatetime = 250          -- Faster completion
vim.opt.timeoutlen = 300          -- Faster key sequences

-- netwr
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

--------------------------------------------------------------------------------
-- LSP CONFIGURATION
--------------------------------------------------------------------------------

-- Diagnostic display settings
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = {
        border = 'rounded',
        source = true,
    },
})

-- Common on_attach function for all LSP servers
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, opts)

    -- Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

-- Capabilities for completion

--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------

require('lazy').setup({
    {
        'vyfor/cord.nvim',
        build = ':Cord update',
        -- opts = {}
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup({
                view = { width = 30 },
                filters = { dotfiles = false },
                update_focused_file = { enable = true }
            })
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
            })

            vim.cmd("colorscheme rose-pine")
            color = color or "rose-pine"
            vim.cmd.colorscheme(color)

            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        config = function()
            require("oil").setup({
                default_file_explorer = true,
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },
    -- Transparency (optional, enable if you want)
    {
        'xiyaowong/transparent.nvim',
        lazy = true,
        cmd = { 'TransparentEnable', 'TransparentToggle' },
        event = 'VimEnter',
        config = function() vim.cmd('TransparentEnable') end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    -- Telescope (replaces fzf.vim with better LSP integration)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')

            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        'node_modules/', 'target/', '.git/', '%.class', '%.jar',
                    },
                    mappings = {
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<Esc>'] = actions.close,
                        },
                    },
                    layout_config = {
                        horizontal = { preview_width = 0.55 },
                    },
                },
                pickers = {
                    find_files = { hidden = true },
                    live_grep = { additional_args = function() return { '--hidden' } end },
                },
            })

            telescope.load_extension('fzf')
            telescope.load_extension('ui-select')
        end,
    },
    -- Harpoon (quick file switching)
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('harpoon'):setup()
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false, -- REQUIRED
        build = ":TSUpdate",
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                return
            end

            configs.setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc",
                    "java", "python", "javascript", "typescript",
                    "bash", "json", "yaml",
                    "html", "css", "sql",
                    "go",
                    "markdown", "markdown_inline",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- LSP
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
        },
    },

    -- Git signs in gutter
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local opts = { buffer = bufnr }

                    vim.keymap.set('n', ']g', gs.next_hunk, opts)
                    vim.keymap.set('n', '[g', gs.prev_hunk, opts)
                    vim.keymap.set('n', '<leader>gp', gs.preview_hunk, opts)
                    vim.keymap.set('n', '<leader>gb', gs.blame_line, opts)
                end,
            })
        end,
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = false,
        config = function()
            require('refactoring').setup()
            vim.keymap.set({ "n", "x" }, "<leader>rr",
                function()
                    require('telescope').extensions.refactoring.refactors()
                end)
        end,
        opts = {},
    },
    -- Autopairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup({})
        end,
    },

    -- Comments (gcc to comment line, gc in visual mode)
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    },

    -- Better status line (optional, minimal)
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    -- theme = 'solarized_dark',
                    theme = 'moonfly',
                    component_separators = '',
                    section_separators = '',
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch' },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = { 'diagnostics' },
                    lualine_y = { 'filetype' },
                    lualine_z = { 'location' },
                },
            })
        end,
    },

    -- Which-key (shows available keymaps)
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require('which-key').setup({
                delay = 500, -- Show after 500ms
            })
        end,
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = { 'java' },
        config = function()
            local jdtls = require('jdtls')

            local root_markers = { 'pom.xml', 'build.gradle', 'gradlew', '.git' }
            local root_dir = require('jdtls.setup').find_root(root_markers)
            if not root_dir then
                vim.notify('jdtls: no project root found', vim.log.levels.WARN)
                return
            end

            local home          = vim.loop.os_homedir()
            local workspace_dir = home .. '/.cache/jdtls-workspace/'
                .. vim.fn.fnamemodify(root_dir, ':p:h:t')

            local jdtls_path    = home .. '/.local/share/nvim/mason/packages/jdtls'
            local lombok_path   = home .. '/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar'
            local java21        = home .. '/.sdkman/candidates/java/21.0.5-tem/bin/java'

            if vim.fn.executable(java21) == 0 then
                vim.notify('Java 21 not found at: ' .. java21, vim.log.levels.ERROR)
                return
            end

            local config = {
                cmd = {
                    java21,
                    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                    '-Dosgi.bundles.defaultStartLevel=4',
                    '-Declipse.product=org.eclipse.jdt.ls.core.product',
                    '-Dlog.protocol=true',
                    '-Dlog.level=ALL',
                    '-Xmx2g',
                    '--add-modules=ALL-SYSTEM',
                    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                    '-javaagent:' .. lombok_path,
                    '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
                    '-configuration', jdtls_path .. '/config_linux', -- change for mac/win
                    '-data', workspace_dir,
                },
                root_dir = root_dir,
                settings = {
                    java = {
                        configuration = {
                            updateBuildConfiguration = 'interactive',
                            runtimes = {
                                {
                                    name = 'JavaSE-17',
                                    path = home .. '/.sdkman/candidates/java/17.0.10-tem',
                                    default = true,
                                },
                                {
                                    name = 'JavaSE-21',
                                    path = home .. '/.sdkman/candidates/java/21.0.5-tem',
                                },
                            },
                        },
                        eclipse       = { downloadSources = true },
                        maven         = { downloadSources = true },
                        format        = { enabled = true },
                        completion    = {
                            favoriteStaticMembers = {
                                'org.junit.Assert.*',
                                'org.junit.jupiter.api.Assertions.*',
                                'org.mockito.Mockito.*',
                            },
                        },
                    },
                },
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)

                    local opts = { buffer = bufnr, silent = true }
                    vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, opts)
                    vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, opts)
                    vim.keymap.set('v', '<leader>ev', function() jdtls.extract_variable(true) end, opts)
                    vim.keymap.set('v', '<leader>em', function() jdtls.extract_method(true) end, opts)
                    vim.keymap.set('n', '<leader>tc', jdtls.test_class, opts)
                    vim.keymap.set('n', '<leader>tm', jdtls.test_nearest_method, opts)
                end,
            }

            jdtls.start_or_attach(config)
        end,
    }
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Mason setup
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'basedpyright',
        'jdtls',
        'ts_ls',
        'bashls',
        'jsonls',
        'yamlls',
        'gopls',
        -- java doesnt use mason-lspconfig
    },
    handlers = {
        function(server_name)
            -- Skip jdtls, we handle it separately
            if server_name == 'jdtls' then return end

            require('lspconfig')[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end,

        -- Lua specific settings
        ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            })
        end,
    },
})
vim.lsp.config.gopls = {
    on_attach = on_attach,
    capabilities = capabilities,
}
vim.lsp.config.ts_ls = {
    on_attach = on_attach,
    capabilities = capabilities,
}
--------------------------------------------------------------------------------
-- COMPLETION (nvim-cmp)
--------------------------------------------------------------------------------

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snip]',
                buffer = '[Buf]',
                path = '[Path]',
            })[entry.source.name]
            return vim_item
        end,
    },
})

-- Integrate autopairs with cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

--------------------------------------------------------------------------------
-- KEYMAPS
--------------------------------------------------------------------------------

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize windows
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Buffer navigation
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)
keymap('n', '<leader>bd', ':bdelete<CR>', opts)

-- Clear search highlight
keymap('n', '<Esc>', ':nohlsearch<CR>', opts)

-- Better indenting (stay in visual mode)
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move lines up/down
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
keymap('n', '<C-d>', '<C-d>zz', opts)
keymap('n', '<C-u>', '<C-u>zz', opts)
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)

-- Telescope
local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Grep in project' })
keymap('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
keymap('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
keymap('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
keymap('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
keymap('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
keymap('n', '<leader>fw', builtin.grep_string, { desc = 'Grep word under cursor' })
keymap('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
keymap('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
keymap('n', '<leader><leader>', builtin.find_files, { desc = 'Find files' }) -- Quick access

-- Harpoon
local harpoon = require('harpoon')
keymap('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon add' })
keymap('n', '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
keymap('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
keymap('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
keymap('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
keymap('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
keymap('n', '<C-p>', function() harpoon:list():prev() end, { desc = 'Harpoon prev' })
keymap('n', '<C-n>', function() harpoon:list():next() end, { desc = 'Harpoon next' })

-- Quick file explorer (built-in netrw)
-- keymap('n', '<leader>e', ':Explore<CR>', opts)

-- Terminal
keymap('n', '<leader>tt', ':split | terminal<CR>', { desc = 'Terminal horizontal' })
keymap('n', '<leader>tv', ':vsplit | terminal<CR>', { desc = 'Terminal vertical' })
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', opts) -- Exit terminal mode

-- Quick save and quit
keymap('n', '<leader>w', ':w<CR>', opts)
keymap('n', '<leader>W', ':wa<CR>', opts)
keymap('n', '<leader>x', ':x<CR>', opts)

--------------------------------------------------------------------------------
-- AUTOCOMMANDS
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Auto-create parent directories when saving
autocmd('BufWritePre', {
    group = augroup('auto_create_dir', { clear = true }),
    callback = function()
        if vim.bo.buftype ~= '' then
            return
        end
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})

-- Highlight on yank
autocmd('TextYankPost', {
    group = augroup('highlight_yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Return to last edit position
autocmd('BufReadPost', {
    group = augroup('last_position', { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = mark[1]
        local col = mark[2]
        if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { line, col })
        end
    end,
})

-- Disable auto-commenting on new line
autocmd('BufEnter', {
    group = augroup('no_auto_comment', { clear = true }),
    callback = function()
        vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- Close certain filetypes with just 'q'
autocmd('FileType', {
    group = augroup('close_with_q', { clear = true }),
    pattern = { 'help', 'man', 'qf', 'lspinfo', 'checkhealth' },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', ':close<CR>', { buffer = event.buf, silent = true })
    end,
})

-- Resize splits when window is resized
autocmd('VimResized', {
    group = augroup('resize_splits', { clear = true }),
    callback = function()
        vim.cmd('tabdo wincmd =')
    end,
})
local function format_changed_lines()
    -- Check for gitsigns
    local gs_ok, gitsigns = pcall(require, "gitsigns")
    if not gs_ok then
        vim.notify("gitsigns is required", vim.log.levels.ERROR)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()

    -- Get hunks from gitsigns
    local hunks = gitsigns.get_hunks(bufnr)
    if not hunks or #hunks == 0 then
        -- vim.notify("No changes to format", vim.log.levels.INFO)
        return
    end

    -- Check for LSP range formatting support
    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/rangeFormatting",
    })
    if #clients == 0 then
        -- vim.notify("No LSP with range formatting support", vim.log.levels.WARN)
        return
    end

    -- Collect valid ranges (only hunks with added/changed lines)
    local ranges = {}
    for _, hunk in ipairs(hunks) do
        if hunk.added and hunk.added.count > 0 then
            table.insert(ranges, {
                start_line = hunk.added.start,
                end_line = hunk.added.start + hunk.added.count - 1,
            })
        end
    end

    if #ranges == 0 then
        -- vim.notify("No lines to format (only deletions)", vim.log.levels.INFO)
        return
    end

    -- Sort descending to format bottom-up (preserves line numbers)
    table.sort(ranges, function(a, b)
        return a.start_line > b.start_line
    end)

    -- Format each range
    for _, range in ipairs(ranges) do
        local end_line_text = vim.api.nvim_buf_get_lines(
            bufnr,
            range.end_line - 1,
            range.end_line,
            false
        )[1] or ""

        vim.lsp.buf.format({
            async = false,
            bufnr = bufnr,
            range = {
                ["start"] = { range.start_line, 0 },
                ["end"] = { range.end_line, #end_line_text },
            },
        })
    end

    vim.notify(string.format("Formatted %d hunk(s)", #ranges), vim.log.levels.INFO)
end

-- Create the command
vim.api.nvim_create_user_command("FormatChangedLines", format_changed_lines, {
    desc = "Format only git-changed lines using LSP",
})

-- Optional keymap
vim.keymap.set("n", "<leader>cf", format_changed_lines, { desc = "Format changed lines" })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  callback = function(args)
    local bufnr = args.buf

    -- Check if LSP formatter exists
    if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" }) == 0 then
      return
    end

    -- Try gitsigns for changed-line formatting
    local ok, gitsigns = pcall(require, "gitsigns")
    local hunks = ok and gitsigns.get_hunks(bufnr)

    if hunks and #hunks > 0 then
      -- Format only changed lines (bottom-up to preserve line numbers)
      for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk.added and hunk.added.count > 0 then
          local start_line = hunk.added.start
          local end_line = start_line + hunk.added.count - 1
          local end_col = #(vim.api.nvim_buf_get_lines(bufnr, end_line - 1, end_line, false)[1] or "")

          vim.lsp.buf.format({
            async = false,
            bufnr = bufnr,
            range = {
              ["start"] = { start_line, 0 },
              ["end"] = { end_line, end_col },
            },
          })
        end
      end
    else
      -- No git, new file, or no changes: format entire buffer
      vim.lsp.buf.format({ async = false, bufnr = bufnr })
    end
  end,
})
