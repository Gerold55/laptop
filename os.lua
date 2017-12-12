-----------------------------------------------------
-- Operating System class
-----------------------------------------------------
local os_class = {}
os_class.__index = os_class
laptop.class_lib.os = os_class

local mod_storage = minetest.get_mod_storage()

-- Swap the node
function os_class:swap_node(new_node_name)
	local node = minetest.get_node(self.pos)
	node.name = new_node_name
	minetest.swap_node(self.pos, node)
end

-- Power on the system and start the launcher
function os_class:power_on(new_node_name)
	if new_node_name then
		self:swap_node(new_node_name)
	end
	self:set_app() --launcher
end

-- Power on the system / and resume last running app
function os_class:resume(new_node_name)
	if new_node_name then
		self:swap_node(new_node_name)
	end
	self:set_app(self.appdata.os.current_app)
end

-- Power off the system
function os_class:power_off(new_node_name)
	if new_node_name then
		self:swap_node(new_node_name)
	end
	self.meta:set_string('formspec', "")
	self:save()
end

-- Set infotext for system
function os_class:set_infotext(infotext)
	self.meta:set_string('infotext', infotext)
end

-- Get given or current theme
function os_class:get_theme(theme)
	local theme_sel = theme or self.appdata.os.theme
	return laptop.get_theme(theme_sel)
end

-- Set current theme
function os_class:set_theme(theme)
	if laptop.themes[theme] then
		self.appdata.os.theme = theme
		self.theme = self:get_theme()
		self:save()
	end
end

-- Add app to stack (before starting new)
function os_class:appstack_add(appname)
	table.insert(self.appdata.os.stack, appname)
end

-- Get last app from stack
function os_class:appstack_pop()
	local ret
	if #self.appdata.os.stack > 0 then
		ret = self.appdata.os.stack[#self.appdata.os.stack]
		table.remove(self.appdata.os.stack, #self.appdata.os.stack)
	end
	return ret
end

-- Free stack
function os_class:appstack_free()
	self.appdata.os.stack = {}
end

-- Get new app instance
function os_class:get_app(name)
	local template = laptop.apps[name]
	if not template then
		return
	end
	local app = setmetatable(table.copy(template), laptop.class_lib.app)
	app.name = name
	app.os = self
	return app
end

-- Activate the app
function os_class:set_app(appname)
	local launcher = self.hwdef.custom_launcher or "launcher"
	local newapp = appname or launcher
	if newapp == launcher then
		self:appstack_free()
	elseif self.appdata.os.current_app and
			self.appdata.os.current_app ~= launcher and
			self.appdata.os.current_app ~= newapp then
		self:appstack_add(self.appdata.os.current_app)
	end

	self.appdata.os.current_app = newapp
	local app = self:get_app(newapp)
	local formspec = app:get_formspec()
	if formspec ~= false then
		self.meta:set_string('formspec', formspec)
	end
	self:save()
end

-- Handle input processing
function os_class:pass_to_app(method, reshow, sender, ...)
	local appname = self.appdata.os.current_app or self.hwdef.custom_launcher or "launcher"
	local app = self:get_app(appname)
	local ret = app:receive_data(method, reshow, sender, ...)
	self.appdata.os.last_player = sender:get_player_name()
	if self.appdata.os.current_app == appname and reshow then
		local formspec = app:get_formspec()
		if formspec ~= false then
			self.meta:set_string('formspec', formspec)
		end
	end
	self:save()
	return ret
end

-- Get Low-Level access to inventory slot
function os_class:get_removable_data()
	self.removable_data = nil
	local inv = self.meta:get_inventory()
	inv:set_size("main", 1) -- 1 disk supported
	local stack = inv:get_stack("main", 1)
	if stack then
		local def = stack:get_definition()
		if def and def.name ~= "" then
			local data = {
				inv = inv,
				def = def,
				stack = stack,
				meta = stack:get_meta()
			}

			data.label = data.meta:get_string("description")
			if not data.label or data.label == "" then
				data.label = def.description
			end
			self.removable_data = data
			return data
		end
	end
end

-- Store data to inventory slot item (low-level)
function os_class:set_removable_data()
	if self.removable_data then
		local data = self.removable_data
		if data.label ~= data.def.description then
			data.meta:set_string("description", data.label)
		end
		data.inv:set_stack("main", 1, data.stack)
	end
end

-- Get mod storage as (=internet / cloud)
function os_class:connect_to_cloud(store_name)
	self.cloud_store = self.cloud_store or {}
	self.cloud_store[store_name] = self.cloud_store[store_name] or
			minetest.deserialize(mod_storage:get_string(store_name)) or {}
	return self.cloud_store[store_name]
end

-- Save the data
function os_class:save()
	self.meta:set_string('laptop_appdata', minetest.serialize(self.appdata))
	if self.cloud_store then
		for store, value in pairs(self.cloud_store) do
			mod_storage:set_string(store, minetest.serialize(value))
		end
		self.cloud_store = nil
	end

	if self.removable_store then
		local data = self:get_removable_data()
		if data then
			for store, value in pairs(self.removable_store) do
				data.meta:set_string(store, minetest.serialize(value))
			end
		end
		self.removable_store = nil
	end
end

-----------------------------------------------------
-- Get Operating system object
-----------------------------------------------------
function laptop.os_get(pos)
	local self = setmetatable({}, os_class)
	self.__index = os_class
	self.pos = pos
	self.node = minetest.get_node(pos)
	self.hwdef = laptop.node_config[self.node.name]
	self.meta = minetest.get_meta(pos)
	self.appdata = minetest.deserialize(self.meta:get_string('laptop_appdata')) or {}
	self.appdata.launcher = self.appdata.launcher or {}
	self.appdata.os = self.appdata.os or {}
	self.appdata.os.stack = self.appdata.os.stack or {}
	self.theme = self:get_theme()
	return self
end
