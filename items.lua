
minetest.register_craftitem("laptop:floppy", {
	description = 'High density floppy',
	inventory_image = "laptop_diskette.png",
	groups = {laptop_removable_floppy = 1},
	stack_max = 1,
})

minetest.register_craftitem("laptop:usbstick", {
	description = 'USB storage stick',
	inventory_image = "laptop_usb.png",
	groups = {laptop_removable_usb = 1},
	stack_max = 1,
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
				"label[0.5,0;" .. minetest.formspec_escape(data.title or "unnamed") ..
				" by " .. (data.author or "unknown") .. "]"..
				"textarea[0.5,1;7.5,7;;" ..
				minetest.formspec_escape(data.text or "test text") .. ";]"
	minetest.show_formspec(user:get_player_name(), "laptop:printed_paper", formspec)
	return itemstack
	end

})
