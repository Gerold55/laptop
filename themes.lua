laptop.themes = {
	default = { --Fallback theme
		desktop_background = "blank.png",
		app_background = "blank.png",
		app_bgcolor = '#999999',
		background = "laptop_theme_desktop_icon_label_button_white.png",
		alt_background = "laptop_theme_colors_light_grey.png",
		major_button = "laptop_theme_blue_major_button.png",
		major_textcolor = "#000000",
		major_bgcolor = "#A0A0A0",
		minor_button = "laptop_theme_minor_button.png",
		minor_textcolor = "#000000",
		minor_bgcolor = "#B0B0B0",
		back_button = "laptop_theme_blue_back_button.png",
		back_textcolor = "#FFFF00",
		exit_button = "laptop_theme_blue_exit_button.png",
		exit_textcolor = "#FF0000",
		exit_character = "X",
		desktop_icon_button = "blank.png",
		desktop_icon_label_button = "laptop_theme_desktop_icon_label_button_black.png",
		desktop_icon_label_textcolor = '#FFFFFF',
		titlebar_textcolor = "#FFFFFF",
		textcolor = "#000000",
		bgcolor = "#E0E0E0",
		muted_textcolor = "#666666",
		contrast_background = "gui_formbg.png",
		contrast_bgcolor = "#000000",
		contrast_textcolor = "#FFFFFF",
		taskbar_clock_position_and_size = "11,9.8;4,0.7",
		node_color = 0,
		table_bgcolor = "#ffffff",
		table_textcolor = "#000000",
		table_highlight_bgcolor = '#cde6f7',
		table_highlight_textcolor = '#000000',
		table_border = 'yes',
		texture_replacements = {}, -- No replacements in default theme
		status_online_textcolor = "#00FF00",
		status_disabled_textcolor = "#FF0000",
		status_off_textcolor = "#888888",
		monochrome_textcolor = nil, -- If set, some colorizing is applied using this color
	},
}

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
	local formspec = 'image_button['..area..';'..self[prefix.."_button"]..';'..code..';'.. minetest.colorize(self[prefix.."_textcolor"] or self.textcolor,minetest.formspec_escape(text))..']'
	if tooltip then
		formspec = formspec.."tooltip["..code..";"..minetest.formspec_escape(tooltip).."]"
	end
	return formspec
end

-- get prepared button textures
function theme_class:get_image_button(area, prefix, code, image, text, tooltip)
	local formspec = 'image_button['..area..';'..self[prefix.."_button"]..'^'..self:get_texture(image)..';'..code..';'.. minetest.colorize(self[prefix.."_textcolor"] or self.textcolor,minetest.formspec_escape(text))..']'
	if tooltip then
		formspec = formspec.."tooltip["..code..";"..minetest.formspec_escape(tooltip).."]"
	end
	return formspec
end


-- Get themed label
function theme_class:get_label(area, label, color_prefix)
	if color_prefix then
		return 'label['..area..';'..minetest.colorize(self[color_prefix.."_textcolor"] or self.textcolor, minetest.formspec_escape(label))..']'
	else
		return 'label['..area..';'..minetest.colorize(self.textcolor, minetest.formspec_escape(label))..']'
	end
end

-- Get themed texture name
function theme_class:get_texture(texture_name)
	return self.texture_replacements[texture_name] or texture_name
end

function theme_class:get_bgcolor_box(area, color_prefix)
	return 'box['..area..';'..(self[color_prefix.."_bgcolor"] or self.bgcolor)..']'
end

function theme_class:get_tableoptions(show_select_bar)
	if show_select_bar == false then
		return "tableoptions[background="..self.table_bgcolor..
				";color="..self.table_textcolor..
				";highlight="..self.table_bgcolor..
				";highlight_text="..self.table_textcolor..
				";border="..self.table_border.."]"
	else
		return "tableoptions[background="..self.table_bgcolor..
				";color="..self.table_textcolor..
				";highlight="..self.table_highlight_bgcolor..
				";highlight_text="..self.table_highlight_textcolor..
				";border="..self.table_border.."]"
	end
end


function laptop.get_theme(theme_name)
	local self = setmetatable(table.copy(laptop.themes.default), theme_class)
	theme_name = theme_name or "Freedom"
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
