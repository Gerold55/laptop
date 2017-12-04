laptop.themes = {
	blue = {
		launcher_bg = "laptop_theme_blue_launcher_bg.png",
		app_bg = "laptop_theme_blue_app_bg.png",
		major_button = "laptop_theme_blue_major_button.png",
		minor_button = "laptop_theme_minor_button.png",
		back_button = "laptop_theme_blue_back_button.png",
		exit_button = "laptop_theme_blue_exit_button.png",
	},
	red = {
		launcher_bg = "laptop_theme_red_launcher_bg.png",
		app_bg = "laptop_theme_red_app_bg.png",
		major_button = "laptop_theme_red_major_button.png",
		minor_button = "laptop_theme_minor_button.png",
		back_button = "laptop_theme_red_back_button.png",
		exit_button = "laptop_theme_red_exit_button.png",
	},
	freedom = {
		launcher_bg = "laptop_theme_freedom_launcher_bg.png",
	},
	cubic = {
		launcher_bg = "laptop_theme_cubic_launcher_bg.png",
	},
}

laptop.themes.default = laptop.themes.blue -- default can be an complete theme only


function laptop.register_theme(name, def)
	laptop.themes[name] = def
end
