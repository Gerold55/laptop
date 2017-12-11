laptop.register_app("stickynote", {
	app_name = "Notepad",
	app_icon = "laptop_notes_pad.png",
	app_info = "Write notes in a text document.",
	formspec_func = function(app, os)
		local data = app:get_storage_ref()
		data.text = data.text or ""

		return "background[0,0.35;15.2,9.2;gui_formbg.png]"..
				"textarea[0.35,0.35;15.08,10.5;text;;"..minetest.formspec_escape(data.text).."]"
	end,
	receive_fields_func = function(app, os, fields, sender)
		if fields.text then
			local data = app:get_storage_ref()
			data.text = fields.text
		end
	end
})
