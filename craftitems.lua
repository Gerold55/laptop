----------------------------
---------PROCESSORS---------
----------------------------

minetest.register_craftitem("laptop:cpu_c6", {
	description = 'Ziram c6 Processor',
	inventory_image = "laptop_cpu_c6.png",
})

minetest.register_craft({
	output = 'laptop:cpu_c6',
	recipe = {
	{'', '', '', },
	{'mesecons_materials:silicon', 'mesecons_gates:diode_off', 'default:tin_ingot', },
	{'mesecons_gates:and_off', 'mesecons_gates:or_off', 'mesecons_gates:nand_off', },
	}
})

minetest.register_craftitem("laptop:cpu_d75a", {
	description = 'Interlink D75A Processor',
	inventory_image = "laptop_cpu_d75a.png",
})

minetest.register_craft({
	output = 'laptop:cpu_d75a',
	recipe = {
	{'mesecons_materials:silicon', 'mesecons_materials:silicon', 'mesecons_materials:silicon', },
	{'mesecons_gates:xor_off', 'default:copper_ingot', 'mesecons_gates:nand_off', },
	{'mesecons_fpga:fpga0000', 'mesecons_fpga:programmer', 'mesecons_fpga:fpga0000', },
	}
})

minetest.register_craftitem("laptop:cpu_jetcore", {
	description = 'Interlink jetCore Processor',
	inventory_image = "laptop_cpu_jetcore.png",
})

minetest.register_craft({
	output = 'laptop:cpu_jetcore',
	recipe = {
	{'mesecons_materials:silicon', 'mesecons_materials:silicon', 'mesecons_materials:silicon', },
	{'mesecons_materials:fiber', 'default:gold_ingot', 'mesecons_delayer:delayer_off_1', },
	{'mesecons_fpga:fpga0000', 'mesecons_luacontroller:luacontroller0000', 'mesecons_fpga:programmer', },
	}
})

minetest.register_craftitem("laptop:cpu_65536", {
	description = 'Transpose 65536 Processor',
	inventory_image = "laptop_cpu_65536.png",
})

minetest.register_craft({
	output = 'laptop:cpu_65536',
	recipe = {
	{'', '', '', },
	{'mesecons_materials:silicon', 'default:copper_ingot', 'mesecons_materials:silicon', },
	{'mesecons_gates:not_off', 'mesecons_fpga:fpga0000', 'mesecons_delayer:delayer_off_1', },
	}
})

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

minetest.register_craftitem("laptop:crt_amber", {
	description = 'Amber CRT Screen',
	inventory_image = "laptop_crt_amber.png",
})

minetest.register_craft({
	output = 'laptop:crt_amber',
	recipe = {
	{'default:glass', 'dye:orange', 'default:glass', },
	{'mesecons_lightstone:lightstone_red_off', 'mesecons_lightstone:lightstone_green_off', 'mesecons_lightstone:lightstone_blue_off', },
	{'default:steel_ingot', 'mesecons_luacontroller:luacontroller0000', 'default:steel_ingot', },
	}
})

minetest.register_craftitem("laptop:crt_green", {
	description = 'Green CRT Screen',
	inventory_image = "laptop_crt_green.png",
})

minetest.register_craft({
	output = 'laptop:crt_green',
	recipe = {
	{'default:glass', 'dye:green', 'default:glass', },
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

--Computers--
minetest.register_craft({
	output = 'laptop:core_closed',
	recipe = {
	{'dye:red', 'laptop:lcd', 'dye:red', },
	{'laptop:HDD', 'laptop:motherboard', 'laptop:gpu', },
	{'laptop:bat', 'laptop:case', 'dye:red', },
	}
})

minetest.register_craft({
	output = 'laptop:printer_off',
	recipe = {
	{'', 'laptop:motherboard', '', },
	{'', 'laptop:psu', '', },
	{'', 'laptop:case', '', },
	}
})

minetest.register_craft({
	output = 'laptop:cube_off',
	recipe = {
	{'', 'laptop:crt', '', },
	{'laptop:HDD', 'laptop:motherboard', 'laptop:psu', },
	{'laptop:cpu_65536', 'laptop:case', '', },
	}
})

minetest.register_craft({
	output = 'laptop:fruit_zero_off',
	recipe = {
	{'dye:white', 'laptop:lcd', 'dye:white', },
	{'laptop:gpu', 'laptop:motherboard', 'laptop:HDD', },
	{'laptop:cpu_jetcore', 'laptop:case', 'laptop:psu', },
	}
})

minetest.register_craft({
	output = 'laptop:bell_crossover_off',
	recipe = {
	{'dye:dark_grey', 'laptop:lcd', 'dye:dark_grey', },
	{'laptop:psu', 'laptop:motherboard', 'laptop:HDD', },
	{'laptop:cpu_d75a', 'laptop:case', 'dye:dark_grey', },
	}
})

minetest.register_craft({
	output = 'laptop:kodiak_1000_off',
	recipe = {
	{'', 'laptop:crt_green', '', },
	{'laptop:cpu_c6', 'laptop:motherboard', 'laptop:psu', },
	{'laptop:HDD', 'laptop:case', '', },
	}
})

minetest.register_craft({
	output = 'laptop:portable_workstation_2_closed',
	recipe = {
	{'dye:dark_grey', 'laptop:lcd', 'dye:dark_grey', },
	{'laptop:HDD', 'laptop:motherboard', 'laptop:cpu_d75a', },
	{'laptop:bat', 'laptop:case', 'dye:dark_grey', },
	}
})
