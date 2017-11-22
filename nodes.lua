minetest.register_node("laptop:core_open", {
    description = "MineTest Core",
	tiles = {
		"laptop_core_tp_off.png",
		"laptop_core_bt.png",
		"laptop_core_rt.png",
		"laptop_core_lt.png",
		"laptop_core_bk.png",
		"laptop_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:core_open_on"
		minetest.set_node(pos, node)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty('storage') and inv:is_empty('storage1')
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MineTest Core')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
			{-0.4375, -0.375, 0.3125, 0.4375, 0.375, 0.4375}, -- NodeBox2
		}
	}
})

minetest.register_node("laptop:core_open_on", {
    description = "MineTest Core",
	tiles = {
		"laptop_core_tp.png",
		"laptop_core_bt.png",
		"laptop_core_rt.png",
		"laptop_core_lt.png",
		"laptop_core_bk.png",
		"laptop_core_ft_on.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
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
			meta:set_string('formspec', laptop.laptop_formspec)
			meta:set_string('infotext', 'MineTest Core')
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
	paramtype2 = "facedir",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:core_open"
		minetest.set_node(pos, node)
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MineTest Core')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
			{-0.4375, -0.375, -0.4375, 0.4375, -0.25, 0.4375}, -- NodeBox2
		}
	}
})

minetest.register_node("laptop:monitor_on", {
    description = "MT Desktop",
	tiles = {
		"monitor_core_bt.png",
		"laptop_core_bt.png",
		"monitor_core_rt.png",
		"monitor_core_lt.png",
		"monitor_core_bk.png",
		"monitor_core_ft_on.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:monitor_off"
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
			meta:set_string('formspec', laptop.laptop_formspec)
			meta:set_string('infotext', 'MT Desktop')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.25, 0.4375, -0.4375, 0.25}, -- NodeBox4
			{-0.125, -0.4375, -0.0625, 0.125, -0.375, 0.0625}, -- NodeBox7
			{-0.4375, -0.375, -0.125, 0.4375, 0.375, 0.125}, -- NodeBox8
			{-0.4375, -0.5, -0.5, 0.25, -0.4375, -0.3125}, -- NodeBox9
			{0.3125, -0.5, -0.5, 0.4375, -0.4375, -0.3125}, -- NodeBox10
		}
	}
})

minetest.register_node("laptop:monitor_off", {
    description = "MT Desktop",
	tiles = {
		"monitor_core_bt.png",
		"laptop_core_bt.png",
		"monitor_core_rt.png",
		"monitor_core_lt.png",
		"monitor_core_bk.png",
		"monitor_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor_off",
	groups = {choppy=2, oddly_breakably_by_hand=2},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:monitor_on"
		minetest.set_node(pos, node)
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MT Desktop')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.25, 0.4375, -0.4375, 0.25}, -- NodeBox4
			{-0.125, -0.4375, -0.0625, 0.125, -0.375, 0.0625}, -- NodeBox7
			{-0.4375, -0.375, -0.125, 0.4375, 0.375, 0.125}, -- NodeBox8
			{-0.4375, -0.5, -0.5, 0.25, -0.4375, -0.3125}, -- NodeBox9
			{0.3125, -0.5, -0.5, 0.4375, -0.4375, -0.3125}, -- NodeBox10
		}
	}
})

minetest.register_node("laptop:monitor2_on", {
    description = "MT Desktop 2.0",
	tiles = {
		"monitor2_core_bt.png",
		"laptop_core_bt.png",
		"monitor_core_rt.png",
		"monitor_core_lt.png",
		"monitor2_core_bk.png",
		"monitor2_core_ft_on.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:monitor2_off"
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
			meta:set_string('formspec', laptop.laptop_formspec)
			meta:set_string('infotext', 'MT Desktop')
		end,
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

minetest.register_node("laptop:monitor2_off", {
    description = "MT Desktop 2.0",
	tiles = {
		"monitor2_core_bt.png",
		"laptop_core_bt.png",
		"monitor_core_rt.png",
		"monitor_core_lt.png",
		"monitor2_core_bk.png",
		"monitor2_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor_off",
	groups = {choppy=2, oddly_breakably_by_hand=2},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:monitor2_on"
		minetest.set_node(pos, node)
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MT Desktop')
		end,
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
