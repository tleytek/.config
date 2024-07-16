return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("fidget").setup({})

		local lspconfig = require("lspconfig")

		local mason_lspconfig = require("mason-lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(e)
				-- :help vim.lsp.* if I'm stuck, RTFM
				local opts = { buffer = e.buf, silent = true }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
				vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
			end,
		})

		local capabilities = vim.tbl_deep_extend(
			"force",
			-- {},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

		mason_lspconfig.setup_handlers({
			-- default handler
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			--%["emmet_ls"] = function()
			--%	lspconfig["emmet_ls"].setup({
			--%		capabilities = capabilities,
			--%		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
			--%	})
			--%end,

			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make lsp recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})
			end,

			-- ["eslint"] = function()
			--     local lspconfig = require("lspconfig")
			--     lspconfig.eslint.setup({
			--         capabilities = capabilities,
			--         on_attach = function(_client, bufnr)
			--             vim.api.nvim_create_autocmd("BufWritePre", {
			--                 buffer = bufnr,
			--                 command = "EslintFixAll",
			--             })
			--         end
			--     })
			-- end,
		})
	end,
}
