laptop.apps = {}

local app_class = {}
app_class.__index = app_class

function app_class:get_formspec()
	if self.formspec_func then
		return 'size[15,10]'..
				'background[15,10;0,0;os_main2.png;true]'..
				'bgcolor[#00000000;false]'..
		self.formspec_func(self, self.os)
	else
		return ""
	end
end

function app_class:receive_fields(fields, sender)
	if self.receive_fields_func then
		return self.receive_fields_func(self, self.os, fields, sender)
	end
end


--[[ ********** App API definition  ***********
	* methods
	app.formspec_func(app, os)
	app.receive_fields_func(app, os, fields, sender)

	* attributes
	app.app_name - displayed string. If not given it is just a view, not listed in apps list
 ****************************************** ]]


function laptop.register_app(name, def)
	laptop.apps[name] = def
end

function laptop.get_app(name, os)
	local app = laptop.apps[name]
	if not app then
		return
	end
	app = setmetatable(app, app_class)
	app.os = os
	return app
end

------------------------------------------------------------------------
laptop.register_app("launcher", {
--	app_name = "Main launcher", -- not in launcher list
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

laptop.register_app("demo1", {
	app_name = "Demo App",
	formspec_func = function(app, os)
	print("formspec_func")
		return 'button[5,5;3,1;Back;Back to launcher]'
	end,
	receive_fields_func = function(app, os, fields, sender)
		os:set_app("launcher")
	end
})

laptop.register_app("demo2", {
	app_name = "Demo App 2",
	formspec_func = function(app, os)
		return 'button[3,3;5,1;Back;Back to launcher]'
	end,
	receive_fields_func = function(app, os, fields, sender)
		os:set_app("launcher")
	end
})
