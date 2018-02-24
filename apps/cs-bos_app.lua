local os_version_attr = {
	['3.31'] = {
		releaseyear = '1982',
		version_string = '3.31',
		textcolor = '#00FF33', -- green
		blacklist_commands = { TEXTCOLOR = true },
		scrollback_size = 34,
	},
	['1.10'] = {
		releaseyear = '1976',
		version_string = '1.10',
		textcolor = '#FFB000', --amber
		blacklist_commands = { TEXTCOLOR = true },
		scrollback_size = 25,
	},
	['6.33'] = {
		releaseyear = '1995',
		version_string = '6.33',
		textcolor = '#FFFFFF', -- white
		blacklist_commands = { },
		scrollback_size = 300,
	},
}
os_version_attr.default = os_version_attr['6.33']

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
	FORMAT = "          View format information or Format Disk. FORMAT [/E] Erase disk, [/S] Create system (boot) disk, [/D] Create data disk",
	LABEL = "              Show/Set floppy label. LABEL [new_label]",
}


local function get_initial_message(data)
	data.outlines = {
			"BASIC OPERATING SYSTEM v"..data.os_attr.version_string,
			"(C)COPYRIGHT "..data.os_attr.releaseyear.." CARDIFF-SOFT",
			"128K RAM SYSTEM  77822 BYTES FREE",
		}
end

local function add_outline(data, line)
	table.insert(data.outlines, line)
	if #data.outlines > data.scrollback_size then
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

local function numWithCommas(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

local function initialize_data(data, sdata, mtos)
	data.os_attr = os_version_attr.default
	if mtos.hwdef.os_version then
		data.os_attr = os_version_attr[mtos.hwdef.os_version]
	end

	if data.os_attr.blacklist_commands.TEXTCOLOR then
		data.tty = data.os_attr.textcolor
	else
		data.tty = sdata.tty or data.tty or data.os_attr.textcolor
	end

	data.scrollback_size = sdata.scrollback_size or data.scrollback_size or data.os_attr.scrollback_size
		-- Set initial message on new session
	if not data.outlines then
		get_initial_message(data)
	end
	data.inputfield = data.inputfield or ""
end


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

		initialize_data(data, sdata, mtos)

		local formspec =
				"size[15,10]background[15,10;0,0;laptop_theme_desktop_icon_label_button_black.png;true]"..
				"field[0.020,9.93;15.6,1;inputfield;;"..minetest.formspec_escape(data.inputfield).."]"..
				"tablecolumns[text]tableoptions[background=#000000;border=false;highlight=#000000;"..
				"color="..data.tty..";highlight_text="..data.tty.."]"..
				"table[-0.35,-0.35;15.57, 10.12;outlines;"
		for idx,line in ipairs(data.outlines) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec..minetest.formspec_escape(line)
		end
		formspec = formspec..";"..#data.outlines.."]"..
				"field_close_on_enter[inputfield;false]"
		return formspec
	end,

	receive_fields_func = function(cs_bos, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		local sysos = mtos.bdev:get_app_storage('ram', 'os')
		local sdata = mtos.bdev:get_app_storage('system', 'cs_bos') or {} -- handle temporary if no sysdata given
		initialize_data(data, sdata, mtos)


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
			elseif data.os_attr.blacklist_commands[exec_command] then
				add_outline(data, '?ERROR NOT IMPLEMENTED')
				add_outline(data, '')
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
				if not exec_all[2] or exec_all[2]:upper() == 'HDD' then
					local txtdata = mtos.bdev:get_app_storage('hdd', 'stickynote:files')
					if txtdata then
						add_outline(data, 'VIEWING CONTENTS OF DISK 0: HDD')
						add_outline(data, "FORMAT: BOOTABLE")
						add_outline(data, "")
						if sysos.booted_from ~= "removable" then
							for k, v in pairs(laptop.apps) do
								if is_executable_app(mtos, v) then
									add_outline(data, k:upper().."*    "..(v.app_info or ""))
								end
							end
						end
						for k, v in pairs(txtdata) do
							add_outline(data, k.."      "..v.owner.."      "..os.date("%M:%S %p, %A %B %d, %Y", v.ctime))
						end
						add_outline(data, '')
						else add_outline(data, 'NO HARD DISK PRESENT')
						add_outline(data, '')
					end

					elseif not exec_all[2] or exec_all[2]:upper() == 'FDD' then
						local txtdata = mtos.bdev:get_app_storage('removable', 'stickynote:files')
						if txtdata then
							local idata = mtos.bdev:get_removable_disk()
							add_outline(data, "VIEWING CONTENTS OF DISK 1: "..idata.label)
							add_outline(data, "FORMAT: "..idata.os_format:upper())
							add_outline(data, "")
							if sysos.booted_from == "removable" then
								for k, v in pairs(laptop.apps) do
									if is_executable_app(mtos, v) then
										add_outline(data, k:upper().."*    "..(v.app_info or ""))
									end
								end
							end
							for k, v in pairs(txtdata) do
									add_outline(data, k.."      "..v.owner.."      "..os.date("%I:%M:%S %p, %A %B %d, %Y", v.ctime))
							end
							add_outline(data, '')
							else add_outline(data, 'NO FLOPPY DISK PRESENT')
							add_outline(data, '')
						end
						else add_outline(data, '?SYNTAX ERROR')
						add_outline(data, '')
					end

			elseif exec_command == "TYPE" then
				if exec_all[2] then
					local filename = input_line:sub(6):gsub("^%s*(.-)%s*$", "%1")
					local disk
					if filename:sub(1,4):upper() == 'HDD:' then
						disk = 'hdd'
						filename = filename:sub(5)
					elseif filename:sub(1,4):upper() == 'FDD:' then
						disk = 'removable'
						filename = filename:sub(5)
					else
						disk = 'system'
					end
					local txtdata = mtos.bdev:get_app_storage(disk, 'stickynote:files')
					if txtdata then
						local file = txtdata[filename]
						if file and file.content then
							for s in file.content:gmatch("[^\n]+") do
								add_outline(data, s)
							end
						end
					end
				else
					add_outline(data, '?SYNATX ERROR')
				end
			elseif exec_command == "CLS" then
				data.outlines = {}
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
				add_outline(data, 'CARDIFF-SOFT BASIC OPERATING SYSTEM v'..data.os_attr.version_string)
				add_outline(data, '')
			elseif exec_command == "MEM" then
				local convent = math.random(30,99)
				local upper = math.random(10,99)
				local xms = math.random(20000,99999)
				add_outline(data, 'Memory Type                 Total =            Used       +       Free')
				add_outline(data, '------------------------       -------------        -------------       -------------')
				add_outline(data, 'Conventional                        640                   '..convent..'                 '..(640-convent))
				add_outline(data, 'Upper                                    123                   '..upper..'                   '..(123-upper))
				add_outline(data, 'Reserved                                  0                     0                      0')
				add_outline(data, 'Extended (XMS)*         130,309           '..numWithCommas(xms)..'            '..numWithCommas(130309-xms))
				add_outline(data, '------------------------       -------------        -------------       -------------')
				add_outline(data, 'Total Memory                131,072            '..numWithCommas(convent+upper+xms)..'           '..numWithCommas(131072-(convent+upper+xms)))
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
					add_outline(data, 'Color changed to '..textcolor)
				end
			elseif exec_command == "FORMAT" then
				local idata = mtos.bdev:get_removable_disk()
				if not idata.stack then
					add_outline(data, '?DISK NOT FOUND')
					add_outline(data, '')
				else
					local fparam = exec_all[2]:upper()
					local ftype, newlabel
					if fparam == "/E" then
						ftype = ""
						newlabel = ""
					elseif fparam == "/S" then
						ftype = "boot"
						newlabel = "CS-BOS Boot Disk"
					elseif fparam == "/D" then
						ftype = "data"
						newlabel = "Data "..idata.def.description
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
				add_outline(data, 'dir2: list files or apps on disk 2')
				add_outline(data, '')

----help commands----
			elseif exec_command == "HELP" then
				local help_command = exec_all[2]
				if not help_command then -- no argument, print all
					add_outline(data, 'These shell commands are defined internally.')
					add_outline(data, '')
						local help_sorted = {}
						for k, v in pairs(help_texts) do
							if not data.os_attr.blacklist_commands[k] then
								table.insert(help_sorted, k.."    "..v)
							end
						end
						table.sort(help_sorted)
						for _, kv in ipairs(help_sorted) do
							add_outline(data, kv)
						end
					add_outline(data, '')
				else
					help_command = help_command:upper()
					local help_text
					if data.os_attr.blacklist_commands[help_command] then
						help_text = "?NOT IMPLEMENTED ERROR"
					else
						help_text = help_texts[help_command] or "?  NO HELP IS AVAILABLE FOR THAT TOPIC"
					end
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
