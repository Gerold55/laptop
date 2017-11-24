laptop = {}

dofile(minetest.get_modpath('laptop')..'/app_fw.lua')
dofile(minetest.get_modpath('laptop')..'/os.lua')
dofile(minetest.get_modpath('laptop')..'/nodes.lua')

-- uncomment this line to disable demo apps in production
dofile(minetest.get_modpath('laptop')..'/demo_apps.lua')
