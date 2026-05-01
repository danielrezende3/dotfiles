-- ============================================================
-- Leader keys
-- ============================================================
-- <leader> é uma tecla "prefixo" para atalhos personalizados.
-- Aqui estamos usando espaço.
--
-- Exemplo:
-- <leader>f = Space + f
-- <leader>rn = Space + r + n
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- ============================================================
-- Opções básicas de interface
-- ============================================================

-- Mostra o número absoluto da linha atual.
vim.opt.number = true

-- Mostra números relativos nas outras linhas.
-- Útil para navegar com comandos como:
-- 5j  -> desce 5 linhas
-- 3k  -> sobe 3 linhas
-- d4j -> deleta até 4 linhas abaixo
vim.opt.relativenumber = true

-- Usa o clipboard do sistema.
-- Permite copiar/colar entre Neovim e outros programas.
-- Requer suporte do sistema, por exemplo xclip/wl-clipboard dependendo do ambiente.
vim.opt.clipboard = "unnamedplus"


-- ============================================================
-- Indentação
-- ============================================================

-- Converte Tab em espaços.
vim.opt.expandtab = true

-- Um caractere Tab ocupa visualmente 4 colunas.
vim.opt.tabstop = 4

-- Indentação automática usa 4 espaços.
-- Afeta comandos como >>, << e autoindentação.
vim.opt.shiftwidth = 4


-- ============================================================
-- Plugins com vim.pack
-- ============================================================
-- vim.pack é o gerenciador de plugins nativo do Neovim 0.12+.
--
-- Ele baixa e carrega plugins diretamente a partir dos repositórios Git.
-- Não precisa de bootstrap manual como lazy.nvim.
--
-- Para atualizar plugins:
-- :lua vim.pack.update()

vim.pack.add({
  -- Tema lackluster.
  {
    src = "https://github.com/slugbyte/lackluster.nvim",
    name = "lackluster.nvim",
  },

  -- Configurações prontas de LSP para vários servidores.
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    name = "nvim-lspconfig",
  },

  -- Tree-sitter melhora highlight, parsing e suporte estrutural de código.
  -- O branch main é o recomendado para Neovim mais novo.
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    version = "main",
  },
})


-- ============================================================
-- Tema
-- ============================================================
-- Define o colorscheme.
-- Precisa vir depois do plugin do tema ser carregado.
vim.cmd.colorscheme("lackluster-mint")


-- ============================================================
-- LSP: C/C++ com clangd
-- ============================================================
-- clangd é o language server para C/C++.
-- Requer clangd instalado no sistema:
-- sudo apt install clangd
vim.lsp.enable("clangd")


-- ============================================================
-- Keymaps do LSP
-- ============================================================

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


-- ============================================================
-- Tree-sitter
-- ============================================================
-- Ativa Tree-sitter automaticamente para alguns tipos de arquivo.
--
-- Isso melhora o highlight e o parsing do código.
-- O pcall evita quebrar o Neovim caso algum parser não esteja instalado.
--
-- Para instalar parsers manualmente:
-- :TSInstall c cpp lua vim vimdoc query markdown markdown_inline
--
-- Para atualizar parsers:
-- :TSUpdate

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
