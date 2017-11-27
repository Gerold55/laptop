
laptop.register_app("launcher", {
--	app_name = "Main launcher", -- not in launcher list
	background_img = "laptop_os_main2.png",
	formspec_func = function(app, os)
		local c_row_count = 4

		local i = 0
		local out = ""
		local appslist_sorted = {}
		for name, def in pairs(laptop.apps) do
			if def.app_name then
				table.insert(appslist_sorted, {name = name, def = def})
			end
		end
		table.sort(appslist_sorted, function(a,b) return a.name < b.name end)
		for i, e in ipairs(appslist_sorted) do
			local x = math.floor((i-1) / c_row_count)*2 + 1
			local y = ((i-1) % c_row_count)*2 + 1
			out = out .. 'image_button['..x..','..y..';1,1;'..(e.def.app_icon or 'logo.png')..';'..e.name..';]'..
						'label['..(x-0.5)..','..(y+1)..';'..e.def.app_name..']'..
						'tooltip['..e.name..';'..(e.def.app_info or e.name)..']'    --;<bgcolor>;<fontcolor>]'
		end
		return out
	end,
	receive_fields_func = function(app, os, fields, sender)
		for name, descr in pairs(fields) do
			if laptop.apps[name] then
				os:set_app(name)
				break
			end
		end
	end
})
