# Laptop Mod API

## Node creator helpers
- `laptop.os_get(pos)` - Get an OS object. Usefull in on_construct or on_punch to initialize or do anything with OS
  Needed in on_receive_fields to be able to call os:receive_fields(fields, sender) for interactive apps
- `laptop.after_place_node` / `laptop.after_dig_node` - (optional) can be used directly for node definition. Move laptop apps data to ItemStack if digged and restored back if placed again. So you can take along your laptop. Note: you need to set `stack_max = 1` because the data can be stored per stack only, not per item.


## Operating system calls
Usable from node functions, from apps or outsite

`local os = laptop.os_get(pos)` - Get the Operating system object. pos is the node position

- `os:power_on(new_node_name)` - Activate the app "launcher" and if given swap node to new_node_name
- `os:power_off(new_node_name)` - Remove the formspec and if given swap node to new_node_name
- `os:set_infotext(infotext)` - Set the mouseover infotext for laptop node
- `os:save()` - Store all app-data to nodemeta. Called mostly internally so no explicit call necessary
- `os:set_app(appname)` - Start/Enable/navigate to appname. If no appname given the launcher is called
- `os:receive_fields(fields, sender)` - Should be called from node.on_receive_fields to get the apps interactive


## App Definition
`laptop.register_app(internal_shortname, { definitiontable })` - add a new app or view
- `app_name` - App name shown in launcher. If not defined the app is just a view, not visible in launcher but can be activated. This way multi-screen apps are possible
- `background_img` - if set the image is added as background to formspec by framework
-	`formspec_func(app, os)` - Function, should return the app formspec (mandatory) During definition the "app" and the "os" are available
-	`receive_fields_func(app, os, fields, sender)` Function for input processing. The "app" and the "os" are available inside the call

## App Object
`local app = laptop.get_app(internal_shortname, os)` - Give the app object internal_shortname, connected to given os. Not necessary in formspec_func or receive_fields_func because given trough interface
- `data = app:get_storage_ref()` - Returns a "persitant" data table that means the data in this table is not lost between formspec_func, receive_fields_func, apps-switch or on/off.
- `app.background_img` - Background image from definition. Can be changed at runtime
