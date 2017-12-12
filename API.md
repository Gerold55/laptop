# Laptop Mod API

## Add new hardware nodes
`laptop.register_hardware(name, hwdef)`
- `name` - Item name (prefix) The created node names are name_variant
- `hwdef.description`  -  Computer item name
- `hwdef.infotext` - Text shown if node is pointed
- `hwdef.sequence = { "variant_1_name", "variant_2_name", "variant_3_name" }` On punch swaps sequence. the first variant is in creative inventory
- `hwdef.custom_launcer` - optional - custom launcher name
- `hwdef.custom_theme` -  optional - custom initial theme name
- `hwdef.allowed_removable_groups` - optional. allowed removable groups. Supported "laptop_removable" = all, "laptop_removable_floppy" or "laptop_removable_usb"
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


## Operating system calls
Usable from node functions, from apps or outsite

`local mtos = laptop.os_get(pos)` - Get the Operating system object. pos is the node position

- `mtos:power_on(new_node_name)` - Activate the app "launcher" and if given swap node to new_node_name
- `mtos:resume(new_node_name)` - Restore the last running app after power_off. if given swap node to new_node_name
- `mtos:power_off(new_node_name)` - Remove the formspec and if given swap node to new_node_name
- `mtos:swap_node(new_node_name)`- Swap the node only without any changes on OS
- `mtos:set_infotext(infotext)` - Set the mouseover infotext for laptop node
- `mtos:save()` - Store all app-data to nodemeta. Called mostly internally so no explicit call necessary
- `mtos:get_app(appname)`- Get the app instance
- `mtos:set_app(appname)` - Start/Enable/navigate to appname. If no appname given the launcher is called
- `mtos:get_theme(theme)`- Get theme data current or requested (theme parameter is optional)
- `mtos:set_theme(theme)`- Activate theme
- `mtos:get_removable_data()` - Access to the item in node inventory (low-level)
- `mtos:set_removable_data()`- Store changes on low-level removable data

## App Definition
`laptop.register_app(internal_shortname, { definitiontable })` - add a new app or view
- `app_name` - App name shown in launcher. If not defined the app is just a view, not visible in launcher but can be activated. This way multi-screen apps are possible
- `app_icon` - Icon to be shown in launcher. If nothing given the default icon is used
- `app_info` - Short app info visible in launcher tooltip
- `fullscreen` - (boolean) Do not add app-background and window buttons
- `view` - (boolean) The definition is a view. That means the app/view is not visible in launcher
- `formspec_func(app, mtos)` - Function, should return the app formspec (mandatory) During definition the "app" and the "mtos" are available
- `appwindow_formspec_func(launcher_app, app, mtos)`- Only custom launcher app: App background / Window decorations and buttons
- `receive_fields_func(app, mtos, sender, fields)` Function for input processing. The "app" and the "mtos" are available inside the call
`laptop.register_view(internal_shortname, { definitiontable })` - add a new app or view
same as register_app, but the view flag is set. app_name and app_icon not necessary

## App Object
`local app = mtos:get_app(appname)` - Give the app object internal_shortname, connected to given mtos. Not necessary in formspec_func or receive_fields_func because given trough interface
- `data = app:get_storage_ref(appname)` - Returns a "persitant" data table from nodemeta (=hdd). The data in this table is not lost between formspec_func, receive_fields_func, apps-switch or on/off. Appname is optional to get data from other app
- `data = app:get_cloud_storage_ref(appname)` - Returns a persistant table from modmeta (=internet)
- `app:back_app() - Go back to previous app/view
- `app:exit_app() - Delete call stack and return to launcher

## Theme definition
`laptop.register_theme(name, definitiontable)` - add a new theme. All parameters optional, if missed, the default is used
Definitiontable:
- `launcher_bg` Launcher background image
- `app_bg` Apps background image
- `back_button` Back Button image
- `exit_button` Exit button image
- `major_button` Major (highlighted) button image
- `minor_button` Minor button image
- `textcolor` Default text color for buttons and labels. For buttons the major_textcolor and minor_textcolor supported

## Theme methods
`function laptop.get_theme(theme_name)`
- `theme:get_button(area, prefix, code, text)` get a themed [prefix]_button in area 'x,y;w,h' with code an text
- `theme:get_label(pos, text)` get a themed label text starting at pos 'x,y'

## Low-level Removable data
`data = mtos:get_removable_data()`
- `label` - Meda label. Item name by default
- `def` - Registered item definition (read-only)
- `inv` - node inventory
- `stack` - The item stack
- `meta` - Stack metadata
