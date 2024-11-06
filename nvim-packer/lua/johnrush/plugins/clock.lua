require("clock").setup({
	timeout_duration = 3000,
	title_pos = "left",
	timer_opts = {
		timer_duration = 10,
		--[[ timer_duration_selections = {
			300, -- 5 Minutes
			600, -- 10 Minutes
			900, -- 15 Minutes
			1200, -- 20 Minutes
			1500, -- 25 Minutes
			1800, -- 30 Minutes
			1820, -- 30 Minutes and 20 Seconds
			2400, -- 40 Minutes
			2700, -- 45 Minutes,
			5400, -- 1.5 hours
		}, ]]
	},
})
