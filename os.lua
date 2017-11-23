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
	self.meta:set_string('formspec', 'size[15,10]'..
	'background[15,10;0,0;os_main2.png;true]'..
	'bgcolor[#00000000;false]')
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

-----------------------------------------------------
-- Get Operating system object
-----------------------------------------------------
function laptop.os_get(pos)
	local os = {}
	setmetatable(os, os_class)
	os.__index = os_class
	os.pos = pos
	os.meta = minetest.get_meta(pos)


	return os
end
