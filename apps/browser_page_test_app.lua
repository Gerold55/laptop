laptop.register_view("test.official", {
	app_info = "In-Game Test",
	browser_page = true,
	formspec_func = function(app, mtos)
		local formspec = laptop.browser_api.header_formspec_func(app, mtos) ..
			mtos.theme:get_label('.3,1.1','Hello submitted World!')..
			mtos.theme:get_button('.1,1.7;2,.5', 'url_bright', 'page_link', 'link')..
			mtos.theme:get_image_button('.3,2.2;2,.8', 'toolbar', 'go_button', 'laptop_theme_basic_button.png', '', 'Go') ..
			"background[0,1.2;15,9;#000000]"
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	end
})