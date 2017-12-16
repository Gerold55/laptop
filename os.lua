-----------------------------------------------------
-- Operating System class
-----------------------------------------------------
local os_class = {}
os_class.__index = os_class
laptop.class_lib.os = os_class

-- Swap the node
function os_class:swap_node(new_node_name)
	local node = minetest.get_node(self.pos)
	if new_node_name then
		node.name = new_node_name
		self.hwdef = laptop.node_config[self.node.name]
	end
	if self.hwdef.paramtype2 == "colorfacedir" then
		local fdir = math.floor(node.param2 % 32)
		node.param2 = fdir + self.theme.node_color * 32
	end
	self:set_infotext(self.hwdef.infotext)
	minetest.swap_node(self.pos, node)
end

-- Power on the system and start the launcher
function os_class:power_on(new_node_name)
	self.bdev:free_ram_disk()
	-- update current instance with reinitialized data
	for k,v in pairs(laptop.os_get(self.pos)) do
		self[k] = v
	end
	self.sysram.state = 'on'
	self:swap_node(new_node_name)
	self:set_app() --launcher
end

-- Power on the system / and resume last running app
function os_class:resume(new_node_name)
	self:swap_node(new_node_name)
	self.sysram.state = 'on'
	self:set_app(self.sysram.current_app)
end

-- Power off the system
function os_class:power_off(new_node_name)
	self:swap_node(new_node_name)
	self.meta:set_string('formspec', "")
	self.sysram.state = 'off'
	self:save()
end

-- Set infotext for system
function os_class:set_infotext(infotext)
	self.meta:set_string('infotext', infotext)
end

-- Get given or current theme
function os_class:get_theme(theme)
	if not theme and self.sysdata then
		theme = self.sysdata.theme
	end
	return laptop.get_theme(theme)
end

-- Set current theme
function os_class:set_theme(theme)
	if laptop.themes[theme] then
		self.sysdata.theme = theme
		self.theme = self:get_theme()
		self:swap_node()
		self:save()
	end
end

-- Add app to stack (before starting new)
function os_class:appstack_add(appname)
	table.insert(self.sysram.stack, appname)
end

-- Get last app from stack
function os_class:appstack_pop()
	local ret
	if #self.sysram.stack > 0 then
		ret = self.sysram.stack[#self.sysram.stack]
		table.remove(self.sysram.stack, #self.sysram.stack)
	end
	return ret
end

-- Free stack
function os_class:appstack_free()
	self.sysram.stack = {}
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
	elseif self.sysram.current_app and
			self.sysram.current_app ~= launcher and
			self.sysram.current_app ~= newapp then
		self:appstack_add(self.sysram.current_app)
	end
	self.sysram.current_app = newapp
	local app = self:get_app(newapp)
	local formspec = app:get_formspec()
	if formspec ~= false then
		self.meta:set_string('formspec', formspec)
	end
	self:save()
end

-- Handle input processing
function os_class:pass_to_app(method, reshow, sender, ...)
	local appname = self.sysram.current_app or self.hwdef.custom_launcher or "launcher"
	local app = self:get_app(appname)
	local ret = app:receive_data(method, reshow, sender, ...)
	self.sysram.last_player = sender:get_player_name()
	if self.sysram.current_app == appname and reshow and self.sysram.state == 'on' then
		local formspec = app:get_formspec()
		if formspec ~= false then
			self.meta:set_string('formspec', formspec)
		end
	end
	self:save()
	return ret
end

function os_class:save()
	self.bdev:sync()
end

-- Use parameter and launch the select_file dialog
-- Return values will be send as fields to the called app
function os_class:select_file_dialog(param)
	local store = self.bdev:get_app_storage('ram', 'os:select_file')
	store.param = param
	self:set_app('os:select_file')
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
	if not self.hwdef then
		return nil -- not compatible node
	end
	self.meta = minetest.get_meta(pos)
	self.bdev = laptop.get_bdev_handler(self)
	self.sysram = self.bdev:get_app_storage('ram', 'os')
	self.sysram.stack = self.sysram.stack or {}
	self.sysdata = self.bdev:get_app_storage('system', 'os')
	self.theme = self:get_theme()
	return self
end
