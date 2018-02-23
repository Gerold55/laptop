local version = "3.31"
local releaseyear = "1982"

local initial_message = {
	"BASIC OPERATING SYSTEM",
	"(C)COPYRIGHT "..releaseyear.." CARDIFF-SOFT",
	"128K RAM SYSTEM  77822 BYTES FREE",
}

local function add_outline(data, line)
	table.insert(data.outlines, line)
	if #data.outlines > 34 then -- maximum lines count
		table.remove(data.outlines,1)
	end
end

local function is_executable_app(mtos, app)
	if not mtos.sysdata then -- cannot executed withoud sysdata
		return false
	elseif app and not app.view and -- app given
			not app.appwindow_formspec_func and --not a launcher
			app.name ~= 'removable' and -- skip this apps hard-coded
			app.name ~= 'launcher_settings' then
		return true
	else
		return false
	end
end

local help_texts = {
	CLS = "                  Clears the screen.",
	DATE = "                Displays the current system date.",
	DIR = "                    Displays directory of current disk.",
	HALT = "                 Shut down CS-BOS.",
	HELP = "                Displays HELP menu. HELP [command] displays help on that command.",
	MEM = "                 Displays memory usage table.",
	EXIT = "                  Exit CS-BOS shell",
	REBOOT = "          Perform a soft reboot.",
	TEXTCOLOR = "  Change terminal text color. TEXTCOLOR [green, amber, or white]",
	TIME = "                 Displays the current system time.",
	TIMEDATE = "       Displays the current system time and date.",
	TODO = "               View TODO list for CS-BOS",
	VER = "                  Displays CS-BOS version.",
	FORMAT = "          [/E][/S][/D]  Show format info or format Disk. /E empty disk, /S creates boot disk, /D creates data disk",
	LABEL = "              [new_label] Show / Set floppy label",
}

laptop.register_app("cs-bos_launcher", {
	app_name = "CS-BOS Prompt",
	app_info = "Command Line Interface",
	fullscreen = true,
	app_icon = "laptop_cs_bos.png",

	formspec_func = function(cs_bos, mtos)

		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		local sysos = mtos.bdev:get_app_storage('ram', 'os')
		local sdata = mtos.bdev:get_app_storage('system', 'cs_bos') or {} -- handle temporary if no sysdata given

		-- no system found. In case of booted from removable, continue in live mode
		if not mtos.sysdata and sysos.booted_from ~= "removable" then
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

		data.inputfield = data.inputfield or ""
			-- Apple ][ Green: #00FF33
			-- PC Amber: #FFB000
		sdata.tty = sdata.tty or data.tty or "#00FF33"
		data.tty = sdata.tty

		if not data.outlines then
			data.outlines = {}
			for _, line in ipairs(initial_message) do
				add_outline(data, line)
			end
		end

		local formspec =
				"size[15,10]background[15,10;0,0;laptop_theme_desktop_icon_label_button_black.png;true]"..
				"field[0.020,9.93;15.6,1;inputfield;;"..minetest.formspec_escape(data.inputfield).."]"..
				"textlist[-.35,-.35;15.57, 10.12;outlines;"
		for idx,line in ipairs(data.outlines) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec..sdata.tty..minetest.formspec_escape(line)
		end
		formspec = formspec..";"..#data.outlines.."]"..
				"field_close_on_enter[inputfield;false]"
		return formspec
	end,

	receive_fields_func = function(cs_bos, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		local sdata = mtos.bdev:get_app_storage('system', 'cs_bos') or {} -- handle temporary if no sysdata given

		data.outlines = data.outlines or {}
		data.inputfield = data.inputfield or ""

		if fields.inputfield then -- move received data to the formspec input field
			data.inputfield = fields.inputfield
		end

--		if fields.key_up then -- load previous command back in inputfield
		if fields.key_enter then
		-- run the command
			local exec_all = data.inputfield:split(" ")
			local input_line = data.inputfield
			local exec_command = exec_all[1] --further parameters are 2++
			add_outline(data, "> "..data.inputfield)
			data.inputfield = ""
			if exec_command then
				exec_command = exec_command:upper()
			end
			if exec_command == nil then --empty line
			elseif exec_command == "HALT" then
				-- same code as in node_fw on punch to disable the OS
				if mtos.hwdef.next_node then
					local hwdef_next = laptop.node_config[mtos.hwdef.next_node]
					if hwdef_next.hw_state then
						mtos[hwdef_next.hw_state](mtos, mtos.hwdef.next_node)
					else
						mtos:swap_node(hwdef.next_node)
						mtos:save()
					end
				end
			elseif exec_command == "EXIT" then
				data.outlines = nil  -- reset screen
				mtos:set_app()  -- quit app (if in app mode)
			elseif exec_command == "REBOOT" then
				mtos:power_on()  -- reboots computer
			elseif exec_command == "EJECT" then
				local idata = mtos.bdev:get_removable_disk()
				local success = idata:eject()
				if success then
					add_outline(data, 'DISK EJECTED')
				else
					add_outline(data, 'NO DISK FOUND')
				end
			elseif is_executable_app(mtos, laptop.apps[exec_command:lower()]) then
				add_outline(data, 'LAUNCHED '..exec_command)
				mtos:set_app(exec_command:lower())
			elseif exec_command == "DIR" then
				add_outline(data, 'VIEWING CONTENTS OF DISK 0')
				add_outline(data, '')
				for k, v in pairs(laptop.apps) do
					if is_executable_app(mtos, v) then
						add_outline(data, k:upper().."    "..(v.name or "") .. " " .. (v.app_info or ""))
					end
				end
			elseif exec_command == "INFO" then
				local info_file = exec_all[2]
				if is_executable_app(mtos, v) then
					add_outline(data, k:upper().."    "..(v.name or "") .. " " .. (v.app_info or ""))
				end
			elseif exec_command == "CLS" then
				for i=1, 35 do add_outline(data, '') end
			elseif exec_command == "TIME" then
				add_outline(data, os.date("%I:%M:%S %p"))
				add_outline(data, '')
			elseif exec_command == "DATE" then
				add_outline(data, os.date("%A %B %d, %Y"))
				add_outline(data, '')
			elseif exec_command == "TIMEDATE" then
				add_outline(data, os.date("%I:%M:%S %p, %A %B %d, %Y"))
				add_outline(data, '')
			elseif exec_command == "VER" then
				add_outline(data, 'CARDIFF-SOFT BASIC OPERATING SYSTEM v'..version)
				add_outline(data, '')
			elseif exec_command == "MEM" then
				add_outline(data, 'Memory Type                 Total =            Used       +       Free')
				add_outline(data, '------------------------       -------------        -------------       -------------')
				add_outline(data, 'Conventional                        640                   16                 624')
				add_outline(data, 'Upper                                    123                   86                   37')
				add_outline(data, 'Reserved                                  0                     0                      0')
				add_outline(data, 'Extended (XMS)*         130,309           53,148            77,198')
				add_outline(data, '------------------------       -------------        -------------       -------------')
				add_outline(data, 'Total Memory                131,072            53,250           77,822')
				add_outline(data, '')
			elseif exec_command == "TEXTCOLOR" then
				local textcolor = exec_all[2]
				if textcolor == "green" then
					sdata.tty="#00FF33"
				elseif textcolor == "amber" then
					sdata.tty="#FFB000"
				elseif textcolor == "white" then
					sdata.tty="#FFFFFF"
				else
					textcolor = 'ERROR'
					add_outline(data, '?SYNATX ERROR')
					add_outline(data, '')
				end
				if textcolor ~= 'ERROR' then
					data.tty = sdata.tty
					add_outline(data, 'Color changed to '..textcolor)
				end
			elseif exec_command == "FORMAT" then
				local idata = mtos.bdev:get_removable_disk()
				if not idata.stack then
					add_outline(data, '?DISK NOT FOUND')
					add_outline(data, '')
				else
					local fparam = exec_all[2]
					local ftype, newlabel
					if fparam == "/E" then
						ftype = ""
						newlabel = ""
					elseif fparam == "/S" then
						ftype = "boot"
						newlabel = "Data "..idata.def.description
					elseif fparam == "/D" then
						ftype = "data"
						newlabel = "CS-BOS Boot Disk"
					end
					if not ftype and fparam then
						add_outline(data, "?SYNTAX ERROR")
						add_outline(data, "")
					else
						if ftype then
							add_outline(data, 'FORMATTING '..idata.def.description)
							idata:format_disk(ftype, newlabel)
						else
							add_outline(data, 'MEDIA INFORMATION: '..idata.def.description)
						end

						add_outline(data, "FORMAT: "..idata.os_format)
						add_outline(data, "LABEL: "..idata.label)
						add_outline(data, "")
					end

				end
			elseif exec_command == "LABEL" then
				local idata = mtos.bdev:get_removable_disk()
				if not idata.stack then
					add_outline(data, '?DISK NOT FOUND')
					add_outline(data, '')
				else
					if exec_all[2] then
						idata.label = input_line:sub(6):gsub("^%s*(.-)%s*$", "%1")
					end
					add_outline(data, "LABEL: "..idata.label)
					add_outline(data, "")
				end
----TODO List----
			elseif exec_command == "TODO" then
				add_outline(data, 'cload: load a specific file from cassette')
				add_outline(data, 'del: remove file from current disk or cassette')
				add_outline(data, 'dir0: list files or apps on disk 0')
				add_outline(data, 'dir1: list files or apps on disk 1')
				add_outline(data, 'dir2: list files or apps on disk 1')
				add_outline(data, 'format: format disk')
				add_outline(data, 'format /s: make boot disk')
				add_outline(data, 'Use up arrow to load previous command')
				add_outline(data, '')

----help commands----
			elseif exec_command == "HELP" then
				local help_command = exec_all[2]
				if not help_command then -- no argument, print all
					add_outline(data, 'These shell commands are defined internally.')
					add_outline(data, '')
						local help_sorted = {}
						for k, v in pairs(help_texts) do
							table.insert(help_sorted, k.."    "..v)
						end
						table.sort(help_sorted)
						for _, kv in ipairs(help_sorted) do
							add_outline(data, kv)
						end
					add_outline(data, '')
				else
					local help_text = help_texts[help_command:upper()] or "?SYNTAX ERROR"
					add_outline(data, help_command:upper().. "    "..help_text)
						add_outline(data, '')
				end
			else
				add_outline(data, "?SYNTAX ERROR")
				add_outline(data, '')
			end
		end
	end,

appwindow_formspec_func = function(...)
	--re-use the default launcher theming
	return laptop.apps["launcher"].appwindow_formspec_func(...)
end,
})
