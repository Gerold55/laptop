
laptop.register_app("launcher", {
--	app_name = "Main launcher", -- not in launcher list
	fullscreen = true,
	formspec_func = function(launcher_app, mtos)

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

		local c_row_count = 4

		local i = 0
		local out = "size[15,10]"
		if mtos.theme.launcher_bg then
			out = out..'background[15,10;0,0;'..mtos.theme.launcher_bg..';true]'
		end
		local appslist_sorted = {}
		for name, def in pairs(laptop.apps) do
			if def.app_name and not def.view then
				table.insert(appslist_sorted, {name = name, def = def})
			end
		end
		table.sort(appslist_sorted, function(a,b) return a.name < b.name end)
		for i, e in ipairs(appslist_sorted) do
			local x = math.floor((i-1) / c_row_count)*2 + 1
			local y = ((i-1) % c_row_count)*2 + 1
			out = out .. mtos.theme:get_image_button(x..','..y..';1,1', 'app', e.name, (e.def.app_icon or 'logo.png'), "", (e.def.app_info or e.name))..
						mtos.theme:get_label((x-0.3)..','..(y+1), e.def.app_name, "app")
		end
		out = out..mtos.theme:get_button("11,9.8;4,0.7", "major", "os_clock", os.date("%c"))
		return out
	end,
	appwindow_formspec_func = function(launcher_app, app, mtos)
		local formspec = 'size[15,10]'
		if mtos.theme.app_bg then
			formspec = formspec..'background[0,0;15,10;'..mtos.theme.app_bg..';true]'
		end
		if #mtos.sysram.stack > 0 then
			formspec = formspec..mtos.theme:get_button('-0.29,-0.31;1.09,0.61', 'back', 'os_back', '<', 'Return to previous screen')
		end
		if app.app_info then
			if #mtos.sysram.stack > 0 then
				formspec = formspec.."label[0.8,-0.29;"..app.app_info.."]"
			else
				formspec = formspec.."label[-0.1,-0.29;"..app.app_info.."]"
			end
		end
		formspec = formspec..mtos.theme:get_button('14.2,-0.31;1.09,0.61', 'exit', 'os_exit', 'X', 'Exit app')
		return formspec
	end,
	receive_fields_func = function(launcher_app, mtos, sender, fields)
		for name, descr in pairs(fields) do
			if laptop.apps[name] then
				mtos:set_app(name)
				break
			end
		end
	end,
})
