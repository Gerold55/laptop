laptop.register_app("stickynote", {
	app_name = "Notepad",
	app_icon = "laptop_notes_pad.png",
	app_info = "Write notes in a text document.",
	formspec_func = function(app, mtos)
		local data = app:get_storage_ref()
		data.files = data.files or {}

		if data.selected_file then
			data.text = data.files[data.selected_file]
		end
		data.text = data.text or ""

		-- cache sorted files list
		if not data.fileslist_sorted then
			data.fileslist_sorted = {}
			for filename,_ in pairs(data.files) do
				table.insert(data.fileslist_sorted, filename)
			end
			table.sort(data.fileslist_sorted)
		end

		local formspec = "background[0,0.35;15.2,8.2;gui_formbg.png]"..
				"textarea[0.35,0.35;15.08,9.5;text;;"..minetest.formspec_escape(data.text).."]"..
				"dropdown[0,9;4,1;file_sel;"

		local selected_idx
		for idx, filename in ipairs(data.fileslist_sorted) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec .. filename
			if data.selected_file and data.selected_file == filename then
				selected_idx = idx
			end
		end
		formspec = formspec .. ";"..(selected_idx or "").."]"..
				mtos.theme:get_button('4,9;1.5,0.8', 'minor', 'load', 'Load', 'Load file')..
				mtos.theme:get_button('5.7,9;1.5,0.8', 'minor', 'delete', 'Delete', 'Delete file')..
				"field[7.6,9.3;4,0.8;filename;;"..(data.selected_file or "").."]"..
				mtos.theme:get_button('11.6,9;1.5,0.8', 'minor', 'save', 'Save', 'Save file')
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		if fields.text then
			local data = app:get_storage_ref()
			data.text = fields.text
		end
	end
})
