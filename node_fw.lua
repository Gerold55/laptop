
laptop.node_config = {}

local function after_place_node(pos, placer, itemstack, pointed_thing)
	local appdata = minetest.deserialize(itemstack:get_meta():get_string("laptop_appdata"))
	if appdata then
		local mtos = laptop.os_get(pos)
		mtos.appdata = appdata
		mtos.appdata.launcher = mtos.appdata.launcher or {}
		mtos.appdata.os = mtos.appdata.os or {}
		mtos.appdata.os.stack = mtos.appdata.os.stack or {}
		mtos:save()
	end
end

local function after_dig_node(pos, oldnode, oldmetadata, digger)
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

local function on_construct(pos)
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
	mtos:set_infotext(hwdef.hw_infotext)
end

local function on_punch(pos, node, puncher)
	local mtos = laptop.os_get(pos)
	local hwdef = laptop.node_config[node.name]
	if hwdef.next_node then
		local hwdef_next = laptop.node_config[hwdef.next_node]
		if hwdef_next.hw_state then
			mtos[hwdef_next.hw_state](mtos, hwdef.next_node)
		else
			mtos:swap_node(hwdef.next_node)
			mtos:save()
		end
		mtos:set_infotext(hwdef_next.hw_infotext)
	end
end

local function on_receive_fields(pos, formname, fields, sender)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("receive_fields_func", true, sender, fields)
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_move", false, player, from_list, from_index, to_list, to_index, count)
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_put", false, player, listname, index, stack)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_take", false, player, listname, index, stack)
end

local function on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("on_metadata_inventory_move", true, player, from_list, from_index, to_list, to_index, count)
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("on_metadata_inventory_put", true, player, listname, index, stack)
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("on_metadata_inventory_take", true, player, listname, index, stack)
end

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
			def.groups = {choppy=2, oddly_breakably_by_hand=2,  dig_immediate = 2}
		end
		if nodename ~= default_nodename then
			def.drop = default_nodename
			def.groups.not_in_creative_inventory = 1
		end

		-- needed to transfer content to item if place or dig laptop
		def.stack_max = 1
		def.after_place_node = after_place_node
		def.after_dig_node = after_dig_node
		def.on_punch = on_punch
		def.on_construct = on_construct
		def.on_receive_fields = on_receive_fields
		def.allow_metadata_inventory_move = allow_metadata_inventory_move
		def.allow_metadata_inventory_put = allow_metadata_inventory_put
		def.allow_metadata_inventory_take = allow_metadata_inventory_take
		def.on_metadata_inventory_move = on_metadata_inventory_move
		def.on_metadata_inventory_put = on_metadata_inventory_put
		def.on_metadata_inventory_take = on_metadata_inventory_take
		minetest.register_node(nodename, def)

		-- set node configuration for hooks
		laptop.node_config[nodename] = table.copy(hwdef)
		for k,v in pairs(hwdef.node_defs[variant]) do
			laptop.node_config[nodename][k] = v
		end
		local next_seq = hwdef.sequence[idx+1] or hwdef.sequence[1]
		local next_node = name.."_"..next_seq
		if next_node ~= nodename then
			laptop.node_config[nodename].next_node = next_node
		end
	end
end

