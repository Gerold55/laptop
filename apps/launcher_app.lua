
laptop.register_app("launcher", {
--	app_name = "Main launcher", -- not in launcher list
	background_img = "os_main2.png",
	formspec_func = function(app, os)
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
			out = out .. 'button['..2*i..',1;2,1;'..e.name..';'..e.def.app_name..']'
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
