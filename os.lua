-----------------------------------------------------
-- Operating System class
-----------------------------------------------------
local os_class = {}
os_class.__index = os_class

-- Power on the system / initialize formspec and so
function os_class:power_on(new_node_name)
	if new_node_name then
		local node = minetest.get_node(self.pos)
		node.name = new_node_name
		minetest.swap_node(self.pos, node )
	end
	self:set_app("launcher") -- allways start with launcher after power on
end

-- Power off the system
function os_class:power_off(new_node_name)
	if new_node_name then
		local node = minetest.get_node(self.pos)
		node.name = new_node_name
		minetest.swap_node(self.pos, node )
	end
	self.meta:set_string('formspec', "")
end

-- Set infotext for system
function os_class:set_infotext(infotext)
	self.meta:set_string('infotext', infotext)
end

function os_class:save()
	self.meta:set_string('laptop_appdata', minetest.serialize(self.appdata))
end

-- Set infotext for system
function os_class:set_app(appname)
	if not appname then
		appname = "launcher"
	end
	self.appdata.launcher.current_app = appname
	local app = laptop.get_app(appname, self)
	self.meta:set_string('formspec', app:get_formspec())
	self:save()
end

function os_class:receive_fields(fields, sender)
	local appname = self.appdata.launcher.current_app or "launcher"
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
	local self = {}
	setmetatable(self, os_class)
	self.__index = os_class
	self.pos = pos
	self.meta = minetest.get_meta(pos)
	self.appdata = minetest.deserialize(self.meta:get_string('laptop_appdata')) or {}
	self.appdata.launcher = self.appdata.launcher or {}
	return self
end
