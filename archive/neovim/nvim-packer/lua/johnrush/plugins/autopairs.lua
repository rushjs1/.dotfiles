local autopairs_setup, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_setup then
	return
end

autopairs.setup({
	check_ts = true, -- enable treesitter
	ts_config = {
		lua = { "string" }, -- dont add pairs in lua string treesitter nodes
		javascript = { "template_string" }, -- dont add pairs in javascript template string
		java = false, --dont check treesitter on java
	},
})

local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_setup then
	return
end

local cmp_setup, cmp = pcall(require, "cmp")
if not cmp_setup then
	return
end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

--[[ local ts_autotag_setup, ts_autotag = pcall(require, "nvim-ts-autotag")
if not ts_autotag_setup then
	return
end

ts_autotag.setup({}) ]]
