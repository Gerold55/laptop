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
		formspec = formspec..'background[0,0;15,10;'..self.os.theme.app_bg..';true]'
	end
	if #self.os.appdata.os.stack > 1 then
		formspec = formspec..'image_button[0,-0.3;1,0.5;'..self.os.theme.back_button..';os_back;<<<]' --TODO: if stack exists
	end
	if self.app_info then
		formspec = formspec.."label[1,-0.3;"..self.app_info.."]"
	end
	formspec = formspec..'image_button[14,-0.3;1,0.5;'..self.os.theme.exit_button..';os_exit;X]'
	return formspec..app_result
end

-- internally used: process input
function app_class:receive_fields(fields, sender)
	local ret
	if self.receive_fields_func then
		ret = self.receive_fields_func(self, self.os, fields, sender)
	end

	if fields.os_back then
		self:back_app()
	elseif fields.os_exit then
		self:exit_app()
	end
	return ret
end

-- Get persitant storage table
function app_class:get_storage_ref(app_name)
	local store_name = app_name or self.name
	if not self.os.appdata[store_name] then
		self.os.appdata[store_name] = {}
	end
	return self.os.appdata[store_name]
end

function app_class:back_app()
	local stacksize = #self.os.appdata.os.stack

	-- pop stack
	if stacksize > 0 then
		self.os.appdata.os.stack[stacksize] = nil
		stacksize = #self.os.appdata.os.stack
	end

	if stacksize == 0 then
		self.os:set_app() -- launcher
	else
		self.os:set_app(self.os.appdata.os.stack[stacksize])
	end
end

function app_class:exit_app()
	self.os.appdata.os.stack = {}
	self.os:set_app() -- launcher
end

-- Register new app
function laptop.register_app(name, def)
	laptop.apps[name] = def
end

-- Register new app
function laptop.register_view(name, def)
	def.view = true
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
