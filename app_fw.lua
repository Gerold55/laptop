laptop.apps = {}

local app_class = {}
app_class.__index = app_class

-- internally used: get current app formspec
function app_class:get_formspec()

	local app_result
	if  self.formspec_func then
		app_result = self.formspec_func(self, self.os)
	else
		app_result = ""
	end

	if self.fullscreen then
		return app_result
	end

	local formspec = 'size[15,10]'
	if self.os.theme.app_bg then
		formspec = formspec..'background[15,10;0,0;'..self.os.theme.app_bg..';true]'
	end
	return formspec..app_result
end

-- internally used: process input
function app_class:receive_fields(fields, sender)
	if self.receive_fields_func then
		return self.receive_fields_func(self, self.os, fields, sender)
	end
end

-- Get persitant storage table
function app_class:get_storage_ref(app_name)
	local store_name = app_name or self.name
	if not self.os.appdata[store_name] then
		self.os.appdata[store_name] = {}
	end
	return self.os.appdata[store_name]
end

-- Register new app
function laptop.register_app(name, def)
	laptop.apps[name] = def
end

-- Get app instance for object
function laptop.get_app(name, os)
	local template = laptop.apps[name]
	if not template then
		return
	end
	local app = setmetatable(table.copy(template), app_class)
	app.name = name
	app.os = os
	return app
end

-- load all apps
local app_path = minetest.get_modpath('laptop')..'/apps/'
local app_list = minetest.get_dir_list(app_path, false)

for _, file in ipairs(app_list) do
	if file:sub(-8) == '_app.lua' then
		dofile(app_path..file)
	end
end
