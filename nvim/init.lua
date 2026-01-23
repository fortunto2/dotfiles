-- ~/.config/nvim/init.lua

-- === БАЗОВЫЕ НАСТРОЙКИ ===
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"

vim.g.mapleader = " "

-- === LAZY.NVIM (package manager) ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- === ПЛАГИНЫ ===
require("lazy").setup({

  -- Theme - Gruvbox (warm, no blue - для глаз ночью)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = false,
      })
      vim.cmd.colorscheme "gruvbox"
      vim.opt.background = "dark"
    end,
  },

  -- File tree (слева, всегда видно)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,  -- load immediately for Cmd+E from Kitty
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
          -- Single click opens file
          ["<cr>"] = "open",
          -- Copy path to clipboard (English + Russian)
          ["y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path)
            vim.notify("Path copied: " .. path)
          end,
          ["н"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path)
            vim.notify("Path copied: " .. path)
          end,
          -- Copy filename only (English + Russian)
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local name = node.name
            vim.fn.setreg("+", name)
            vim.notify("Name copied: " .. name)
          end,
          ["Н"] = function(state)
            local node = state.tree:get_node()
            local name = node.name
            vim.fn.setreg("+", name)
            vim.notify("Name copied: " .. name)
          end,
        },
      },
      -- Single click to open
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "auto"
          end,
        },
      },
    },
    config = function(_, opts)
      -- Single click opens file
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          vim.keymap.set("n", "<LeftRelease>", function()
            local node = require("neo-tree.sources.manager").get_state("filesystem").tree:get_node()
            if node.type == "file" then
              require("neo-tree.sources.filesystem.commands").open(require("neo-tree.sources.manager").get_state("filesystem"))
            end
          end, { buffer = true })
        end,
      })
      require("neo-tree").setup(opts)
    end,
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle tree" },
      { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus tree" },
    },
  },

  -- Git signs (изменения в gutter)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gb", gs.blame_line, "Blame line")
        map("n", "<leader>gd", gs.diffthis, "Diff this")
      end,
    },
  },

  -- Git diff viewer
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Git diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    },
    opts = {},
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
    },
    opts = {},
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "gruvbox" },
      sections = {
        lualine_b = { "branch", "diff", "diagnostics" },
      },
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Comments (gcc - comment line, gc - selection)
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment line" },
      { "gc", mode = "v", desc = "Comment selection" },
    },
    opts = {},
  },

  -- Syntax highlighting (Tree-sitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter",
    opts = {
      ensure_installed = {
        "json", "jsonc",
        "python",
        "swift",
        "typescript", "tsx", "javascript",
        "html", "css", "scss",
        "lua",
        "bash",
        "yaml", "toml",
        "markdown", "markdown_inline",
        "vim", "vimdoc",
        "go", "rust",
        "sql",
        "dockerfile",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
  },

})

-- === KEYMAPS ===
local map = vim.keymap.set

-- Save / Quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>x", "<cmd>x<cr>", { desc = "Save & quit" })

-- Splits navigation
map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Down split" })
map("n", "<C-k>", "<C-w>k", { desc = "Up split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Quick quit (nvim = preview mode) - English + Russian
map("n", "q", "<cmd>qa!<cr>", { desc = "Quit all" })
map("n", "й", "<cmd>qa!<cr>", { desc = "Quit all (RU)" })
map("n", "<C-c>", "<cmd>qa!<cr>", { desc = "Quit all" })

-- Better indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Открыть дерево при старте если открыта директория
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd("Neotree show")
    end
  end,
})
