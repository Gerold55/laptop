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

minetest.register_craftitem("laptop:printed_paper", {
	description = 'Printed paper',
	inventory_image = "laptop_printed_paper.png",
	groups = {not_in_creative_inventory = 1},
	stack_max = 1,
	on_use = function(itemstack, user)
		local meta = itemstack:get_meta()
		local data = meta:to_table().fields
		local formspec = "size[8,8]" .. default.gui_bg .. default.gui_bg_img ..
				"label[0,0;" .. minetest.formspec_escape(data.title or "unnamed") ..
				" by " .. (data.author or "unknown") .. " from " .. os.date("%c", data.timestamp) .. "]"..
				"textarea[0.5,1;7.5,7;;" ..
				minetest.formspec_escape(data.text or "test text") .. ";]"
	minetest.show_formspec(user:get_player_name(), "laptop:printed_paper", formspec)
	return itemstack
	end

})
