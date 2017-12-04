minetest.register_node("laptop:core_open", {
	description = "MineTest Core",
	tiles = {
		"laptop_laptop_core_tp_off.png",
		"laptop_laptop_core_bt.png",
		"laptop_laptop_core_rt.png",
		"laptop_laptop_core_lt.png",
		"laptop_laptop_core_bk.png",
		"laptop_laptop_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2,  dig_immediate = 2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:resume("laptop:core_open_on")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:power_off()
		os:set_infotext('MineTest Core')
	end,
	stack_max = 1,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
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
		"laptop_laptop_core_tp.png",
		"laptop_laptop_core_bt.png",
		"laptop_laptop_core_rt.png",
		"laptop_laptop_core_lt.png",
		"laptop_laptop_core_bk.png",
		"laptop_laptop_core_ft_on.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_off("laptop:core_closed")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:power_on()
		os:set_infotext('MineTest Core')
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_receive_fields = function(pos, formname, fields, sender)
		local os = laptop.os_get(pos)
		os:receive_fields(fields, sender)
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
		"laptop_laptop_core_bk_off.png",
		"laptop_laptop_core_bt.png",
		"laptop_laptop_core_rt_off.png",
		"laptop_laptop_core_lt_off.png",
		"laptop_laptop_core_r_off.png",
		"laptop_laptop_core_ft_off.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:core_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_off("laptop:core_open")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
--		os.custom_launcher = 'stickynote'
		os:power_off()
		os:set_infotext('MineTest Core')
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
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
		"laptop_monitor_core_bt.png",
		"laptop_laptop_core_bt.png",
		"laptop_monitor_core_rt.png",
		"laptop_monitor_core_lt.png",
		"laptop_monitor_core_bk.png",
		"laptop_monitor_core_ft_on.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_off("laptop:monitor_off")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:power_on()
		os:set_infotext('MT Desktop')
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_receive_fields = function(pos, formname, fields, sender)
		local os = laptop.os_get(pos)
		os:receive_fields(fields, sender)
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
		"laptop_monitor_core_bt.png",
		"laptop_laptop_core_bt.png",
		"laptop_monitor_core_rt.png",
		"laptop_monitor_core_lt.png",
		"laptop_monitor_core_bk.png",
		"laptop_monitor_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_on("laptop:monitor_on")
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:set_theme("red")
		os:power_off()
		os:set_infotext('MT Desktop')
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
		"laptop_monitor2_core_bt.png",
		"laptop_laptop_core_bt.png",
		"laptop_monitor_core_rt.png",
		"laptop_monitor_core_lt.png",
		"laptop_monitor2_core_bk.png",
		"laptop_monitor2_core_ft_on.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor2_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_off("laptop:monitor2_off")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:set_theme("red")
		os:power_on()
		os:set_infotext('MT Desktop')
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_receive_fields = function(pos, formname, fields, sender)
		local os = laptop.os_get(pos)
		os:receive_fields(fields, sender)
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
		"laptop_monitor2_core_bt.png",
		"laptop_laptop_core_bt.png",
		"laptop_monitor_core_rt.png",
		"laptop_monitor_core_lt.png",
		"laptop_monitor2_core_bk.png",
		"laptop_monitor2_core_ft.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "laptop:monitor2_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_on("laptop:monitor2_on")
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:power_off()
		os:set_infotext('MT Desktop')
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
minetest.register_node("laptop:monitor3_on", {
    description = "MT Desktop vintage 3.0",
	tiles = {
		"laptop_k_top.png^laptop_t_top.png^laptop_p_top.png^laptop_m_top.png",
		"laptop_k_bottom.png^laptop_t_bottom.png^laptop_p_bottom.png^laptop_m_bottom.png",
		"laptop_k_right.png^laptop_t_right.png^laptop_p_right.png^laptop_m_right.png",
		"laptop_k_left.png^laptop_t_left.png^laptop_p_left.png^laptop_m_left.png",
		"laptop_k_back.png^laptop_t_back.png^laptop_p_back.png^laptop_m_back.png",
		"laptop_k_front.png^laptop_t_front_on.png^laptop_p_front.png^laptop_m_front_on.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = 'facedir',
	drop = "laptop:monitor3_off",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_off("laptop:monitor3_off")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:power_on()
		os:set_infotext('MT Desktop')
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_receive_fields = function(pos, formname, fields, sender)
		local os = laptop.os_get(pos)
		os:receive_fields(fields, sender)
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.5, 0.3125, -0.4375, -0.25}, -- keyboard
			{-0.4375, -0.5, -0.1875, 0.4375, -0.3125, 0.4375}, -- tower
			{-0.25, -0.3125, -0.0625, 0.25, -0.25, 0.375}, -- pedestal
			{-0.375, -0.25, -0.125, 0.375, 0.25, 0.4375}, -- monitor
		}
	}
})

minetest.register_node("laptop:monitor3_off", {
    description = "MT Desktop vintage 3.0",
	tiles = {
		"laptop_k_top.png^laptop_t_top.png^laptop_p_top.png^laptop_m_top.png",
		"laptop_k_bottom.png^laptop_t_bottom.png^laptop_p_bottom.png^laptop_m_bottom.png",
		"laptop_k_right.png^laptop_t_right.png^laptop_p_right.png^laptop_m_right.png",
		"laptop_k_left.png^laptop_t_left.png^laptop_p_left.png^laptop_m_left.png",
		"laptop_k_back.png^laptop_t_back.png^laptop_p_back.png^laptop_m_back.png",
		"laptop_k_front.png^laptop_t_front.png^laptop_p_front.png^laptop_m_front.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = 'facedir',
	drop = "laptop:monitor3_off",
	groups = {choppy=2, oddly_breakably_by_hand=2},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:monitor3_on"
		minetest.set_node(pos, node)
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MT Desktop')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.5, 0.3125, -0.4375, -0.25}, -- keyboard
			{-0.4375, -0.5, -0.1875, 0.4375, -0.3125, 0.4375}, -- tower
			{-0.25, -0.3125, -0.0625, 0.25, -0.25, 0.375}, -- pedestal
			{-0.375, -0.25, -0.125, 0.375, 0.25, 0.4375}, -- monitor
		}
	}
})
minetest.register_craft({
	output = 'laptop:monitor3_off',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:copper_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:glass', 'default:steel_ingot'},
	}
})
-- Laptop v2.0
minetest.register_node("laptop:laptop_closed", {
    description = "laptop v2.0",
	tiles = {
		"laptop_lap_base_closed_top.png",
		"laptop_lap_base_closed_bottom.png",
		"laptop_lap_base_closed_right.png",
		"laptop_lap_base_closed_left.png",
		"laptop_lap_base_closed_back.png",
		"laptop_lap_base_closed_front.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = 'facedir',
	drop = "laptop:laptop_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:laptop_open"
		minetest.set_node(pos, node)
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MT Desktop')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.375}, -- base_closed
			
		}
	}
})
minetest.register_node("laptop:laptop_open", {
    description = "laptop v2.0",
	tiles = {
		"laptop_lap_base_open_top.png",
		"laptop_lap_base_open_bottom.png^laptop_lap_sc_open_bottom.png",
		"laptop_lap_base_open_right.png",
		"laptop_lap_base_open_left.png",
		"laptop_lap_base_open_back.png^laptop_lap_sc_open_back.png",
		"laptop_lap_base_open_front.png^laptop_lap_sc_open_front.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = 'facedir',
	drop = "laptop:laptop_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		node.name = "laptop:laptop_open_on"
		minetest.set_node(pos, node)
	end,
	on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string('infotext', 'MT Desktop')
		end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
			{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
			
		}
	}
})
minetest.register_node("laptop:laptop_open_on", {
    description = "laptop v2.0",
	tiles = {
		"laptop_lap_base_open_on_top.png",
		"laptop_lap_base_open_bottom.png^laptop_lap_sc_open_bottom.png",
		"laptop_lap_base_open_right.png",
		"laptop_lap_base_open_left.png",
		"laptop_lap_base_open_back.png^laptop_lap_sc_open_back.png",
		"laptop_lap_base_open_front.png^laptop_lap_sc_open_on_front.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = 'facedir',
	drop = "laptop:laptop_closed",
	groups = {choppy=2, oddly_breakably_by_hand=2, not_in_creative_inventory=1},
	on_punch = function (pos, node, puncher)
		local os = laptop.os_get(pos)
		os:power_off("laptop:laptop_closed")
	end,
	on_construct = function(pos)
		local os = laptop.os_get(pos)
		os:power_on()
		os:set_infotext('MineTest Core')
	end,
	after_place_node = laptop.after_place_node,
	after_dig_node = laptop.after_dig_node,
	stack_max = 1,
	on_receive_fields = function(pos, formname, fields, sender)
		local os = laptop.os_get(pos)
		os:receive_fields(fields, sender)
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
			{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
			
		}
	}
})
minetest.register_craft({
	output = 'laptop:laptop_closed',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:copper_ingot', 'default:copper_ingot', 'default:copper_ingot'},
		{'default:steel_ingot', 'default:glass', 'default:steel_ingot'},
	}
})
