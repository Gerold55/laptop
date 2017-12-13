laptop.themes = {
	Freedom = {
		launcher_bg = "laptop_theme_freedom_launcher_bg.png",
		app_bg = "laptop_theme_freedom_app_bg.png",
		major_button = "laptop_theme_freedom_major_button.png",
		minor_button = "laptop_theme_minor_button.png",
		back_button = "laptop_theme_freedom_back_button.png",
		exit_button = "laptop_theme_freedom_exit_button.png",
		app_button = "laptop_theme_freedom_app_button.png",
		textcolor = "#000000",
		contrast_bg = "gui_formbg.png",
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

local theme_class = {}
theme_class.__index = theme_class

-- get prepared button textures
function theme_class:get_button(area, prefix, code, text, tooltip)
	return'image_button['..area..';'..self[prefix.."_button"]..';'..code..';'.. minetest.colorize(self[prefix.."_textcolor"] or self.textcolor,minetest.formspec_escape(text))..']'..
			"tooltip["..code..";"..minetest.formspec_escape(tooltip or text).."]"
end
-- Get themed label
function theme_class:get_label(area, label)
	return'label['..area..';'..minetest.colorize(self.textcolor, minetest.formspec_escape(label))..']'
end

function laptop.get_theme(theme_name)
	local self = setmetatable(table.copy(laptop.themes.default), theme_class)
	if theme_name and laptop.themes[theme_name] then
		for k,v in pairs(laptop.themes[theme_name]) do
			self[k] = v
		end
		self.name = theme_name
	else
		self.name = "default"
	end
	return self
end
