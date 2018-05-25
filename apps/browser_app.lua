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
			--"image[.1,1.3;18,1.6;laptop_header_web.png]"..
			"image[0,1.3;18,1.6;laptop_welcome_web.png]"..
			"label[.1,2.7;MineBrowse is a working web browser powered by formspecs. It is community driven, ]"..
			"label[.1,3;which means websites are created by the community. If you like to add your own site]"..
			"label[.1,3.3;visit submit.official for further details.]"..
			"background[0,1.2;15,9;laptop_background.png]"..
			mtos.theme:get_image_button('11.3,9.3;3,.8', 'minor', 'submit_button', 'laptop_theme_basic_button.png', 'Submit a Website', 'Submit a Website') ..
			"image[11,2.8;4,8.1;laptop_ad1_web.png]"..
			"image[.1,3.8;12,1.2;laptop_wa_web.png]"..
			"label[.3,4.7;welcome.official]"..
			"label[.3,5.1;submit.official]"..
			"label[.3,5.5;bible.official]"..
			']'
			return formspec
		end,
})
