
laptop.register_app("launcher", {
--	app_name = "Main launcher", -- not in launcher list
	fullscreen = true,
	formspec_func = function(launcher_app, os)
		local c_row_count = 4

		local i = 0
		local out = "size[15,10]"
		if os.theme.launcher_bg then
			out = out..'background[15,10;0,0;'..os.theme.launcher_bg..';true]'
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
			out = out .. 'image_button['..x..','..y..';1,1;'..os.theme.app_button..'^'..(e.def.app_icon or 'logo.png')..';'..e.name..';]'..
						'label['..(x-0.3)..','..(y+1)..';'..e.def.app_name..']'..
						'tooltip['..e.name..';'..(e.def.app_info or e.name)..']'    --;<bgcolor>;<fontcolor>]'
		end
		return out
	end,
	appwindow_formspec_func = function(launcher_app, app, os)
		local formspec = 'size[15,10]'
		if os.theme.app_bg then
			formspec = formspec..'background[0,0;15,10;'..os.theme.app_bg..';true]'
		end
		if #os.appdata.os.stack > 0 then
			formspec = formspec..'image_button[-0.29,-0.31;1.09,0.61;'..os.theme.back_button..';os_back;<]' --TODO: if stack exists
		end
		if app.app_info then
			if #os.appdata.os.stack > 0 then
				formspec = formspec.."label[0.8,-0.29;"..app.app_info.."]"
			else
				formspec = formspec.."label[-0.1,-0.29;"..app.app_info.."]"
			end
		end
		formspec = formspec..'image_button[14.2,-0.31;1.09,0.61;'..os.theme.exit_button..';os_exit;X]'
		return formspec
	end,
	receive_fields_func = function(launcher_app, os, fields, sender)
		for name, descr in pairs(fields) do
			if laptop.apps[name] then
				os:set_app(name)
				break
			end
		end
	end
})
