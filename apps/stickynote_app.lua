laptop.register_app("stickynote", {
	app_name = "Sticky note pad",
	app_icon = "laptop_notes_pad.png",
	app_info = "Write notes in simple text editor",
	formspec_func = function(app, os)
		local data = app:get_storage_ref()
		data.text = data.text or ""

		return "textarea[1,1;13,9;text;Sticky Note Pad;"..minetest.formspec_escape(data.text).."]"..
				'button[1,9;3,1;back;Back]'
	end,
	receive_fields_func = function(app, os, fields, sender)
		if fields.text then
			local data = app:get_storage_ref()
			data.text = fields.text
		end
		if fields.back then
			os:set_app("launcher")
		end
	end
})
