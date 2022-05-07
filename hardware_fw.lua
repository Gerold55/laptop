
laptop.node_config = {}

local have_technic = minetest.get_modpath("technic")
local have_generator = minetest.get_modpath("power_generators")

local function on_construct(pos)
	laptop.mtos_cache:free(pos)
	local mtos = laptop.os_get(pos)
	local node = minetest.get_node(pos)
	local hwdef = laptop.node_config[node.name]
	if hwdef.custom_theme then -- initial only
		mtos:set_theme(hwdef.custom_theme)
	end
	if hwdef.hw_state then
		mtos[hwdef.hw_state](mtos)
	else
		mtos:power_off()
	end
end

local function on_punch(pos, node, puncher)
	local mtos = laptop.os_get(pos)

	local punch_item = puncher:get_wielded_item()
	local is_compatible = false
	if punch_item then
		local def = punch_item:get_definition()
		for group, _ in pairs(def.groups) do
			if mtos.bdev:is_hw_capability(group) then
				is_compatible = true
			end
		end
	end

	if is_compatible then
		local slot = mtos.bdev:get_removable_disk()
		-- swap
		puncher:set_wielded_item(slot.stack)
		-- reload OS
		slot:reload(punch_item)
		laptop.mtos_cache:sync_and_free(mtos)
		for k,v in pairs(laptop.os_get(mtos.pos)) do
			mtos[k] = v
		end
		mtos:pass_to_app("punched_by_removable", true, puncher, punch_item)
		return
	end

	local hwdef = laptop.node_config[node.name]
	if hwdef.next_node then
		local hwdef_next = laptop.node_config[hwdef.next_node]
		if hwdef_next.hw_state then
			mtos[hwdef_next.hw_state](mtos, hwdef.next_node)
		else
			mtos:swap_node(hwdef.next_node)
			mtos:save()
		end
	end
end

local function on_receive_fields(pos, formname, fields, sender)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("receive_fields_func", true, sender, fields)
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_move", false, player, from_list, from_index, to_list, to_index, count) or 0
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	local def = stack:get_definition()
	local allowed_stacksize = 0
	if def then
		for group, _ in pairs(def.groups) do
			if mtos.bdev:is_hw_capability(group) then
				allowed_stacksize = 1
			end
		end
	end
	return mtos:pass_to_app("allow_metadata_inventory_put", false, player, listname, index, stack) or allowed_stacksize
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_take", false, player, listname, index, stack) or 1 -- by default removal allowed
end

local function on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("on_metadata_inventory_move", true, player, from_list, from_index, to_list, to_index, count)
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("on_metadata_inventory_put", true, player, listname, index, stack)
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("on_metadata_inventory_take", true, player, listname, index, stack)
end

local function on_timer(pos, elapsed)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("on_timer", true, nil, elapsed)
end

local function after_place_node(pos, placer, itemstack, pointed_thing)
	local save = minetest.deserialize(itemstack:get_meta():get_string("laptop_metadata"))
	if not save then
		return
	end

	-- Backwards compatibility code
	if save.fields then
		laptop.mtos_cache:free(pos)
		local meta = minetest.get_meta(pos)
		meta:from_table({fields = save.fields})
		for invname, inv in pairs(save.invlist) do
			meta:get_inventory():set_list(invname, inv)
		end
		itemstack:clear()
		return
	end
	-- Backwards compatibility code end

	local mtos = laptop.os_get(pos)
	mtos.bdev.ram_disk = save.ram_disk or mtos.bdev.ram_disk
	mtos.bdev.hard_disk = save.hard_disk or mtos.bdev.hard_disk

	if save.removable_disk then
		local removable = mtos.bdev:get_removable_disk()
		removable:reload(ItemStack(save.removable_disk))
	end
	
	-- battery support
	if have_technic or have_generator then
		local node = minetest.get_node(pos)
		local hwdef = laptop.node_config[node.name]
		if hwdef.battery_capacity then
			local metadata = minetest.deserialize(itemstack:get_metadata())
			if metadata and metadata.charge then
				local meta = minetest.get_meta(pos)
				meta:set_int("battery", metadata.charge)
			end
		end
	end

	mtos.bdev:sync()
	itemstack:clear()
end

local function preserve_metadata(pos, oldnode, oldmetadata, drops)
	local mtos = laptop.os_get(pos)
	if not mtos then
		return
	end

	laptop.mtos_cache:sync_and_free(mtos)

	local removable = mtos.bdev:get_removable_disk()

	local save = {
		laptop_ram = mtos.bdev:get_ram_disk(),
		hard_disk = mtos.bdev:get_hard_disk(),
		removable_disk = removable.stack and removable.stack:to_string()
	}

	local item_name = minetest.registered_items[oldnode.name].drop or oldnode.name
	for _, stack in pairs(drops) do
		if stack:get_name() == item_name then
			stack:get_meta():set_string("laptop_metadata", minetest.serialize(save))
			if have_technic or have_generator then
				local hwdef = laptop.node_config[oldnode.name]
				if hwdef.battery_capacity then
					stack:set_metadata(minetest.serialize({charge=tonumber(oldmetadata.battery or "0")}))
					-- calculate wear manually for support power_generators without technic
					local wear = 65534*(oldmetadata.battery or 0)/hwdef.battery_capacity
					if wear<1 then
						wear = 1
					end
					if wear>65534 then
						wear = 65534
					end
					stack:set_wear(65534-wear)
				end
			end
		end
	end
end

local function laptop_run(pos, node, mtos)
	local meta = minetest.get_meta(pos)
	local hwdef = mtos.hwdef
	local demand = hwdef.eu_demand or 0
	-- support both technic and power_generators, demand should be always same, supply should be active only one
	local supply = meta:get_int("LV_EU_input") + meta:get_int("generator_input")
	
	if have_generator and (supply>0) then
		meta:set_int("generator_input", 0)
	end
	
	-- powered off, nothing to do
	if (demand==0) then
		return
	end
	
	if (supply<demand) and (demand>0) then
		local power_off = true
	
		if hwdef.battery_capacity then
			local battery = meta:get_int("battery")
			if (battery>(demand-supply)) then
				meta:set_int("battery", battery - (demand - supply))
				power_off = false
			else
				meta:set_int("battery", 0)
			end
		end
		
		if power_off then
			local hwdef = laptop.node_config[node.name]
			if hwdef.power_off_node then
				local hwdef_next = laptop.node_config[hwdef.power_off_node]
				if hwdef_next.hw_state then
					mtos[hwdef_next.hw_state](mtos, hwdef.power_off_node)
				else
					mtos:power_off(hwdef.power_off_node)
					mtos:save()
				end
			end
		end
	elseif (demand>0) then
		local hwdef = laptop.node_config[node.name]
		if hwdef.battery_capacity then
			local battery = meta:get_int("battery")
			battery = battery+(hwdef.battery_charge or 400)
			battery = math.min(battery, hwdef.battery_capacity)
			meta:set_int("battery", battery)
		end
	end
	
end

local function technic_run(pos, node)
	local mtos = laptop.os_get(pos)
	if not mtos then
		return
	end
	
	laptop_run(pos, node, mtos)
end

local function technic_on_disable(pos, node)
	local mtos = laptop.os_get(pos)
	-- fix infotext for technic mod enable
	mtos:set_infotext(mtos.hwdef.infotext)
	
	laptop_run(pos, node, mtos)
end

local tubelib2_side = {
		right = "R",
		left = "L",
		front = "F",
		back = "B",
		top = "U",
		bottom = "D",
	}

function laptop.register_hardware(name, hwdef)
	local default_nodename = name.."_"..hwdef.sequence[1]
	for idx, variant in ipairs(hwdef.sequence) do
		local nodename = name.."_"..variant
		local def = table.copy(hwdef.node_defs[variant])
		def.description = hwdef.description

		-- drop the item visible in inventory
		if def.groups then
			def.groups = table.copy(def.groups)
		else
			def.groups = {choppy=2, oddly_breakably_by_hand=2,	dig_immediate = 2, laptop = 1}
		end
		if have_technic then
			def.groups.technic_machine = 1
			def.groups.technic_lv = 1
		end
		if have_generator then
			if def._eu_demand then
				def.groups.laptop_generator_powered = 1
			end
		end
		if def.connect_sides then
			def.connect_sides = table.copy(def.connect_sides)
		else
			def.connect_sides = {"back"}
		end
		def._generator_connect_sides = def.connect_sides
		def._generator_powered_valid_sides = {}
		for _,side in pairs(def.connect_sides) do
			def._generator_powered_valid_sides[tubelib2_side[side]] = true
		end
		if nodename ~= default_nodename then
			def.drop = default_nodename
			def.groups.not_in_creative_inventory = 1
		end
		if def.paramtype2 == "colorfacedir" and not def.palette then
			def.palette = "unifieddyes_palette_redviolets.png" --TODO: Replace by own laptop specific PNG file
		end

		-- needed to transfer content to item if place or dig laptop
		def.stack_max = 1
		def.after_place_node = after_place_node
		def.preserve_metadata = preserve_metadata
		def.on_punch = on_punch
		def.on_construct = on_construct
		def.on_receive_fields = on_receive_fields
		def.allow_metadata_inventory_move = allow_metadata_inventory_move
		def.allow_metadata_inventory_put = allow_metadata_inventory_put
		def.allow_metadata_inventory_take = allow_metadata_inventory_take
		def.on_metadata_inventory_move = on_metadata_inventory_move
		def.on_metadata_inventory_put = on_metadata_inventory_put
		def.on_metadata_inventory_take = on_metadata_inventory_take
		def.on_timer = on_timer
		def.technic_run = technic_run
		def.technic_on_disable = technic_on_disable
		if have_technic or have_generator then
			if hwdef.battery_capacity then
				def.groups.not_in_creative_inventory = 1
				def.drop = name.."_item"
			end
		end
		minetest.register_node(nodename, def)
		
		if have_technic then
			technic.register_machine("LV", nodename, technic.receiver)
		end
		if have_generator then
			local cable = power_generators.electric_cable
			local sides = {}
			for _,side in pairs(def._generator_connect_sides) do
				table.insert(sides, tubelib2_side[side])
			end
			cable:add_secondary_node_names({nodename})
			cable:set_valid_sides(nodename, sides)
		end
		
		-- set node configuration for hooks
		local merged_hwdef = table.copy(hwdef)
		merged_hwdef.name = name
		merged_hwdef.nodename = nodename
		for k,v in pairs(hwdef.node_defs[variant]) do
			merged_hwdef[k] = v
		end
		local next_seq = hwdef.sequence[idx+1] or hwdef.sequence[1]
		local next_node = name.."_"..next_seq
		if next_node ~= nodename then
			merged_hwdef.next_node = next_node
		end
		
		-- power off node
		if def._power_off_seq then
			local power_off_node = name.."_"..def._power_off_seq
			if power_off_node ~= nodename then
				merged_hwdef.power_off_node = power_off_node
			end
		end
		-- battery charge
		if def._battery_charge then
			merged_hwdef.battery_charge = def._battery_charge
		end
		-- eu demand
		if def._eu_demand then
			merged_hwdef.eu_demand = def._eu_demand
		end

		-- Defaults
		merged_hwdef.hw_capabilities =	merged_hwdef.hw_capabilities or {"hdd", "floppy", "usb", "net", "liveboot"}
		laptop.node_config[nodename] = merged_hwdef
	end
	
	if hwdef.battery_capacity then
		if have_technic or have_generator then
			local on_refill = nil
			if have_technic then
				technic.register_power_tool(name.."_item", hwdef.battery_capacity)
				on_refill = technic.refill_RE_charge
			end
			
			minetest.register_tool(name.."_item", {
					description = hwdef.description,
					inventory_image = hwdef.inventory_image,
					stack_max = 1,
					wear_represents = "technic_RE_charge",
					on_refill = on_refill,
					on_place = function(itemstack, placer, pointed_thing)
						itemstack:set_name(default_nodename)
						minetest.item_place_node(itemstack, placer, pointed_thing)
						itemstack:clear()
						return itemstack
					end,

				})
		else
			minetest.register_alias(name.."_item", default_nodename)
		end
	end
end

if have_generator and (not have_technic) then
	minetest.register_abm({
			label = "Update running laptops power.",
			nodenames = {"group:laptop_generator_powered"},
			interval = 1,
			chance = 1,
			action = function(pos, node)
				local def = minetest.registered_nodes[node.name]
				def.technic_run(pos, node)
			end,
		})
end

