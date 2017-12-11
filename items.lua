
minetest.register_craftitem("laptop:floppy", {
	description = 'High density floppy',
	inventory_image = "laptop_diskette.png",
	groups = {laptop_removable = 1, laptop_removable_floppy = 1},
	stack_max = 1,
})

minetest.register_craftitem("laptop:usbstick", {
	description = 'USB storage stick',
	inventory_image = "laptop_usb.png",
	groups = {laptop_removable = 1, laptop_removable_usb = 1},
	stack_max = 1,
})
