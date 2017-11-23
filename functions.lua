function laptop.register_app(name,size)
   table.insert(laptop.apps, {name, size})
   print ('registering '..name..' app.')
end

function laptop.display_app(name)
   for i in ipairs (laptop.apps) do
      local app_name = laptop.apps[i][1]
      local app_size = laptop.apps[i][2]

      local formspec =
      'size[15,10]'..
      'label[0,0;You are running '..app_name..'.]'..
      'button[0,9;1,1;exit;Exit]'
      return formspec
   end
end

function laptop.display_menu()
   local out = ''
   local num_of_apps = table.getn(laptop.apps)
   for i = 0, num_of_apps-1, 1 do
      out = out .. 'button['..2*i..',1;2,1;app name;App Name]'
   end
   local formspec =
   'size[15,10]'..
   out..
	'background[15,10;0,0;os_main2.png;true]'..
	'bgcolor[#00000000;false]'
   return formspec
end

laptop.register_app('notepad', '10,10')
