local function get_item_data(mtos)
	local stack = mtos:get_node_inventory():get_stack("main", 1)
	if stack then
		local def = stack:get_definition()
		if def and def.name ~= "" then
			local data = {
				def = def,
				stack = stack,
				meta = stack:get_meta()
			}

			data.label = data.meta:get_string("description")
			if not data.label or data.label == "" then
				data.label = def.description
			end
			return data
		end
	end
end


local function set_item_data(mtos, data)
	if data.label ~= data.def.description then
		data.meta:set_string("description", data.label)
	end
	mtos:get_node_inventory():set_stack("main", 1, data.stack)
end


laptop.register_app("removable", {
	app_name = "Removable storage",
	app_icon = "laptop_setting_wrench.png",
	app_info = "Work with removable media",
	formspec_func = function(app, mtos)
		local formspec = 
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;0,0.3;1,1;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"

		local idata = get_item_data(mtos)
		if idata then
			formspec = formspec .. mtos.theme:get_label('0,1.2', idata.def.description)..
			"field[2,0.7;4,1;label;Label:;"..idata.label.."]"..
			mtos.theme:get_button('5.7,0.55;1.5,0.7', 'minor', 'set_label', 'Rename', 'Rename the '..idata.def.description)
		end
		return formspec
	end,
	-- check if the item is compatible to the computer
	allow_metadata_inventory_put = function(app, mtos, sender, listname, index, stack)
		local def = stack:get_definition()
		if not def or not def.groups.laptop_removable then return end -- not supported
		local removable = mtos.hwdef.allowed_removable_groups or { "laptop_removable" }
		for _, v in ipairs(removable) do
			if def.groups[v] then
				return 1
			end
		end
	end,

	-- item removal always allowed from inventory
	allow_metadata_inventory_take = function(app, mtos, sender, listname, index, stack)
		return 1
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		local idata = get_item_data(mtos)
		if idata then
			if fields.set_label then
				idata.label = fields.label
			end
			set_item_data(mtos, idata)
		end
	end,
})
