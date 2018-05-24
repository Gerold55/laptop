laptop.register_app("browser", {
	app_name = "MineBrowse",
	app_icon = "laptop_removable.png",
	app_info = "Web Browser",
	formspec_func = function(app, mtos)
			local formspec =
		   "field[.2,.5;13,1;name; ;] field_close_on_enter[input_field;false]"..
			mtos.theme:get_image_button('12.9,.3;.8,.8', 'minor', 'go_button', 'laptop_theme_basic_button.png', '', 'Go') ..
			mtos.theme:get_image_button('13.6,.3;.8,.8', 'minor', 'home_button', 'laptop_theme_basic_button.png', '', 'Home') ..
			mtos.theme:get_image_button('14.3,.3;.8,.8', 'minor', 'settings_button', 'laptop_theme_basic_button.png', '', 'Settings') ..
			"image[.1,1.3;18,1.6;laptop_welcome_web.png]"..
			"label[.1,2.7;MineBrowse is a working web browser powered by formspecs. It is community driven, ]"..
			"label[.1,3;which means websites are created by the community. If you like to add your own site]"..
			"label[.1,3.3;visit submit.official for further details.]"..
			"background[0,1.2;15,9;laptop_background_web.png]"..
			']'
			return formspec
		end,
})