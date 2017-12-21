local printer_range = 10

laptop.register_app("printer_launcher", {
--	app_name = "Printer firmware",
	fullscreen = true,
	formspec_func = function(launcher_app, mtos)
		local queue = mtos.bdev:get_app_storage('system', 'printer:queue')

		local formspec = "size[10,7]"..
				"label[8,0.5;print output]" ..
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;8,1.3;1,1;]" ..
				"list[current_player;main;1,2.85;8,1;]" ..
				"list[current_player;main;1,4.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"
		local idata = mtos.bdev:get_removable_disk()

		return formspec
	end,

	appwindow_formspec_func = function(launcher_app, app, mtos)
		local formspec = 'size[10,7]'
		return formspec
	end,

	receive_fields_func = function(launcher_app, mtos, sender, fields)
		local queue = mtos.bdev:get_app_storage('system', 'printer:queue')

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

--------------------------------------------------------
laptop.register_view("printer:app", {
	app_info = "Print file",
	formspec_func = function(launcher_app, mtos)
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

		formspec = formspec .. mtos.theme:get_label('7.5,1', "Document preview: "..(param.label or "<unnamed>"))..
					"background[7.5,1.55;6.92,7.3;"..mtos.theme.contrast_bg.."]"..
					"textarea[7.75,1.5;7,8.35;body;;"..(minetest.formspec_escape(param.text) or "").."]"

		return formspec
	end,
	receive_fields_func = function(launcher_app, mtos, sender, fields)
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
	end,
})
