laptop = {}
laptop.class_lib = {}
dofile(minetest.get_modpath('laptop')..'/themes.lua')
dofile(minetest.get_modpath('laptop')..'/app_fw.lua')
dofile(minetest.get_modpath('laptop')..'/os.lua')
dofile(minetest.get_modpath('laptop')..'/node_fw.lua')
dofile(minetest.get_modpath('laptop')..'/nodes.lua')
dofile(minetest.get_modpath('laptop')..'/items.lua')

-- uncomment this line to disable demo apps in production
--dofile(minetest.get_modpath('laptop')..'/demo_apps.lua')
