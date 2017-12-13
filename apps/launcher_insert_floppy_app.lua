laptop.register_app("launcher_insert_floppy", {
	fullscreen = true,
	formspec_func = function(launcher_app, mtos) --redefine the formspec
		local formspec = "size[10,7]background[10,7;0,0;laptop_launcher_insert_floppy.png;true]"..
				"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"..
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;2.5,3;1,1;]" ..
				"list[current_player;main;0,6.5;8,1;]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"

		local idata = mtos:get_removable_data()
		if idata then
			if idata.os_format == "OldOS" then
				-- boot "default" launcher
				return laptop.apps.launcher.formspec_func(launcher_app, mtos)
			else
				formspec = formspec .. "label[0,1.7;Disk found but not formatted to boot]"
			end
		end
		return formspec
	end,
	appwindow_formspec_func = function(...)
		return laptop.apps.launcher.appwindow_formspec_func(...)
	end,
	receive_fields_func = function(...)
		return laptop.apps.launcher.receive_fields_func(...)
	end
})
