laptop.themes = {
	Freedom = {
		launcher_bg = "laptop_theme_freedom_launcher_bg.png",
		app_bg = "laptop_theme_freedom_app_bg.png",
		major_button = "laptop_theme_freedom_major_button.png",
		minor_button = "laptop_theme_minor_button.png",
		back_button = "laptop_theme_freedom_back_button.png",
		exit_button = "laptop_theme_freedom_exit_button.png",
		app_button = "laptop_theme_freedom_app_button.png",
	},
}

laptop.themes.default = laptop.themes.Freedom -- default can be an complete theme only


function laptop.register_theme(name, def)
	laptop.themes[name] = def
end

-- load all themes
local theme_path = minetest.get_modpath('laptop')..'/themes/'
local theme_list = minetest.get_dir_list(theme_path, false)

for _, file in ipairs(theme_list) do
	if file:sub(-10) == '_theme.lua' then
		dofile(theme_path..file)
	end
end