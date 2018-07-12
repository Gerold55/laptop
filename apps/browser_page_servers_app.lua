laptop.register_view("servers.minetest", {
	app_info = "Minetest Servers List",
	browser_page = true,
	browser_main_page = true,
	formspec_func = function(app, mtos)
		local formspec = laptop.browser_api.header_formspec_func(app, mtos) ..
			mtos.theme:get_label('.1,1.2', 'Persistent Kingdoms') ..
			mtos.theme:get_button('.1,1.7;4,.5', 'url_bright', 'page_link', 'persistentkingdoms.servers.minetest')
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	end
})