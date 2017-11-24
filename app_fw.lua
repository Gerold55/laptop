laptop.apps = {}

local app_class = {}
app_class.__index = app_class

function app_class:get_formspec()
	if self.formspec_func then
		local app_result = self.formspec_func(self, self.os)
		local formspec = 'size[15,10]'
		if self.background_img then
			formspec = formspec..'background[15,10;0,0;'..self.background_img..';true]'
		end
		return formspec..app_result
	else
		return ""
	end
end

function app_class:receive_fields(fields, sender)
	if self.receive_fields_func then
		return self.receive_fields_func(self, self.os, fields, sender)
	end
end

function app_class:sync_storage()
	if self.background_img then
		local data = self:get_storage_ref()
		data._background_img = self.background_img
	elseif self.os.appdata[self.name] then
		self.os.appdata[self.name]._background_img = self.background_img
		-- remove table if empty
		if not next(self.os.appdata[self.name]) then
			self.os.appdata[self.name] = nil
		end
	end
end

function app_class:get_storage_ref()
	if not self.os.appdata[self.name] then
		self.os.appdata[self.name] = {}
	end
	return self.os.appdata[self.name]
end

function laptop.register_app(name, def)
	laptop.apps[name] = def
end

function laptop.get_app(name, os)
	local template = laptop.apps[name]
	if not template then
		return
	end
	local app = setmetatable(table.copy(template), app_class)
	app.name = name
	app.os = os
	if os.appdata[name] then
		app.background_img = os.appdata[name]._background_img or app.background_img
	end
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
