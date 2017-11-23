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
