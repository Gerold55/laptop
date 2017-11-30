-- Load available backgrounds
local path = minetest.get_modpath('laptop')..'/textures/'
local background_tab = {}
for _, file in ipairs(minetest.get_dir_list(path, false)) do
	if file:sub(1,10) == 'laptop_os_' then
		table.insert(background_tab, file)
	end
end
table.sort(background_tab)


laptop.register_app("launcher_settings", {
	app_name = "Settings",
	app_icon = "laptop_setting_wrench.png",
	app_info = "Change laptop settings",

	formspec_func = function(app, os)
		local settings_data = app:get_storage_ref()
		local launcher_data = app:get_storage_ref("launcher")

		-- Change background setting
		local bgr_img = settings_data.bgr_img or launcher_data.background_img or laptop.apps.launcher.background_img
		local bgr_selected_idx

		local formspec = "label[0,0;Select background]"

		local formspec = formspec.."textlist[0,1;5,2;sel_bg;"
		for i, img in ipairs(background_tab) do
			if i > 1 then
				formspec = formspec..','
			end
			if img == bgr_img then
				bgr_selected_idx = i
			end
			formspec = formspec..img:sub(11,-5)
		end
		if bgr_selected_idx then
			formspec = formspec..";"..bgr_selected_idx
		end
		formspec = formspec.."]"

		if bgr_img then
			formspec = formspec.."image[5.5,1;5,3.75;"..bgr_img.."]"
		end

		formspec = formspec.."button[1,3;3,1;bgr_apply;Apply background]"

		-- Exit/Quit
		formspec = formspec.."button[1,7;3,1;back;Exit settings]"
		return formspec
	end,

	receive_fields_func = function(app, os, fields, sender)
		local settings_data = app:get_storage_ref()
		local launcher_data = app:get_storage_ref("launcher")

		if fields.sel_bg then
			-- CHG:<idx> for selected or DCL:<idx> for double-clicked
			local bgr_selected_idx = tonumber(fields.sel_bg:sub(5))
			settings_data.bgr_img = background_tab[bgr_selected_idx]
		end

		if fields.bgr_apply then
			launcher_data.background_img = settings_data.bgr_img
			settings_data.bgr_img = nil
			os:set_app("launcher")
		elseif fields.back then
			settings_data.bgr_img = nil
			os:set_app("launcher")
		end
	end
})
