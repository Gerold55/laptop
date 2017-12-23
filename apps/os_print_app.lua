local printer_range = 10

local function sync_stack_values(mtos)
	mtos.sysdata.paper_count = mtos.sysdata.paper_count or 0
	mtos.sysdata.dye_count = mtos.sysdata.dye_count or 0
	local idata = mtos.bdev:get_removable_disk()
	-- store old stack values
	if mtos.sysdata.selected_view == 'paper' then
		if idata.stack then
			mtos.sysdata.paper_count = idata.stack:get_count()
		else
			mtos.sysdata.paper_count = 0
		end
	elseif mtos.sysdata.selected_view == 'dye' then
		if idata.stack then
			mtos.sysdata.dye_count = mtos.sysdata.dye_count - math.floor(mtos.sysdata.dye_count) + idata.stack:get_count()
		else
			mtos.sysdata.dye_count = mtos.sysdata.dye_count - math.floor(mtos.sysdata.dye_count)
		end
	elseif mtos.sysdata.selected_view == 'output' then
		if idata.stack then
			mtos.sysdata.out_stack_save = idata.stack:to_string()
		else
			mtos.sysdata.out_stack_save  = nil
		end
	end
end

laptop.register_app("printer_launcher", {
--	app_name = "Printer firmware",
	fullscreen = true,
	formspec_func = function(launcher_app, mtos)
		mtos.sysdata.print_queue = mtos.sysdata.print_queue or {}
		mtos.sysdata.selected_view = mtos.sysdata.selected_view or 'output'
		sync_stack_values(mtos)
		-- inventory fields
		local formspec = "size[10.5,7]"..
				"list[current_player;main;1,2.85;8,1;]" ..
				"list[current_player;main;1,4.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"
		local idata = mtos.bdev:get_removable_disk()

		-- queue
		formspec = formspec ..
				"tablecolumns[" ..
						"text;".. -- label
						"text;".. -- author
						"text]".. -- timestamp
				"table[0,0;6,2.42;printers;"
		for idx, file in ipairs(mtos.sysdata.print_queue) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec .. minetest.formspec_escape(file.title or "")..','..
					(file.author or "")..','..os.date("%c", file.timestamp)
		end
		formspec = formspec .. ";]"

		local out_button = 'minor'
		local paper_button = 'minor'
		local dye_button = 'minor'
		if mtos.sysdata.selected_view == 'paper' then
			paper_button = 'major'
			formspec = formspec .."background[6.2,0.3;4,0.7;"..mtos.theme.contrast_bg..']'
		elseif mtos.sysdata.selected_view == 'dye' then
			dye_button = 'major'
			formspec = formspec .."background[6.2,1;4,0.7;"..mtos.theme.contrast_bg..']'
		elseif mtos.sysdata.selected_view == 'output' then
			out_button = 'major'
			formspec = formspec .."background[6.2,1.7;4,0.7;"..mtos.theme.contrast_bg..']'
		end

		formspec = formspec .."background[8.2,0;2,2.5;"..mtos.theme.contrast_bg..
				']label[8.3,0.3;Paper: '..mtos.sysdata.paper_count..
				']label[8.3,0.8;Dye: '..mtos.sysdata.dye_count..']'..
				mtos.theme:get_button('6.3,0.3;1.7,0.7', paper_button, 'view_paper', 'Paper tray', 'Insert paper')..
				mtos.theme:get_button('6.3,1.0;1.7,0.7', dye_button, 'view_dye', 'Dye tray', 'Insert black dye')..
				mtos.theme:get_button('6.3,1.7;1.7,0.7', out_button, 'view_out', 'Output tray', 'Get printed paper')..
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;8.4,1.3;1,1;]"
		return formspec
	end,

	appwindow_formspec_func = function(launcher_app, app, mtos)
		local formspec = 'size[10,7]'
		return formspec
	end,

	allow_metadata_inventory_put = function(app, mtos, player, listname, index, stack)
		if mtos.sysdata.selected_view == 'output' then
			-- nothing
		elseif  mtos.sysdata.selected_view == 'paper' and stack:get_name() == 'default:paper' then
			return stack:get_stack_max()
		elseif mtos.sysdata.selected_view == 'dye' and stack:get_name() == 'dye:black' then
			return stack:get_stack_max()
		end
		return 0
	end,

	allow_metadata_inventory_take = function(app, mtos, player, listname, index, stack)
		-- removal allways possible
		return stack:get_count()
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		sync_stack_values(mtos)
		local idata = mtos.bdev:get_removable_disk()
		if fields.view_out then
			mtos.sysdata.selected_view = 'output'
			idata.stack = ItemStack(mtos.sysdata.out_stack_save or "")
		elseif fields.view_paper then
			mtos.sysdata.selected_view = 'paper'
			idata.stack = ItemStack('default:paper')
			idata.stack:set_count(mtos.sysdata.paper_count)
		elseif fields.view_dye then
			mtos.sysdata.selected_view = 'dye'
			idata.stack = ItemStack('dye:black')
			idata.stack:set_count(math.floor(mtos.sysdata.dye_count))
		end
		idata:reload(idata.stack)
	end,
})


local function get_printer_info(pos)
	local hw_os = laptop.os_get(pos)
	local printer
	if hw_os then
		printer = {
				pos = pos,
				name = hw_os.hwdef.description,
				nodename = hw_os.node.name,
			}
		if not minetest.registered_items[hw_os.node.name].groups.laptop_printer then
			printer.status =  'off'
			printer.status_color = '#FF0000'
		elseif not hw_os.sysram.current_app or hw_os.sysram.current_app == 'os:power_off' then
			printer.status =  'disabled'
			printer.status_color = '#FF0000'
		else
			printer.status = 'online'
			printer.status_color = '#00FF00'
		end
	end
	return printer
end

laptop.register_view("printer:app", {
	app_info = "Print file",
	formspec_func = function(app, mtos)
		local store = mtos.bdev:get_app_storage('ram', 'printer:app')
		local param = store.param
		local sysstore = mtos.bdev:get_app_storage('system', 'printer:app')
		sysstore.printers = sysstore.printers or {}

		local formspec = mtos.theme:get_label('0.5,1', "Selected Printer:")
		if sysstore.selected_printer then
			local printer = get_printer_info(sysstore.selected_printer.pos)
			if not printer then
				printer = sysstore.selected_printer
				printer.status = 'removed'
			else
				sysstore.selected_printer = printer
			end
			formspec = formspec .. 'item_image[0.5,1.5;1,1;'..printer.nodename..']'..
					mtos.theme:get_label('1.5,1.7', minetest.formspec_escape(printer.name)..' '..
					minetest.pos_to_string(printer.pos)..' '.. minetest.colorize(printer.status_color,printer.status))
		end

		formspec = formspec ..
				"tablecolumns[" ..
						"text;".. -- Printer name
						"text;".. -- Printer position
						"color;"..-- Status color
						"text]".. -- Printer status
				"table[0.5,2.5;6.5,4.2;printers;"
		if sysstore.printers[1] then
			local sel_idx = ""
			for idx, printer in ipairs(sysstore.printers) do
				if idx > 1 then
					formspec = formspec..','
				end
				local pos_string = minetest.pos_to_string(printer.pos)

				formspec = formspec..minetest.formspec_escape(printer.name)..','..
						minetest.formspec_escape(minetest.pos_to_string(printer.pos))..','..
						printer.status_color..','..printer.status
				if sysstore.selected_printer and vector.distance(printer.pos, sysstore.selected_printer.pos) == 0 then
					sel_idx = idx
				end
			end
			formspec = formspec .. ";"..sel_idx.."]"
		else
			formspec = formspec .. "No printer found :(]"
		end

		formspec = formspec .. mtos.theme:get_button('2.7,9;2,0.7', 'minor', 'scan', 'Search', 'Scan for printers')
		if sysstore.selected_printer and sysstore.selected_printer.status == 'online' then
			formspec = formspec .. mtos.theme:get_button('10,9;2,0.7', 'major', 'print', 'Print', 'Print file')
		end

		param.label = param.label or "<unnamed>"

		formspec = formspec .. "background[7.15,0.4;7.6,1;"..mtos.theme.contrast_bg.."]"..
				"label[7.3,0.6;Heading:]".."field[9.7,0.7;5,1;label;;"..minetest.formspec_escape(param.label or "").."]"..
				mtos.theme:get_label('9.7,1.7'," by "..(mtos.sysram.last_player or ""))..
				"background[7.15,2.55;7.6,6.0;"..mtos.theme.contrast_bg.."]"..
				"textarea[7.5,2.5;7.5,7;;"..(minetest.formspec_escape(param.text) or "")..";]"

		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		local store = mtos.bdev:get_app_storage('ram', 'printer:app')
		local param = store.param
		local sysstore = mtos.bdev:get_app_storage('system', 'printer:app')
		sysstore.printers = sysstore.printers or {}

		if fields.scan then
			sysstore.printers = {}
			local nodes = minetest.find_nodes_in_area({x = mtos.pos.x-printer_range, y= mtos.pos.y-printer_range, z = mtos.pos.z-printer_range},
					{x = mtos.pos.x+printer_range, y= mtos.pos.y+printer_range, z = mtos.pos.z+printer_range}, {"group:laptop_printer"})
			for _, pos in ipairs(nodes) do
				local printer = get_printer_info(pos)
				if printer then
					printer.printer_os = nil -- do not store whole OS
					table.insert(sysstore.printers, printer)
				end
			end
			table.sort(sysstore.printers, function(a,b) return vector.distance(a.pos, mtos.pos) < vector.distance(b.pos, mtos.pos) end)
		end

		if fields.printers then
			local event = minetest.explode_table_event(fields.printers)
			sysstore.selected_printer = sysstore.printers[event.row] or sysstore.selected_printer
		end

		if fields.label then
			param.label = fields.label
		end

		if fields.print then
			local hw_os = laptop.os_get(sysstore.selected_printer.pos)
			if hw_os and minetest.registered_items[hw_os.node.name].groups.laptop_printer then
				hw_os.sysdata.print_queue = hw_os.sysdata.print_queue or {}
				table.insert(hw_os.sysdata.print_queue, { title = param.label, text = param.text, author = sender:get_player_name(), timestamp = os.time() })
				hw_os:save()
				app:back_app()
			end
		end
	end,
})
