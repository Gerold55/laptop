laptop.register_app("launcher_insert_floppy", {
	fullscreen = true,
	formspec_func = function(launcher_app, os)
		return "size[10,7]background[10,7;0,0;minetest_launcher_insert_floppy.png;true]"
	end
})
