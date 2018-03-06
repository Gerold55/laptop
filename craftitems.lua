
minetest.register_craftitem("laptop:floppy", {
	description = 'High density floppy',
	inventory_image = "laptop_diskette.png",
	groups = {laptop_removable_floppy = 1},
	stack_max = 1,
})

--[[ TODO:
minetest.register_craft({
	output = 'laptop:floppy',
	recipe = {

	}
})
]]

minetest.register_craftitem("laptop:usbstick", {
	description = 'USB storage stick',
	inventory_image = "laptop_usb.png",
	groups = {laptop_removable_usb = 1},
	stack_max = 1,
})

--[[ TODO:
minetest.register_craft({
	output = 'laptop:usbstick',
	recipe = {

	}
})
]]

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

--[[ TODO:
minetest.register_craft({
	output = 'laptop:printed_paper',
	recipe = {

	}
})
]]

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
