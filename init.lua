laptop = {
	activefilter = {},
	active_search_direction = {},
	alternate = {},
	current_page = {},
	current_searchbox = {},
	current_index = {},
	current_item = {},
	current_craft_direction = {},
	registered_craft_types = {},
	crafts_for = {usage = {}, recipe = {} },
	players = {},
	items_list_size = 0,
	items_list = {},
	filtered_items_list_size = {},
	filtered_items_list = {},
	pages = {},
	buttons = {},
    apps = {},

	pagecols = 8,
	pagerows = 10,
	page_y = 0,
	formspec_y = 1,
	main_button_x = 0,
	main_button_y = 9,
	craft_result_x = 0.3,
	craft_result_y = 0.5,
	form_header_y = 0
}

dofile(minetest.get_modpath('laptop')..'/nodes.lua')
dofile(minetest.get_modpath('laptop')..'/formspecs.lua')
dofile(minetest.get_modpath('laptop')..'/functions.lua')
