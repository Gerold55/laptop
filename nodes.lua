minetest.register_node("laptop:core_open", {
    description = "MineTest Core",
	tiles = {
		"laptop_core_tp.png",
		"laptop_core_bt.png",
		"laptop_core_rt.png",
		"laptop_core_lt.png",
		"laptop_core_bk.png",
		"laptop_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:core_closed"
		minetest.set_node(pos, node)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty('storage') and inv:is_empty('storage1')
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('main', 8*4)
		inv:set_size('storage', 3*3)
		meta:set_string('formspec',
			'size [15,10]'..
			'bgcolor[#00000000;false]'..
			'background[4,4;0,0;os_main.png;true]')
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
			{-0.4375, -0.375, 0.3125, 0.4375, 0.375, 0.4375}, -- NodeBox2
		}
	}
})

minetest.register_node("laptop:core_closed", {
    description = "MineTest Core",
	tiles = {
		"laptop_core_bk_off.png",
		"laptop_core_bt.png",
		"laptop_core_rt_off.png",
		"laptop_core_lt_off.png",
		"laptop_core_r_off.png",
		"laptop_core_ft_off.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:core_open"
		minetest.set_node(pos, node)
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
			{-0.4375, -0.375, -0.4375, 0.4375, -0.25, 0.4375}, -- NodeBox2
		}
	}
})

