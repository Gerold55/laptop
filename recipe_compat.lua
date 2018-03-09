laptop.recipe_compat = {
	-- Init all used vars to avoid crash if missed
	tin = '', copper = '', gold = '', steel = '', glass = '', diamond = '',
	silicon = '', fiber = '',
	gates_diode = '', gates_and = '', gates_or = '', gates_nand = '',
	gates_xor = '', gates_not = '',	fpga = '', programmer = '',
	delayer = '', controller = '', light_red = '', light_green = '',
	light_blue = ''
}

local rc = laptop.recipe_compat

-- Fallback values from default mod
if minetest.get_modpath('default') then
	rc.tin = 'default:tin_ingot'
	rc.copper = 'default:copper_ingot'
	rc.gold = 'default:gold_ingot'
	rc.steel = 'default:steel_ingot'
	rc.glass = 'default:glass'
	rc.diamond = 'default:diamond'
end

if minetest.get_modpath('mesecons_materials') then
	rc.silicon = 'mesecons_materials:silicon'
	rc.fiber = 'mesecons_materials:fiber'
end

if minetest.get_modpath('mesecons_gates') then
	rc.gates_diode = 'mesecons_gates:diode_off'
	rc.gates_and = 'mesecons_gates:and_off'
	rc.gates_or = 'mesecons_gates:or_off'
	rc.gates_nand = 'mesecons_gates:nand_off'
	rc.gates_xor = 'mesecons_gates:xor_off'
	rc.gates_not = 'mesecons_gates:not_off'
end

if minetest.get_modpath('mesecons_fpga') then
	rc.fpga = 'mesecons_fpga:fpga0000'
	rc.programmer = 'mesecons_fpga:programmer'
end

if minetest.get_modpath('mesecons_delayer') then
	rc.delayer = 'mesecons_delayer:delayer_off_1'
end

if minetest.get_modpath('mesecons_delayer') then
	rc.controller = 'mesecons_luacontroller:luacontroller0000'
end

if minetest.get_modpath('mesecons_lightstone') then
	rc.light_red = 'mesecons_lightstone:lightstone_red_off'
	rc.light_green = 'mesecons_lightstone:lightstone_green_off'
	rc.light_blue = 'mesecons_lightstone:lightstone_blue_off'
end
