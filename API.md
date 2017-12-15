# Laptop Mod API

## Add new hardware nodes
`laptop.register_hardware(name, hwdef)`
- `name` - Item name (prefix) The created node names are name_variant
- `hwdef.description`  -  Computer item name
- `hwdef.hw_infotext` - Text shown if node is pointed
- `hwdef.sequence = { "variant_1_name", "variant_2_name", "variant_3_name" }` On punch swaps sequence. the first variant is in creative inventory
- `hwdef.custom_launcer` - optional - custom launcher name
- `hwdef.custom_theme` -  optional - custom initial theme name
- `hwdef.hw_capabilities` = { "hdd", "floppy", "usb", "net", "liveboot" } Table with hardware capabilities. Default is all, if nothing set
- `hwdef.node_defs = {
		variant_1_name = {
			hw_state =  "resume", "power_on" or "power_off", -- Hardware state
			--node 1 definiton
		},
		variant_2_name = {
			hw_state =  "resume", "power_on" or "power_off", -- Hardware state
			--node 2 definiton
		},
	}` - A list for node definitions for each variant. with hw_state parameter for OS-initialization


- `laptop.os_get(pos)` - Get an OS object. Usefull in on_construct or on_punch to initialize or do anything with OS
  Needed in on_receive_fields to be able to call mtos:receive_fields(fields, sender) for interactive apps
- `laptop.after_place_node` / `laptop.after_dig_node` - (optional) can be used directly for node definition. Move laptop apps data to ItemStack if digged and restored back if placed again. So you can take along your laptop. Note: you need to set `stack_max = 1` because the data can be stored per stack only, not per item.


## Operating system object
`local mtos = laptop.os_get(pos)` - Get the Operating system object. Used internally, but usable for remote operations. mtos is passed to app methods as parameter

### Operating system methods
- `mtos:power_on(new_node_name)` - Free RAM, activate the launcher and if given swap node to new_node_name
- `mtos:resume(new_node_name)` - Restore the last running app after power_off. Means no free ram and no switch to launcher. Update formspec and if given swap node to new_node_name
- `mtos:power_off(new_node_name)` - Remove the formspec and if given swap node to new_node_name
- `mtos:swap_node(new_node_name)`- Swap the node only without any changes on OS
- `mtos:set_infotext(infotext)` - Set the mouseover infotext for laptop node
- `mtos:get_app(appname)`- Get the app instance
- `mtos:set_app(appname)` - Start/Enable/navigate to appname. If no appname given the launcher is called
- `mtos:get_theme(theme)`- Get theme data current or requested (theme parameter is optional)
- `mtos:set_theme(theme)`- Activate theme
- `mtos:save()` - Store all app-data to nodemeta. Called mostly internally so no explicit call necessary
- `mtos:pass_to_app(method, reshow, sender, ...)` - call custom "method" on app object. Used internally. Reshow means update formspec after update

### Operating system attributes
	`mtos.pos` - Computers position vector
	`mtos.node` = minetest.get_node(pos)
	`mtos.hwdef` = Merged hardware definition (Hardware + Hardware node attributes merged to 1 object)
	`mtos.meta` = Nade meta - mostly managed by block device framework
	`mtos.bdev` = Block device framework object
	`mtos.sysram` = System/OS ram partition, mtos.bdev:get_app_storage('ram', 'os')
	`mtos.sysdata` = System/OS data partition, mtos.bdev:get_app_storage('system', 'os')
	`mtos.theme` = Selected theme object

## Apps
### Definition attributes
`laptop.register_app(internal_shortname, { definitiontable })` - add a new app or view
- `app_name` - App name shown in launcher. If not defined the app is just a view, not visible in launcher but can be activated. This way multi-screen apps are possible
- `app_icon` - Icon to be shown in launcher. If nothing given the default icon is used
- `app_info` - Short app info visible in launcher tooltip
- `fullscreen` - (boolean) Do not add app-background and window buttons
- `view` - (boolean) The definition is a view. That means the app/view is not visible in launcher
- `formspec_func(app, mtos)` - Function, should return the app formspec (mandatory) During definition the "app" and the "mtos" are available
- `appwindow_formspec_func(launcher_app, app, mtos)`- Only custom launcher app: App background / Window decorations and buttons
- `receive_fields_func(app, mtos, sender, fields)` Function for input processing. The "app" and the "mtos" are available inside the call
- `allow_metadata_inventory_put(app, mtos, player, listname, index, stack)` - Optional: custom actions on item put
- `allow_metadata_inventory_take(app, mtos, player, listname, index, stack)` - Optional: custom actions on item take
- `allow_metadata_inventory_move(app, mtos, player, from_list, from_index, to_list, to_index, count)`  - Optional: custom actions on item move
- `on_metadata_inventory_put(app, mtos, player, listname, index, stack)` - Optional: custom check on items put
- `on_metadata_inventory_take(app, mtos, player, listname, index, stack)` - Optional: custom check on items put
- `on_metadata_inventory_move(app, mtos, player, from_list, from_index, to_list, to_index, count)` - Optional: custom check on items put

`laptop.register_view(internal_shortname, { definitiontable })` - add a new app or view
same as register_app, but the view flag is set. app_name and app_icon not necessary

### App Object
`local app = mtos:get_app(appname)` - Give the app object internal_shortname, connected to given mtos. Not necessary in formspec_func or receive_fields_func because given trough interface
- `app:back_app()` - Go back to previous app/view
- `app:exit_app()` - Delete call stack and return to launcher


## Themes
### Theme definition
`laptop.register_theme(name, definitiontable)` - add a new theme. All parameters optional, if missed, the default is used
Definitiontable:
- `launcher_bg` Launcher background image
- `app_bg` Apps background image
- `contrast_bg` dark background to place under white text elements that does not support textcolor
- `textcolor` Default text color for buttons and labels. For buttons the major_textcolor and minor_textcolor supported
- `back_button` Back Button image
- `exit_button` Exit button image
- `app_button` App button background in launcher
- `major_button` Major (highlighted) button image
- `minor_button` Minor button image
- `node_color` Palette number to set if the node is paramtype2 = "colorfacedir"

### Theme methods
`function laptop.get_theme(theme_name)`
- `theme:get_button(area, prefix, code, text)` get a themed [prefix]_button in area 'x,y;w,h' with code an text
- `theme:get_label(pos, text)` get a themed label text starting at pos 'x,y'


## Block devices Methods
`mtos.bdev = laptop.get_bdev_handler(mtos)`

### Low-Level methods
Can be used for non-data and/or system tasks. For usual data store please use the storage methods
- `bdev:get_ram_disk()` ram store - a table with all app-related storage partitions
- `bdev:get_hard_disk()` hdd store - a table with all app-related storage partitions, if hard disk capatibility exists
- `bdev:get_removable_disk()` removable data object (drive)
- `bdev:get_cloud_disk(store_name)` - Get named cloud storage
- `bdev:sync()` - Write/store all opened and maybe changed data

### Storage methods
- `get_boot_disk()` - Check which device can be booted. possible return value is "hdd" or "removable"
- `get_app_storage(disk_type, store_name)` - Get data storage table to be used in apps.
  - disk_type can be 'ram', 'hdd', 'removable', 'cloud' or 'system'. System is eather hdd or removable storage depending on booted device
  - store_name is usually the app name. 'os' is reserved for System related saves

### Low-level Removable data
`data = bdev:get_removable_disk()`
- `bdev.inv` - node inventory (the slot)
- `bdev.label` - Meda label. Item name by default
- `bdev.def` - Registered item definition (read-only)
- `bdev.stack` - The item stack
- `bdev.meta` - Stack metadata
- `bdev.os_format`- The format type: "none", "boot", "backup", "filesystem" (read-only)
- `bdev.rtype` - Removable type. "usb" or "floppy"
- `bdev.storage` - Data table used for app storage, if format is data compatible
- `bdev:reload()` - Reload all data from node inventory
