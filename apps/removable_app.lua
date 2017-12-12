
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

		local idata = mtos:get_removable_data()
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
		local idata = mtos:get_removable_data()
		if idata then
			if fields.set_label then
				idata.label = fields.label
			end
			mtos:set_removable_data()
		end
	end,
})
