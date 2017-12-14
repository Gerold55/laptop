local mod_storage = minetest.get_mod_storage()

local bdev = {}

-- Check hardware capabilities { "hdd", "floppy", "usb", "net", "liveboot" }
function bdev:is_hw_capability(hw_cap)
	for i, cap in ipairs(self.os.hwdef.hw_capabilities) do
		if cap == hw_cap or cap == hw_cap:sub(18, -1) then  --"laptop_removable_*"then
			return cap
		end
	end
	return false
end

-- Get RAM
function bdev:get_ram_disk()
	if not self.ram_disk then
		self.ram_disk = minetest.deserialize(self.os.meta:get_string('laptop_ram')) or {}
	end
	return self.ram_disk
end

function bdev:free_ram_disk()
	self.os.meta:set_string('laptop_ram','')
	self.ram_disk = nil
end


-- Get HDD if exists
function bdev:get_hard_disk()
	if self.hard_disk == nil then
		if self:is_hw_capability('hdd') then
			self.hard_disk = minetest.deserialize(self.os.meta:get_string('laptop_appdata')) or {}
		else
			self.hard_disk = false
		end
	end
	return self.hard_disk
end

-- Get Removable disk if exists
function bdev:get_removable_disk(removable_type)
	if self.removable_disk == nil then
		local inv = self.os.meta:get_inventory()
		inv:set_size("main", 1) -- 1 disk supported
		local stack = inv:get_stack("main", 1)
		local is_compatible = false
		if stack then
			local def = stack:get_definition()
			local rtype
			if def and def.name ~= "" then
				for group, _ in pairs(def.groups) do
					if not removable_type or removable_type == self:is_hw_capability(group) then
						is_compatible = true
					end
				end
			end

			if is_compatible then
				local stackmeta = stack:get_meta()
				local os_format = stackmeta:get_string("os_format")
				if os_format == "" then
					os_format = "none"
				end
				local data = {
					inv = inv,
					def = def,
					stack = stack,
					meta = stackmeta,
					os_format = os_format,
					rtype = rtype,
					storage = minetest.deserialize(stackmeta:get_string("os_storage")) or {},
				}
				data.label = data.meta:get_string("description")
				if not data.label or data.label == "" then
					data.label = def.description
				end
				self.removable_disk = data
			end
		end
	end
	return self.removable_disk
end

-- Connect to cloud
function bdev:get_cloud_disk(store_name)
	if self.cloud_disk == nil or (self.cloud_disk ~= false and not self.cloud_disk[store_name]) then
		if self:is_hw_capability('net') then
			self.cloud_disk = self.cloud_disk or {}
			self.cloud_disk[store_name] = minetest.deserialize(mod_storage:get_string(store_name)) or {}
		else
			self.cloud_disk = false
			return false
		end
	end
	return self.cloud_disk[store_name]
end

-- Get device to boot
function bdev:get_boot_disk()
	if self:is_hw_capability('liveboot') then
		local removable = self:get_removable_disk()
		if removable and removable.os_format == 'boot' then
			return 'removable'
		end
	end
	return 'hdd'
end

-- Get app related object from storage "disk_type"
function bdev:get_app_storage(disk_type, store_name)
	if disk_type == 'ram' then
		local store = self:get_ram_disk()
		store[store_name] = store[store_name] or {}
		return store[store_name]
	elseif disk_type == 'hdd' then
		local store = self:get_hard_disk()
		if store then
			store[store_name] = store[store_name] or {}
			return store[store_name]
		else
			return nil
		end
	elseif disk_type == 'removable' then
		local store = self:get_removable_disk()
		if store and (store.os_format == 'data' or store.os_format == 'boot') then
			store.storage[store_name] = store.storage[store_name] or {}
			return store.storage[store_name]
		else
			return nil
		end
	elseif disk_type == 'system' then
		if self.system_disk == nil then
			local ram = self:get_ram_disk()
			local boot
			if ram.os then
				boot = ram.os.booted_from
			end
			boot = boot or self:get_boot_disk()
			self.system_disk = self:get_app_storage(boot, store_name)
		end
		return self.system_disk
	elseif disk_type == 'cloud' then
		return self:get_cloud_disk(store_name) or nil
	end
end


-- Save all data if used
function bdev:sync()
	-- save RAM
	self.os.meta:set_string('laptop_ram', minetest.serialize(self.ram_disk))

	-- save HDD
	if self.hard_disk then
		self.os.meta:set_string('laptop_appdata', minetest.serialize(self.hard_disk))
	end

	-- save removable
	if self.removable_disk then
		local data = self.removable_disk
		if data.label ~= data.def.description then
			data.meta:set_string("description", data.label)
		end
		data.meta:set_string("os_storage", minetest.serialize(data.storage))
		data.inv:set_stack("main", 1, data.stack)
	end

	-- Modmeta (Cloud)
	if self.cloud_disk then
		for store, value in pairs(self.cloud_disk) do
			mod_storage:set_string(store, minetest.serialize(value))
		end
	end
end

-- Get handler
function laptop.get_bdev_handler(mtos)
	local bdevobj = table.copy(bdev)
	bdevobj.os = mtos
	return bdevobj
end



