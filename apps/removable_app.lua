
laptop.register_app("removable", {
	app_name = "Removable storage",
	app_icon = "laptop_hard_drive.png",
	app_info = "Work with removable media",
	formspec_func = function(app, mtos)
		local formspec = 
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;0,0.3;1,1;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"

		mtos.bdev.removable_disk = nil -- force reading
		local idata = mtos.bdev:get_removable_disk()
		if idata then
			-- change label
			formspec = formspec .. mtos.theme:get_label('0,1.2', idata.def.description).."field[2,0.7;4,1;label;Label:;"..idata.label.."]"..
					mtos.theme:get_button('5.7,0.55;1.5,0.7', 'minor', 'set_label', 'Rename', 'Rename the '..idata.def.description)..
					mtos.theme:get_label('0,1.7', "Format: "..idata.os_format).. -- format state
			-- buttons
					mtos.theme:get_button('0,3;1.5,0.7', 'minor', 'format', 'wipe', 'Wipe all data from disk')..
					mtos.theme:get_button('0,4;1.5,0.7', 'minor', 'format', 'data', 'Format disk to store data')
			if idata.def.groups.laptop_removable_usb then
				formspec = formspec .. mtos.theme:get_button('2,3;1.5,0.7', 'minor', 'format', 'backup', 'Store backup to disk')
			end
			if idata.os_format == "backup" then
				formspec = formspec .. mtos.theme:get_button('2,4;1.5,0.7', 'minor', 'restore', 'restore', 'Restore from backup disk')
			end

			-- format oldos
			if idata.def.groups.laptop_removable_floppy then
				formspec = formspec .. mtos.theme:get_button('4,3;1.5,0.7', 'minor', 'format', 'OldOS', 'Format disk to boot OldOS ')
			end
		end
		return formspec
	end,


	receive_fields_func = function(app, mtos, sender, fields)
		local idata = mtos.bdev:get_removable_disk()
		if idata then
			if fields.set_label then
				idata.label = fields.label
			elseif fields.format then
				fields.format = minetest.strip_colors(fields.format)
				idata.stack = ItemStack(idata.def.name)
				idata.meta = idata.stack:get_meta()
				if fields.format == 'wipe' then
					idata.label = "" -- reset label on wipe
				elseif fields.format == "data" then
					idata.meta:set_string("os_format", "data")
				elseif fields.format == "backup" then
					idata.meta:set_string("os_format", "backup")
					idata.meta:set_string("backup_data", mtos.meta:get_string('laptop_appdata'))
				elseif fields.format == "OldOS" then
					idata.meta:set_string("os_format", "boot")
				end
			elseif fields.restore then
-- TODO was soll wiederhergestellt werden?
				mtos.meta:set_string('laptop_appdata', idata.meta:get_string("backup_data"))
				mtos.bdev = laptop.get_bdev_handler(mtos)
				laptop.os_get(mtos.pos):power_on() --reboot
			end
		end
		mtos.bdev:sync()
	end,
})
