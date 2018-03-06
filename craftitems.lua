minetest.register_craftitem("laptop:bat", {
	description = 'Battery',
	inventory_image = "laptop_bat.png",
})

minetest.register_craft({
	output = 'laptop:bat',
	recipe = {
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'default:steel_ingot', 'mesecons_gates:diode_off', 'default:steel_ingot', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:case", {
	description = 'Case',
	inventory_image = "laptop_case.png",
})

minetest.register_craft({
	output = 'laptop:case',
	recipe = {
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'default:steel_ingot', '', 'default:steel_ingot', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:crt", {
	description = 'CRT Screen',
	inventory_image = "laptop_crt.png",
})

minetest.register_craft({
	output = 'laptop:crt',
	recipe = {
	{'default:glass', 'default:glass', 'default:glass', },
	{'mesecons_lightstone:lightstone_red_off', 'mesecons_lightstone:lightstone_green_off', 'mesecons_lightstone:lightstone_blue_off', },
	{'default:steel_ingot', 'mesecons_luacontroller:luacontroller0000', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:lcd", {
	description = 'LCD Screen',
	inventory_image = "laptop_lcd.png",
})

minetest.register_craft({
	output = 'laptop:lcd',
	recipe = {
	{'mesecons_lightstone:lightstone_red_off', 'mesecons_lightstone:lightstone_green_off', 'mesecons_lightstone:lightstone_blue_off', },
	{'dye:black', 'mesecons_luacontroller:luacontroller0000', 'dye:black', },
	{'default:steel_ingot', 'default:diamond', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:gpu", {
	description = 'GPU',
	inventory_image = "laptop_gpu.png",
})

minetest.register_craft({
	output = 'laptop:gpu',
	recipe = {
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'default:steel_ingot', 'mesecons_fpga:fpga0000', 'default:steel_ingot', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:HDD", {
	description = 'Hard Drive',
	inventory_image = "laptop_harddrive.png",
})

minetest.register_craft({
	output = 'laptop:HDD',
	recipe = {
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'default:steel_ingot', 'mesecons_luacontroller:luacontroller0000', 'default:steel_ingot', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:motherboard", {
	description = 'Motherboard',
	inventory_image = "laptop_motherboard.png",
})

minetest.register_craft({
	output = 'laptop:motherboard',
	recipe = {
	{'mesecons_luacontroller:luacontroller0000', 'mesecons_fpga:fpga0000', 'mesecons_gates:nand_off', },
	{'dye:dark_green', 'dye:dark_green', 'dye:dark_green', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:fan", {
	description = 'Fan',
	inventory_image = "laptop_fan.png",
})

minetest.register_craft({
	output = 'laptop:fan',
	recipe = {
	{'', 'default:steel_ingot', '', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'', 'default:steel_ingot', '', },
	}
})

minetest.register_craftitem("laptop:psu", {
	description = 'PSU',
	inventory_image = "laptop_psu.png",
})

minetest.register_craft({
	output = 'laptop:psu',
	recipe = {
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'mesecons_luacontroller:luacontroller0000', 'mesecons_fpga:fpga0000', 'laptop:fan', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craft({
	output = 'laptop:floppy',
	recipe = {
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	{'default:steel_ingot', 'mesecons_fpga:programmer', 'default:steel_ingot', },
	{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot', },
	}
})

minetest.register_craft({
	output = 'laptop:usbstick',
	recipe = {
	{'', 'default:steel_ingot', '', },
	{'', 'mesecons_fpga:programmer', '', },
	{'', 'default:steel_ingot', '', },
	}
})