local initial_message = {
	"BASIC OPERATING SYSTEM",
	"(C)COPYRIGHT 1982 CARDIFF-SOFT",
	"128K RAM SYSTEM  77822 BYTES FREE",
	"",
}

local function add_outline(outlines, line)
	table.insert(outlines, line)
	if #outlines > 25 then -- maximum lines count
		table.remove(outlines,1)
	end
end


laptop.register_app("cs-bos_launcher", {
	app_name = "CS-BOS v3.31",
	fullscreen = true,

	formspec_func = function(cs_bos, mtos)

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

		data.outlines = data.outlines or table.copy(initial_message)
		data.inputfield = data.inputfield or ""

		local formspec = 
				"size[15,10]"..
				"field[0.031,9.93;14.18,1;inputfield;;"..minetest.formspec_escape(data.inputfield).."]"..
				"textlist[-.35,-.35;15.57, 10.12;outlines;"
		for idx,line in ipairs(data.outlines) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec..minetest.formspec_escape(line)
		end
		formspec = formspec..";"..#data.outlines.."]"..
				"button[13.75,9.85;1.5,0.55;button_enter;Enter]"..
				"field_close_on_enter[inputfield;false]"
		return formspec
	end,

	receive_fields_func = function(cs_bos, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')

		data.outlines = data.outlines or table.copy(initial_message)
		data.inputfield = data.inputfield or ""

		if fields.inputfield then -- move received data to the formspec input field
			data.inputfield = fields.inputfield
		end

		if fields.key_enter or fields.button_enter then
		-- run the command
			local exec_all = data.inputfield:split(" ")
			local exec_command = exec_all[1] --further parameters are 2++
			add_outline(data.outlines, "> "..data.inputfield)
			data.inputfield = ""
			if exec_command == nil then --empty line
			elseif exec_command == "cls" then
				data.outlines = nil -- reset screen
			elseif exec_command == "exit" then
				data.outlines = nil  -- reset screen
				mtos:set_app()  -- exit app (if in app mode)
			elseif exec_command == "date" then
				add_outline(data.outlines, os.date())
			else
				add_outline(data.outlines, exec_command..": command not found")
			end
		end
	end,


})
