
laptop.register_app("demo1", {
	app_name = "Demo App",
	app_icon = "laptop_setting_wrench.png",
	app_info = "The first and simple demo app",
	formspec_func = function(app, mtos)
		return mtos.theme:get_button('5,5;3,1', 'major', 'next', 'Second screen')
	end,
	receive_fields_func = function(app, mtos, fields, sender)
		if fields.next then
			mtos:set_app("demo1_view2")
		end
	end
})

laptop.register_view("demo1_view2", {
	app_info = "Second screen in Demo App 1",
	formspec_func = function(app, mtos)
		return mtos.theme:get_label('1,5', "Use the framework buttons to navigate back or cancel")
	end,
	receive_fields_func = function(app, mtos, fields, sender)
	end
})


laptop.register_app("demo2", {
	app_name = "Demo App 2",
	formspec_func = function(app, mtos)
		local data = app:get_storage_ref()
		data.counter = data.counter or 1

		return 'button[3,1;5,1;count;Click: '..data.counter..']'..
				'button[3,3;5,1;back;Back to launcher]'
	end,
	receive_fields_func = function(app, mtos, fields, sender)
		if fields.count then
			local data = app:get_storage_ref()
			data.counter = data.counter + 1
		elseif fields.back then
			app:exit_app()
		end
	end
})
