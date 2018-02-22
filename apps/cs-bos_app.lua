local version = "3.31"
local releaseyear = "1982"

local initial_message = {
	"BASIC OPERATING SYSTEM",
	"(C)COPYRIGHT "..releaseyear.." CARDIFF-SOFT",
	"128K RAM SYSTEM  77822 BYTES FREE",
	"",
}

local function add_outline(data, line)
	table.insert(data.outlines, line)
	if #data.outlines > 34 then -- maximum lines count
		table.remove(data.outlines,1)
	end
end

local function is_executable_app(app)
	if app and not app.view and -- app given
			not app.appwindow_formspec_func then--not a launcher
		return true
	end
end

local help_texts = {
	CLS = "                  Clears the screen.",
	DATE = "                Displays the current system date.",
	DIR = "                    Displays directory of current disk. Use DIR[#] to view directory of other disks.",
	EXIT = "                  Exits CS-BOS.",
	HELP = "                Displays HELP menu. HELP [command] displays help on that command.",
	MEM = "                 Displays memory usage table.",
	TEXTCOLOR = "  Change terminal text color. TEXTCOLOR [green, amber, or white]",
	TIME = "                 Displays the current system time.",
	TIMEDATE = "       Displays the current system time and date.",
	TODO = "               View TODO list for CS-BOS",
	VER = "                  Displays CS-BOS version.",
}

laptop.register_app("cs-bos_launcher", {
	app_name = "CS-BOS Prompt",
	app_info = "Command Line Interface",
	fullscreen = true,
	app_icon = "laptop_cs_bos.png",

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

		data.inputfield = data.inputfield or ""
			-- Apple ][ Green: #00FF33
			-- PC Amber: #FFB000
		data.tty = data.tty or "#00FF33"

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
			formspec = formspec..data.tty..minetest.formspec_escape(line)
		end
		formspec = formspec..";"..#data.outlines.."]"..
				"field_close_on_enter[inputfield;false]"
		return formspec
	end,

	receive_fields_func = function(cs_bos, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')

		data.outlines = data.outlines or {}
		data.inputfield = data.inputfield or ""

		if fields.inputfield then -- move received data to the formspec input field
			data.inputfield = fields.inputfield
		end

--		if fields.key_up then -- load previous command back in inputfield
		if fields.key_enter then
		-- run the command
			local exec_all = data.inputfield:split(" ")
			local exec_command = exec_all[1] --further parameters are 2++
			add_outline(data, "> "..data.inputfield)
			data.inputfield = ""
			if exec_command then
				exec_command = exec_command:upper()
			end
			if exec_command == nil then --empty line
			elseif exec_command == "EXIT" then
				data.outlines = nil  -- reset screen
				mtos:set_app()  -- exit app (if in app mode)
			elseif exec_command == "EJECT" then
				local idata = mtos.bdev:get_removable_disk()
				local success = idata:eject()
				if success then
					add_outline(data, 'DISK EJECTED')
				else
					add_outline(data, 'NO DISK FOUND')
				end
			elseif is_executable_app(laptop.apps[exec_command:lower()]) then
				add_outline(data, 'LAUNCH '..exec_command)
				mtos:set_app(exec_command:lower())
			elseif exec_command == "DIR" then
				for k, v in pairs(laptop.apps) do
					if is_executable_app(v) then
						add_outline(data, k:upper().."    "..(v.name or "") .. " " .. (v.app_info or ""))
					end
				end
									add_outline(data, '')
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
							data.tty="#00FF33"
							add_outline(data, 'Color changed to '..textcolor)
				elseif textcolor == "amber" then
							data.tty="#FFB000"
							add_outline(data, 'Color changed to '..textcolor)
				elseif textcolor == "white" then
							data.tty="#FFFFFF"
							add_outline(data, 'Color changed to '..textcolor)
				else add_outline(data, '?SYNATX ERROR')
				add_outline(data, '')
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
