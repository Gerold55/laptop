
laptop.register_app("demo1", {
	app_name = "Demo App",
	app_icon = "laptop_setting_wrench.png",
	app_info = "The first and simple demo app",
	formspec_func = function(app, os)
		return 'button[5,5;3,1;back;Back to launcher]'
	end,
	receive_fields_func = function(app, os, fields, sender)
		if fields.back then
			os:set_app("launcher")
		end
	end
})

laptop.register_app("demo2", {
	app_name = "Demo App 2",
	formspec_func = function(app, os)
		local data = app:get_storage_ref()
		data.counter = data.counter or 1

		if data.counter % 2 == 0 then
			app.background_img = "laptop_background1.png"
		end
		return 'button[3,1;5,1;count;Click: '..data.counter..']'..
				'button[3,3;5,1;back;Back to launcher]'
	end,
	receive_fields_func = function(app, os, fields, sender)
		if fields.count then
			local data = app:get_storage_ref()
			data.counter = data.counter + 1
		elseif fields.back then
			os:set_app("launcher")
		end
	end
})
