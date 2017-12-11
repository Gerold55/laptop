-- Load available Themes
local themes_tab = {}
for name, _ in pairs(laptop.themes) do
	if name ~= "default" then
		table.insert(themes_tab, name)
	end
end
table.sort(themes_tab)

laptop.register_app("launcher_settings", {
	app_name = "Settings",
	app_icon = "laptop_setting_wrench.png",
	app_info = "Change the computer's settings.",

	formspec_func = function(app, mtos)
		local settings_data = app:get_storage_ref()

		-- Change background setting
		local current_theme_name = settings_data.selected_theme or mtos:get_theme().name or "default"
		local current_theme = mtos:get_theme(current_theme_name)
		local current_idx

		local formspec = mtos.theme:get_label('0,0.5', "Select theme")

		local formspec = formspec.."textlist[0,1;5,2;sel_theme;"
		for i, theme in ipairs(themes_tab) do
			if i > 1 then
				formspec = formspec..','
			end
			if theme == current_theme_name then
				current_idx = i
			end
			formspec = formspec..theme
		end
		if current_idx then
			formspec = formspec..";"..current_idx
		end
		formspec = formspec.."]"

		if current_theme then
			formspec = formspec.."image[5.5,1;5,3.75;"..current_theme.launcher_bg.."]"
		end

		formspec = formspec .. mtos.theme:get_button('0,3.2;2.5,0.6', 'major', 'theme_apply', 'Apply', 'Apply theme')

		return formspec
	end,

	receive_fields_func = function(app, mtos, fields, sender)
		local settings_data = app:get_storage_ref()

		if fields.sel_theme then
			-- CHG:<idx> for selected or DCL:<idx> for double-clicked
			local selected_idx = tonumber(fields.sel_theme:sub(5))
			settings_data.selected_theme = themes_tab[selected_idx]
		end

		if fields.theme_apply and settings_data.selected_theme then
			mtos:set_theme(settings_data.selected_theme)
			settings_data.selected_theme = nil
		end
	end
})
