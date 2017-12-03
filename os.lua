-----------------------------------------------------
-- Operating System class
-----------------------------------------------------
local os_class = {}
os_class.__index = os_class

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
	self:set_app("launcher")
end

-- Power on the system / and resume last running app
function os_class:resume(new_node_name)
	if new_node_name then
		self:swap_node(new_node_name)
	end
	self:set_app(self.appdata.launcher.current_app)
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

-- Save the data
function os_class:save()
	self.appdata.launcher.custom = self.custom_launcher
	self.meta:set_string('laptop_appdata', minetest.serialize(self.appdata))
end

-- Get given or current theme
function os_class:get_theme(theme)
	local theme_sel = theme or self.appdata.launcher.theme
	local ret = table.copy(laptop.themes.default)
	if theme_sel and laptop.themes[theme_sel] then
		for k,v in pairs(laptop.themes[theme_sel]) do
			ret[k] = v
		end
		ret.name = theme_sel
	else
		ret.name = "default"
	end
	return ret
end

-- Set current theme
function os_class:set_theme(theme)
	if laptop.themes[theme] then
		self.appdata.launcher.theme = theme
		self.theme = self:get_theme()
		self:save()
	end
end

-- Set infotext for system
function os_class:set_app(appname)
	local name = appname or "launcher"

	if name == "launcher" and self.custom_launcher then
		name = self.custom_launcher
	end
	self.appdata.launcher.current_app = name
	local app = laptop.get_app(name, self)
	self.meta:set_string('formspec', app:get_formspec())
	self:save()
end

function os_class:receive_fields(fields, sender)
	local appname = self.appdata.launcher.current_app or self.custom_launcher or "launcher"
	local app = laptop.get_app(appname, self)
	app:receive_fields(fields, sender)
	if self.appdata.launcher.current_app == appname then
		self.meta:set_string('formspec', app:get_formspec())
	end
	self:save()
end

-----------------------------------------------------
-- Get Operating system object
-----------------------------------------------------
function laptop.os_get(pos)
	local self = setmetatable({}, os_class)
	self.__index = os_class
	self.pos = pos
	self.meta = minetest.get_meta(pos)
	self.appdata = minetest.deserialize(self.meta:get_string('laptop_appdata')) or {}
	self.appdata.launcher = self.appdata.launcher or {}
	self.custom_launcher = self.appdata.launcher.custom
	self.theme = self:get_theme()
	return self
end

-----------------------------------------------------
-- Hooks for node definition
-----------------------------------------------------
function laptop.after_place_node(pos, placer, itemstack, pointed_thing)
	local appdata = minetest.deserialize(itemstack:get_meta():get_string("laptop_appdata"))
	if appdata then
		local os = laptop.os_get(pos)
		os.appdata = appdata
		os:save()
	end
end

function laptop.after_dig_node(pos, oldnode, oldmetadata, digger)
	local appdata = oldmetadata.fields['laptop_appdata']
	if appdata then
		local item_name = minetest.registered_items[oldnode.name].drop or oldnode.name
		local inventory = digger:get_inventory()
		for idx = inventory:get_size("main"), 1, -1 do
			local stack = inventory:get_stack("main", idx)
			if stack:get_name() == item_name and stack:get_meta():get_string("laptop_appdata") == "" then
				stack:get_meta():set_string("laptop_appdata", appdata)
				digger:get_inventory():set_stack("main", idx, stack)
				break
			end
		end
	end
end
