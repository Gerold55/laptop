local tty="#00FF33"
-- Apple ][ Green: #00FF33
-- PC Amber: #FFB000
local initial_message = {
	tty.."BASIC OPERATING SYSTEM",
	tty.."(C)COPYRIGHT 1982 CARDIFF-SOFT",
	tty.."128K RAM SYSTEM  77822 BYTES FREE",
	"",
}

local function add_outline(outlines, line)
	table.insert(outlines, line)
	if #outlines > 34 then -- maximum lines count
		table.remove(outlines,1)
	end
end

local help_texts = {
	cls = "bla bla",
	time = "bla bla",
}


laptop.register_app("cs-bos", {
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
				"size[15,10]background[15,10;0,0;laptop_theme_desktop_icon_label_button_black.png;true]"..
				"field[0.020,9.93;15.6,1;inputfield;;"..minetest.formspec_escape(data.inputfield).."]"..
				"textlist[-.35,-.35;15.57, 10.12;outlines;"
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

		data.outlines = data.outlines or table.copy(initial_message)
		data.inputfield = data.inputfield or ""

		if fields.inputfield then -- move received data to the formspec input field
			data.inputfield = fields.inputfield
		end

--		if fields.key_up then -- load previous command back in inputfield
		if fields.key_enter then
		-- run the command
			local exec_all = data.inputfield:split(" ")
			local exec_command = exec_all[1] --further parameters are 2++
			add_outline(data.outlines, tty.."> "..data.inputfield)
			data.inputfield = ""
			if exec_command == nil then --empty line
			elseif exec_command == "cls" then
				count=1 repeat count=count+1 add_outline(data.outlines, '') until count==35
			elseif exec_command == "time" then
				add_outline(data.outlines, tty..os.date("%I:%M:%S %p"))
				add_outline(data.outlines, '')
			elseif exec_command == "date" then
				add_outline(data.outlines, tty..os.date("%A %B %d, %Y"))
				add_outline(data.outlines, '')
			elseif exec_command == "timedate" then
				add_outline(data.outlines, tty..os.date("%I:%M:%S %p, %A %B %d, %Y"))
				add_outline(data.outlines, '')
			elseif exec_command == "ver" then
				add_outline(data.outlines, tty..'CARDIFF-SOFT BASIC OPERATING SYSTEM v3.31')
				add_outline(data.outlines, '')
			elseif exec_command == "mem" then
				add_outline(data.outlines, tty..'Memory Type                 Total =            Used       +       Free')
				add_outline(data.outlines, tty..'------------------------       -------------        -------------       -------------')
				add_outline(data.outlines, tty..'Conventional                        640                   16                 624')
				add_outline(data.outlines, tty..'Upper                                    123                   86                   37')
				add_outline(data.outlines, tty..'Reserved                                  0                     0                      0')
				add_outline(data.outlines, tty..'Extended (XMS)*         130,309           53,148            77,198')
				add_outline(data.outlines, tty..'------------------------       -------------        -------------       -------------')
				add_outline(data.outlines, tty..'Total Memory                131,072            53,250           77,822')
				add_outline(data.outlines, '')
			elseif exec_command == "dir" then
				add_outline(data.outlines, tty..'List Files')
				add_outline(data.outlines, '')
			elseif exec_command == "textcolor" then
				local textcolor = exec_all[2]
				if textcolor == "green" then
							tty="#00FF33"
							add_outline(data.outlines, '')
				elseif textcolor == "amber" then
							tty="#FFB000"
							add_outline(data.outlines, '')
				elseif textcolor == "white" then
							tty="#FFFFFF"
							add_outline(data.outlines, '')
				else add_outline(data.outlines, tty..'?SYNATX ERROR')
				add_outline(data.outlines, '')
			end

----TODO List----
			elseif exec_command == "todo" then
				add_outline(data.outlines, tty..'cload: load a specific file from cassette')
				add_outline(data.outlines, tty..'del: remove file from current disk or cassette')
				add_outline(data.outlines, tty..'dir: list files or apps on current disk')
				add_outline(data.outlines, tty..'dir0: list files or apps on disk 0')
				add_outline(data.outlines, tty..'dir1: list files or apps on disk 1')
				add_outline(data.outlines, tty..'dir2: list files or apps on disk 1')
				add_outline(data.outlines, tty..'eject: eject disk')
				add_outline(data.outlines, tty..'format: format disk')
				add_outline(data.outlines, tty..'format /s: make boot disk')
				add_outline(data.outlines, tty..'Use up arrow to load previous command')
				add_outline(data.outlines, '')

----help commands----
				elseif exec_command == "help" then
					local help_command = exec_all[2]
					if help_command == "cls" then
						add_outline(data.outlines, tty.." CLS     Clears the screen.")
						add_outline(data.outlines, '')
					elseif help_command == "date" then
						add_outline(data.outlines, tty.." DATE    Displays the current system date.")
						add_outline(data.outlines, '')
					elseif help_command == "datetime" then
						add_outline(data.outlines, tty.." DATETIME    Displays the current system date and time.")
						add_outline(data.outlines, '')
--					elseif help_command == "exit" then
--						add_outline(data.outlines, tty.." EXIT    Exits CS-BOS.")
						add_outline(data.outlines, '')
					elseif help_command == "help" then
						add_outline(data.outlines, tty.." HELP    Displays HELP menu. HELP [command} displays help on that command.")
						add_outline(data.outlines, '')
					elseif help_command == "mem" then
						add_outline(data.outlines, tty.." MEM    Displays memory usage table.")
						add_outline(data.outlines, '')
					elseif help_command == "time" then
						add_outline(data.outlines, tty.." TIME    Displays the current system time.")
						add_outline(data.outlines, '')
					elseif help_command == "timedate" then
						add_outline(data.outlines, tty.." TIMEDATE    Displays the current system time and date.")
						add_outline(data.outlines, '')
					elseif help_command == "todo" then
						add_outline(data.outlines, tty.." TODO      View TODO list for CS-BOS")
						add_outline(data.outlines, '')
					elseif help_command == "ver" then
						add_outline(data.outlines, tty.." VER    Displays CS-BOS version.")
						add_outline(data.outlines, '')
----main help command--
					elseif help_command == nil then
						add_outline(data.outlines, tty..'These shell commands are defined internally.')
						add_outline(data.outlines, '')
						add_outline(data.outlines, tty..' CLS       Clears the screen.')
						add_outline(data.outlines, tty..' DATE      Displays the current system date.')
		--				add_outline(data.outlines, tty..' EXIT      EXITS CS-BOS.')
						add_outline(data.outlines, tty..' HELP      Displays HELP menu. HELP [command} displays help on that command.')
						add_outline(data.outlines, tty..' MEM       Displays memory usage table.')
						add_outline(data.outlines, tty..' TIME      Displays the current system time.')
						add_outline(data.outlines, tty..' TIMEDATE  Displays the current system time and date.')
						add_outline(data.outlines, tty..' TODO      View TODO list for CS-BOS')
						add_outline(data.outlines, tty..' VER     Displays CS-BOS version.')
						add_outline(data.outlines, '')	
					else
						add_outline(data.outlines, tty.."?SYNTAX ERROR")
						add_outline(data.outlines, '')
					end
----end help commands----
			else
				add_outline(data.outlines, tty.."?SYNTAX ERROR")
				add_outline(data.outlines, '')
			end
		end
	end,


})
