
laptop.register_app("printer_launcher", {
--	app_name = "Printer firmware",
	fullscreen = true,
	formspec_func = function(launcher_app, mtos)
		local queue = mtos.bdev:get_app_storage('system', 'printer:queue')

		local formspec = "size[10,7]"..
				"label[8,0.5;print output]" ..
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;8,1.3;1,1;]" ..
				"list[current_player;main;1,2.85;8,1;]" ..
				"list[current_player;main;1,4.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"
		local idata = mtos.bdev:get_removable_disk()


		return formspec
	end,

	appwindow_formspec_func = function(launcher_app, app, mtos)
		local formspec = 'size[10,7]'
		return formspec
	end,

	receive_fields_func = function(launcher_app, mtos, sender, fields)
		local queue = mtos.bdev:get_app_storage('system', 'printer:queue')

	end,
})

--------------------------------------------------------
laptop.register_view("printer:app", {
	app_name = "Select printer",
	formspec_func = function(launcher_app, mtos)

	end,
	receive_fields_func = function(launcher_app, mtos, sender, fields)

	end,
})
