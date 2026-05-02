-- -- -- -- Leader keys
-- <leader> é uma tecla "prefixo" para atalhos personalizados.
-- Aqui estamos usando espaço.
--
-- Exemplo:
-- <leader>f = Space + f
-- <leader>rn = Space + r + n
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- -- -- -- Opções básicas de interface
-- Mostra o número absoluto da linha atual.
vim.opt.number = true
-- Mostra números relativos nas outras linhas.
vim.opt.relativenumber = true
-- Usa o clipboard do sistema.
-- Permite copiar/colar entre Neovim e outros programas.
-- Requer suporte do sistema, por exemplo xclip/wl-clipboard dependendo do ambiente.
vim.opt.clipboard = "unnamedplus"
-- Show line/column position
vim.opt.ruler = true
-- Show vertical ruler at column 80
vim.opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#B3B3B3" })
-- Quebra linhas longas visualmente
vim.opt.wrap = true
-- Mantém a indentação visual nas linhas quebradas
vim.opt.breakindent = true
-- Evita quebrar palavras no meio, quebra na última palavra possível
vim.opt.linebreak = true


-- -- -- -- Indentação
-- Converte Tab em espaços.
vim.opt.expandtab = true
-- Um caractere Tab ocupa visualmente 4 colunas.
vim.opt.tabstop = 4
-- Indentação automática usa 4 espaços.
-- Afeta comandos como >>, << e autoindentação.
vim.opt.shiftwidth = 4
-- No modo insert, Tab insere 4 espaços.
vim.opt.softtabstop = 4
-- Ajuda na indentação automática simples.
vim.opt.smartindent = true


-- -- -- -- Bootstrap lazy.nvim
-- lazy.nvim é o gerenciador de plugins.
--
-- Se ele ainda não existir, este bloco clona o repositório.
-- Depois, adiciona o lazy.nvim ao runtime path do Neovim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- -- -- -- Plugins com lazy.nvim
require("lazy").setup({
  -- Tema lackluster.
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("lackluster")
      vim.opt.colorcolumn = "80"

      vim.api.nvim_set_hl(0, "ColorColumn", {
      bg = "#303030",
    })
    end,
  },
  -- Configurações prontas de LSP para vários servidores.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  -- Tree-sitter melhora highlight, parsing e suporte estrutural de código.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
  },
  -- Fecha automaticamente pares como: (), {}, [], "" etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },
  -- Completion engine.
  -- Mostra sugestões de LSP, path e buffer no insert mode.
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
      },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },
      completion = {
        menu = {
          auto_show = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
      },
    },
  },
})


-- -- -- -- LSP: C/C++ com clangd
-- clangd é o language server para C/C++.
-- Requer clangd instalado no sistema:
--
-- sudo apt install clangd
vim.lsp.enable("clangd")


-- -- -- -- Diagnostics: erros e warnings do LSP
vim.diagnostic.config({
  -- Mostra ícones na coluna da esquerda.
  signs = true,
  -- Mostra underline no trecho com problema.
  underline = true,
  -- Atualiza diagnostics enquanto você digita.
  update_in_insert = false,
  -- Não mostra texto inline o tempo todo.
  -- Evita poluir a tela, principalmente em terminal de 80 colunas.
  virtual_text = false,
  -- Ordena por severidade.
  severity_sort = true,
  -- Janela flutuante com borda arredondada.
  float = {
    border = "rounded",
    source = true,
    max_width = 80,
    wrap = true,
  },
})


-- -- -- -- Keymaps do LSP
-- Mostra diagnostics da linha atual em um popup.
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, {
    border = "rounded",
    source = true,
    max_width = 80,
    wrap = true,
  })
end, {
  desc = "Show line diagnostic",
})
-- Vai para a definição do símbolo embaixo do cursor.
-- Exemplo: função, variável, classe, método.
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  desc = "Go to definition",
})
-- Mostra referências do símbolo embaixo do cursor.
vim.keymap.set("n", "gr", vim.lsp.buf.references, {
  desc = "Go to references",
})
-- Mostra documentação ou informação do símbolo embaixo do cursor.
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({
    border = "rounded",
    max_width = 90,
    max_height = 25,
  })
end, {
  desc = "Hover docs",
})
-- Renomeia símbolo no projeto.
-- Exemplo: renomear uma variável/função/classe com suporte do LSP.
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
  desc = "Rename symbol",
})
-- Mostra ações sugeridas pelo LSP.
-- Exemplo: corrigir include, aplicar fix automático, organizar código etc.
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "Code action",
})
-- Formata o arquivo atual usando o LSP.
-- Para C/C++, normalmente depende de clang-format.
--
-- Uso:
-- Space + f
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({
    async = true,
  })
end, {
  desc = "Format file",
})


-- -- -- -- Tree-sitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c",
    "cpp",
    "lua",
    "vim",
    "markdown",
  },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
