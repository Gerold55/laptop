laptop.register_hardware("laptop:core", {
	description = "MineTest Core",
	infotext = 'MineTest Core',
	sequence = { "closed", "open", "open_on" },

	node_defs = {
		["open"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_laptop_core_tp_off.png",
				"laptop_laptop_core_bt.png",
				"laptop_laptop_core_rt.png",
				"laptop_laptop_core_lt.png",
				"laptop_laptop_core_bk.png",
				"laptop_laptop_core_ft.png"
			},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
					{-0.4375, -0.375, 0.3125, 0.4375, 0.375, 0.4375}, -- NodeBox2
				}
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
		},
		["open_on"] = {
			hw_state = "resume",
			tiles = {
				"laptop_laptop_core_tp.png",
				"laptop_laptop_core_bt.png",
				"laptop_laptop_core_rt.png",
				"laptop_laptop_core_lt.png",
				"laptop_laptop_core_bk.png",
				"laptop_laptop_core_ft_on.png"
			},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
					{-0.4375, -0.375, 0.3125, 0.4375, 0.375, 0.4375}, -- NodeBox2
				}
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
		},
		["closed"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_laptop_core_bk_off.png",
				"laptop_laptop_core_bt.png",
				"laptop_laptop_core_rt_off.png",
				"laptop_laptop_core_lt_off.png",
				"laptop_laptop_core_r_off.png",
				"laptop_laptop_core_ft_off.png"
			},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, -- NodeBox1
					{-0.4375, -0.375, -0.4375, 0.4375, -0.25, 0.4375}, -- NodeBox2
				}
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
		}
	}
})

laptop.register_hardware("laptop:monitor", {
	description = "MT Desktop",
	infotext = "MT Desktop",
	sequence = { "off", "on"},
	custom_theme = "red",
	node_defs = {
		["on"] = {
			hw_state = "power_on",
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
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.25, 0.4375, -0.4375, 0.25}, -- NodeBox4
					{-0.125, -0.4375, -0.0625, 0.125, -0.375, 0.0625}, -- NodeBox7
					{-0.4375, -0.375, -0.125, 0.4375, 0.375, 0.125}, -- NodeBox8
					{-0.4375, -0.5, -0.5, 0.25, -0.4375, -0.3125}, -- NodeBox9
					{0.3125, -0.5, -0.5, 0.4375, -0.4375, -0.3125}, -- NodeBox10
				}
			},
		},
		["off"] = {
			hw_state = "power_off",
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
		}
	}
})

laptop.register_hardware("laptop:monitor2", {
	description = "MT Desktop 2.0",
	infotext = "MT Desktop 2.0",
	sequence = { "off", "on"},
	node_defs = {
		["on"] = {
			hw_state = "power_on",
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
		},
		["off"] = {
			hw_state = "power_off",
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
		}
	}
})


laptop.register_hardware("laptop:monitor4", {
	description = "Bell CrossOver",
	infotext = "Bell CrossOver",
	sequence = { "off", "on"},
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			tiles = {
				"laptop_opti_pc_top.png^laptop_opti_kb_top.png^laptop_opti_ms_top.png^laptop_opti_lcb_top.png^laptop_opti_lcp_top.png^laptop_opti_lcd_top.png",
				"laptop_opti_pc_bottom.png^laptop_opti_kb_bottom.png^laptop_opti_ms_bottom.png^laptop_opti_lcd_bottom.png",
				"laptop_opti_pc_right.png^laptop_opti_kb_right.png^laptop_opti_ms_right.png^laptop_opti_lcb_right.png^laptop_opti_lcp_right.png^laptop_opti_lcd_right.png",
				"laptop_opti_pc_left.png^laptop_opti_kb_left.png^laptop_opti_ms_left.png^laptop_opti_lcb_left.png^laptop_opti_lcp_left.png^laptop_opti_lcd_left.png",
				"laptop_opti_pc_back.png^laptop_opti_kb_back.png^laptop_opti_ms_back.png^laptop_opti_lcb_back.png^laptop_opti_lcp_back.png^laptop_opti_lcd_back.png",
				"laptop_opti_pc_on_front.png^laptop_opti_kb_front.png^laptop_opti_ms_front.png^laptop_opti_lcb_front.png^laptop_opti_lcp_front.png^laptop_opti_lcd_on_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.0625, 0.375, -0.3125, 0.4375}, -- tower
					{-0.4375, -0.5, -0.4375, 0.25, -0.4375, -0.1875}, -- keboard
					{0.3125, -0.5, -0.375, 0.4375, -0.4375, -0.1875}, -- mouse
					{-0.25, -0.3125, 0.0625, 0.25, -0.25, 0.3125}, -- lcd_base
					{-0.0625, -0.25, 0.1875, 0.0625, 0.0625, 0.25}, -- lcd_pedestal
					{-0.4375, -0.125, 0.125, 0.4375, 0.4375, 0.1875}, -- lcd_main
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_opti_pc_top.png^laptop_opti_kb_top.png^laptop_opti_ms_top.png^laptop_opti_lcb_top.png^laptop_opti_lcp_top.png^laptop_opti_lcd_top.png",
				"laptop_opti_pc_bottom.png^laptop_opti_kb_bottom.png^laptop_opti_ms_bottom.png^laptop_opti_lcd_bottom.png",
				"laptop_opti_pc_right.png^laptop_opti_kb_right.png^laptop_opti_ms_right.png^laptop_opti_lcb_right.png^laptop_opti_lcp_right.png^laptop_opti_lcd_right.png",
				"laptop_opti_pc_left.png^laptop_opti_kb_left.png^laptop_opti_ms_left.png^laptop_opti_lcb_left.png^laptop_opti_lcp_left.png^laptop_opti_lcd_left.png",
				"laptop_opti_pc_back.png^laptop_opti_kb_back.png^laptop_opti_ms_back.png^laptop_opti_lcb_back.png^laptop_opti_lcp_back.png^laptop_opti_lcd_back.png",
				"laptop_opti_pc_front.png^laptop_opti_kb_front.png^laptop_opti_ms_front.png^laptop_opti_lcb_front.png^laptop_opti_lcp_front.png^laptop_opti_lcd_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.0625, 0.375, -0.3125, 0.4375}, -- tower
					{-0.4375, -0.5, -0.4375, 0.25, -0.4375, -0.1875}, -- keboard
					{0.3125, -0.5, -0.375, 0.4375, -0.4375, -0.1875}, -- mouse
					{-0.25, -0.3125, 0.0625, 0.25, -0.25, 0.3125}, -- lcd_base
					{-0.0625, -0.25, 0.1875, 0.0625, 0.0625, 0.25}, -- lcd_pedestal
					{-0.4375, -0.125, 0.125, 0.4375, 0.4375, 0.1875}, -- lcd_main
				}
			}
		}
	}
})

minetest.register_craft({
	output = 'laptop:monitor4_off',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:glass', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:gold_ingot', 'default:steel_ingot'},
	}
})

--Old PC--
laptop.register_hardware("laptop:monitor3", {
	description = "MT Desktop vintage 3.0",
	infotext = "MT Desktop vintage 3.0",
	sequence = { "off", "on"},
	node_defs = {
		["on"] = {
			hw_state = "power_on",
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
			node_box = {
				type = "fixed",
				fixed = {
					{-0.3125, -0.5, -0.5, 0.3125, -0.4375, -0.25}, -- keyboard
					{-0.4375, -0.5, -0.1875, 0.4375, -0.3125, 0.4375}, -- tower
					{-0.25, -0.3125, -0.0625, 0.25, -0.25, 0.375}, -- pedestal
					{-0.375, -0.25, -0.125, 0.375, 0.25, 0.4375}, -- monitor
				}
			}
		},
		["off"] = {
			hw_state = "power_on",
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
			node_box = {
				type = "fixed",
				fixed = {
					{-0.3125, -0.5, -0.5, 0.3125, -0.4375, -0.25}, -- keyboard
					{-0.4375, -0.5, -0.1875, 0.4375, -0.3125, 0.4375}, -- tower
					{-0.25, -0.3125, -0.0625, 0.25, -0.25, 0.375}, -- pedestal
					{-0.375, -0.25, -0.125, 0.375, 0.25, 0.4375}, -- monitor
				}
			}
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
laptop.register_hardware("laptop:laptop", {
	description = "laptop v2.0",
	infotext = "laptop v2.0",
	sequence = { "closed", "open", "open_on"},
	node_defs = {
		["closed"] = {
			hw_state = "power_off",
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
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.375}, -- base_closed
				}
			}
		},
		["open"] = {
			hw_state = "power_off",
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
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				}
			}
		},
		["open_on"] = {
			hw_state = "resume",
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
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				}
			}
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

