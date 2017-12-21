laptop.register_hardware("laptop:core", {
	description = "CP Core",
	infotext = 'CP Core',
	sequence = { "closed", "open", "open_on" },
	hw_capabilities = { 'hdd', 'usb', 'net' },
	node_defs = {
		["open"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_lap_car_open_top.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_bottom.png",
				"laptop_lap_car_open_right.png",
				"laptop_lap_car_open_left.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_open_back.png",
				"laptop_lap_car_open_front.png^laptop_lap_car_sc_open_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
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
			light_source = 4,
			tiles = {
				"laptop_lap_car_open_on_top.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_bottom.png",
				"laptop_lap_car_open_right.png",
				"laptop_lap_car_open_left.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_open_back.png",
				"laptop_lap_car_open_front.png^laptop_lap_car_sc_open_on_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				  }
			       }
			    },
		["closed"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_lap_car_closed_top.png",
				"laptop_lap_car_bottom.png",
				"laptop_lap_car_closed_right.png",
				"laptop_lap_car_closed_left.png",
				"laptop_lap_car_closed_back.png",
				"laptop_lap_car_closed_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.375}, -- base_closed
				}
			}
		}
	}
})

laptop.register_hardware("laptop:printer", {
	description = "Flash Printex",
	infotext = 'Flash Printex',
	sequence = { "closed", "open", "open_on" },
	custom_launcher = "printer_launcher",
	hw_capabilities = { "hdd"},
	node_defs = {
		["open"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_printer_top.png",
				"laptop_printer_bottom.png",
				"laptop_printer_right.png",
				"laptop_printer_left.png",
				"laptop_printer_back.png",
				"laptop_printer_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2, laptop_printer = 1},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.125, 0.375, -0.125, 0.3125}, -- core
					{-0.25, -0.5, -0.375, 0.25, -0.4375, -0.125}, -- tray
					{-0.25, -0.125, 0.25, 0.25, 0.125, 0.3125}, -- charger
				}
			}
		},
		["open_on"] = {
			hw_state = "power_on",
			tiles = {
				"laptop_printer_top.png",
				"laptop_printer_bottom.png",
				"laptop_printer_right.png",
				"laptop_printer_left.png",
				"laptop_printer_back.png",
				"laptop_printer_front_on.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {choppy=2, oddly_breakably_by_hand=2, dig_immediate = 2, laptop_printer = 1},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.125, 0.375, -0.125, 0.3125}, -- core
					{-0.25, -0.5, -0.375, 0.25, -0.4375, -0.125}, -- tray
					{-0.25, -0.125, 0.25, 0.25, 0.125, 0.3125}, -- charger
				  }
			       }
			    },
		["closed"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_printer_top.png",
				"laptop_printer_bottom.png",
				"laptop_printer_right.png",
				"laptop_printer_left.png",
				"laptop_printer_back.png",
				"laptop_printer_front_off.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.125, 0.375, -0.125, 0.3125}, -- core
					{-0.25, -0.5, -0.375, 0.25, -0.4375, -0.125}, -- tray
					{-0.25, -0.125, 0.25, 0.25, 0.125, 0.3125}, -- charger
				}
			}
		}
	}
})

laptop.register_hardware("laptop:cube", {
	description = "CUBE PC",
	infotext = "CUBE PC",
	sequence = { "off", "on"},
	custom_theme = "Red",
	hw_capabilities = { "hdd", "floppy", "net", "liveboot" },
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"laptop_cube_monitor_top.png^laptop_cube_tower_top.png",
				"laptop_cube_monitor_bottom.png^laptop_cube_tower_bottom.png",
				"laptop_cube_monitor_right.png^laptop_cube_tower_right.png",
				"laptop_cube_monitor_left.png^laptop_cube_tower_left.png",
				"laptop_cube_monitor_back.png^laptop_cube_tower_back.png",
				"laptop_cube_monitor_front_on.png^laptop_cube_tower_front_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
					type = "fixed",
					fixed = {
					{-0.5, -0.5, -0.1875, 0.5, -0.1875, 0.5}, -- cube tower
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- cube keyboard
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- cube mouse
					{-0.3125, -0.5, -0.125, 0.3125, 0.5, 0.4375}, -- cube monitor
				}
			},
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_cube_monitor_top.png^laptop_cube_tower_top.png",
				"laptop_cube_monitor_bottom.png^laptop_cube_tower_bottom.png",
				"laptop_cube_monitor_right.png^laptop_cube_tower_right.png",
				"laptop_cube_monitor_left.png^laptop_cube_tower_left.png",
				"laptop_cube_monitor_back.png^laptop_cube_tower_back.png",
				"laptop_cube_monitor_front.png^laptop_cube_tower_front.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
					type = "fixed",
					fixed = {
					{-0.5, -0.5, -0.1875, 0.5, -0.1875, 0.5}, -- cube tower
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- cube keyboard
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- cube mouse
					{-0.3125, -0.5, -0.125, 0.3125, 0.5, 0.4375}, -- cube monitor
				}
			}
		}
	}
})

laptop.register_hardware("laptop:monitor2", {
	description = "Fruit Zero",
	infotext = "Fruit Zero",
	sequence = { "off", "on"},
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"laptop_fruit_stand_top.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_lcd_back.png",
				"laptop_lcd_fruit_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.125, 0.5, -0.4375, 0.375}, -- NodeBox1
					{-0.0625, -0.4375, 0.125, 0.0625, 0.0625, 0.25}, -- NodeBox2
					{-0.5, -0.1875, 0, 0.5, 0.5, 0.125}, -- NodeBox3
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- NodeBox4
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- NodeBox5
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_fruit_stand_top.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_lcd_back.png",
				"laptop_lcd_fruit.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.125, 0.5, -0.4375, 0.375}, -- NodeBox1
					{-0.0625, -0.4375, 0.125, 0.0625, 0.0625, 0.25}, -- NodeBox2
					{-0.5, -0.1875, 0, 0.5, 0.5, 0.125}, -- NodeBox3
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- NodeBox4
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- NodeBox5
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
			light_source = 4,
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
	description = "Pentium 3",
	infotext = "Pentium 3",
	sequence = { "off", "on"},
	hw_capabilities = { "floppy", "liveboot" },
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 3,
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
			paramtype2 = "facedir",
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
			hw_state = "power_off",
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
			paramtype2 = "facedir",
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
			paramtype2 = "facedir",
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
			paramtype2 = "facedir",
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
			light_source = 4,
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
			paramtype2 = "facedir",
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

