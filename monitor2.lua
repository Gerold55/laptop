-- GENERATED CODE
-- Node Box Editor, version 0.9.0
-- Namespace: test

minetest.register_node("test:node_1", {
	tiles = {
		"monitor_core_bt.png",
		"laptop_core_bt.png",
		"monitor_core_rt.png",
		"monitor_core_lt.png",
		"laptop_core_bk.png",
		"monitor_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.3125, 0, 0.4375, 0.375, 0.0625}, -- NodeBox1
			{-0.4375, -0.3125, -0.0625, 0.4375, -0.25, 0}, -- NodeBox2
			{-0.4375, -0.25, -0.0625, -0.375, 0.3125, 0}, -- NodeBox3
			{-0.4375, 0.3125, -0.0625, 0.4375, 0.375, 0}, -- NodeBox4
			{0.375, -0.25, -0.0625, 0.4375, 0.3125, 0}, -- NodeBox5
			{-0.125, -0.4375, 0, 0.125, -0.3125, 0.0625}, -- NodeBox6
			{-0.1875, -0.5, -0.0625, 0.1875, -0.4375, 0.125}, -- NodeBox7
			{-0.5, -0.5, -0.5, 0.25, -0.4375, -0.1875}, -- NodeBox8
			{0.3125, -0.5, -0.5, 0.5, -0.4375, -0.1875}, -- NodeBox9
		}
	}
})

