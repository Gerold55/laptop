local store_area = 'painting:files'

local have_painting = minetest.get_modpath("painting")

local hexcolors = {
		black = "000000",
		maroon = "800000",
		green = "008000",
		olive = "808000",
		navy = "000080",
		purple = "800080",
		teal = "008080",
		silver = "C0C0C0",
		
		gray = "808080",
		red = "FF0000",
		lime = "00FF00",
		yellow = "FFFF00",
		blue = "0000FF",
		fuchsia = "FF00FF",
		aqua = "00FFFF",
		white = "FFFFFF",
	}
local colors = {
		"black", "maroon", "green", "olive", "navy", "purple", "teal", "silver",
		"gray", "red", "lime", "yellow", "blue", "fuchsia", "aqua", "white",
	}

local butcolors = {}
for color, hex in pairs(hexcolors) do
	butcolors["color_"..color] = hex
end

laptop.register_app("painting", {
	app_name = "Painting",
	app_icon = "laptop_painting.png",
	app_info = "Show/Edit Pictures",
	formspec_func = function(app, mtos)
		local data = mtos.bdev:get_app_storage('system', 'painting')
		data.files = data.files or {}
		if not data.brush_color then
			data.brush_color = "000000" 
		end
		if not data.resolution then
			data.resolution = 16 
		end
		if not data.grid then
			data.grid = {}
			for y = 1,data.resolution do
				data.grid[y] = {}
				for x = 1,data.resolution do
					data.grid[y][x] = "FFFFFFFF"
				end
			end
		end

		if data.selected_disk_name and data.selected_file_name then
			app.app_info = app.app_info..' - Open File: '..data.selected_disk_name..' / '..data.selected_file_name
		end

		-- cache sorted files list
		if not data.fileslist_sorted then
			data.fileslist_sorted = {}
			for filename,_ in pairs(data.files) do
				table.insert(data.fileslist_sorted, filename)
			end
			table.sort(data.fileslist_sorted)
		end

		local formspec = "background[0,3.35;7.2,6.35;"..mtos.theme.contrast_background.."]"..
				mtos.theme:get_button('0,0.5;1.5,0.8', 'minor', 'new_16', 'New 16', 'New picture with resolution 16x16')..
				mtos.theme:get_button('2,0.5;1.5,0.8', 'minor', 'new_32', 'New 32', 'New picture with resolution 32x32')..
				mtos.theme:get_button('4,0.5;1.5,0.8', 'minor', 'load', 'Load', 'Load picture')..
				mtos.theme:get_button('6,0.5;1.5,0.8', 'minor', 'save', 'Save', 'Save picture')
		--if have_painting then
		if false then
			formspec = formspec .. mtos.theme:get_button('12,0.5;1.5,0.8', 'minor', 'print', 'Print', 'Print file')
		end
		formspec = formspec .. "field[0.3,1.8;1.5,0.8;hex_color;;000000]"
		formspec = formspec .. mtos.theme:get_button('1.5,1.5;1.5,0.8', 'minor', 'set_hex', 'Set', 'Set hex color')
		formspec = formspec .. mtos.theme:get_image_button('0,2.5;0.8,0.8', 'minor', 'brush_color', 'w.png^[colorize:#'..data.brush_color, '', 'Brush color')
		for index,color in pairs(colors) do
			local xoff = 3.5 + 0.8 * ((index-1)%8)
			local yoff = 1.5
			if index>8 then
				yoff = 2.5
			end
			formspec = formspec .. mtos.theme:get_image_button(xoff..','..yoff..';0.8,0.8', 'minor', 'color_'..color, 'w.png^[colorize:#'..hexcolors[color], '', 'Color '..color)
		end
		local resolution = data.resolution
		local xsize = 0.1979+6.3333/resolution
		local ysize = 0.1771+5.6667/resolution
		local xyoff = 6/resolution
		for y = 1,resolution do
			for x = 1,resolution do
				local xoff = 0.012369*resolution + x*xyoff
				local yoff = 2.9+0.011069*resolution + y*xyoff
				local hex = data.grid[y] or {}
				hex = hex[x] or "FFFFFF"
				formspec = formspec .. mtos.theme:get_image_button(xoff..','..yoff..';'..xsize..','..ysize, 'minor', 'pixel_'..y..'_'..x, 'w.png^[colorize:#'..hex, '', 'Pixel '..x..'x'..y)
			end
		end
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('system', 'painting')
		if fields.text then
			data.text = fields.text
		end

		if fields.load then
			mtos:select_file_dialog({
					mode = 'open',
					allowed_disks = {'hdd', 'removable'},
					selected_disk_name = data.selected_disk_name,
					selected_file_name = data.selected_file_name,
					store_name = store_area,
					prefix = 'open_',
			})
		elseif fields.open_selected_disk and fields.open_selected_file then
			data.selected_disk_name = fields.open_selected_disk
			data.selected_file_name = fields.open_selected_file
			local store = mtos.bdev:get_app_storage(data.selected_disk_name, store_area)
			if store then
				data.grid = store[data.selected_file_name].content
	  	  	  	  data.resolution = #data.grid
			end
		elseif fields.save then
			mtos:select_file_dialog({
					mode = 'save',
					allowed_disks = {'hdd', 'removable'},
					selected_disk_name = data.selected_disk_name,
					selected_file_name = data.selected_file_name,
					store_name = store_area,
					prefix = 'save_',
			})
		elseif fields.save_selected_disk and fields.save_selected_file then
			data.selected_disk_name = fields.save_selected_disk
			data.selected_file_name = fields.save_selected_file
			local store = mtos.bdev:get_app_storage(data.selected_disk_name, store_area)
			if store then
				store[data.selected_file_name] = { content = data.grid, ctime = os.time(), owner = sender:get_player_name() }
			end
		elseif fields.new_16 then
			data.selected_disk_name = nil
			data.selected_file_name = nil
			data.resolution = 16 
			data.grid = nil
		elseif fields.new_32 then
			data.selected_disk_name = nil
			data.selected_file_name = nil
			data.resolution = 32 
			data.grid = nil
		elseif fields.print then
			mtos:print_picture_dialog({
				label = data.selected_file_name,
				text = data.text,
			})
		elseif fields.set_hex then
			local color = {
				r = tonumber("00"..fields.hex_color:sub(1,2),16),
				g = tonumber("00"..fields.hex_color:sub(3,4),16),
				b = tonumber("00"..fields.hex_color:sub(5,6),16),
				a = fields.hex_color:sub(7,8),
			}
	  	  	  if color.a=="" then
	  	  	  	  color.a = 255
	  	  	  else
				color.a = tonumber(color.a, 16)
	  	  	  end
	  	  	  if color.a==255 then
	  	  	  	  data.brush_color = string.format("%02x%02x%02x", color.r, color.g, color.b)
	  	  	  else
	  	  	  	  data.brush_color = string.format("%02x%02x%02x%02x", color.r, color.g, color.b, color.a)
	  	  	  end
		else
			-- check for pixel click
			for y = 1,data.resolution do
				for x = 1,data.resolution do
					local key = "pixel_"..y.."_"..x
					if fields[key] then
						local line = data.grid[y] or {}
						  line[x] = data.brush_color..""
						return
					end
				end
			end
			-- check for color select click
			for index,color in pairs(colors) do
				local key = "color_"..color
				if fields[key] then
					data.brush_color = hexcolors[color]
					return
				end
			end
		end
	end
})
