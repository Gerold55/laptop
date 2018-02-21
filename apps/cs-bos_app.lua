laptop.register_app("cs-bos_launcher", {
	app_name = "CS-BOS v3.31",
	fullscreen = true,

	formspec_func = function(cs_bos, mtos)
	local screenLine0 = "BASIC OPERATING SYSTEM\n(C)COPYRIGHT 1982 CARDIFF-SOFT\n128K RAM SYSTEM  77822 BYTES FREE"
	local screenLine9 = '9'
	local screenPrompt = '> '

		-- no system found. Error
		if not mtos.sysdata then
			local formspec = "size[10,7]background[10,7;0,0;laptop_launcher_insert_floppy.png;true]"..
					"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"..
					"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;2.5,3;1,1;]" ..
					"list[current_player;main;0,6.5;8,1;]" ..
					"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
					"listring[current_player;main]"

			local idata = mtos.bdev:get_removable_disk()
			if idata.stack then
				if idata.os_format ~= "boot" then
					formspec = formspec .. "label[0,1.7;Disk found but not formatted to boot]"
				end
			end
			return formspec
		end

		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		data.outlines = data.outlines or {}
		data.inputfield = data.inputfield or ""

		local formspec = 
			"size[15,10]"..
			"field[0.031,9.93;14.18,1;data.enter;;"..screenPrompt..screenLine9..data.inputfield.."]"..
			"textlist[-.35,-.35;15.57, 10.12;crtDisplay;list=\n \n \n"..screenLine0.."\n"..screenLine9.."\n]"..
			"button[13.75,9.85;1.5,0.55;enter;Enter]"
		return formspec
	end,





	receive_fields_func = function(app, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		data.outlines = data.outlines or {}
		data.inputfield = data.inputfield or ""

		if fields.inputfield then -- move received data to the formspec input field
			data.inputfield = fields.inputfield
		end

		if fields.key_enter or fields.button_enter then
		-- run the command

			data.inputfield = ""
		end
	end,


})
