--[[
    GNode
    Version: 1
    Author: Droog71
    License: AGPLv3
]]--

minetest.settings:set("viewing_range", 1000)
minetest.settings:set_bool("menu_clouds", false)
minetest.settings:set_bool("smooth_lighting", true)
minetest.settings:set_bool("enable_damage", false)
minetest.register_item(":", { type = "none", wield_image = "blank.png"})

dofile(minetest.get_modpath("gnode") .. DIR_DELIM .. "src" .. DIR_DELIM .. "nodes.lua")
dofile(minetest.get_modpath("gnode") .. DIR_DELIM .. "src" .. DIR_DELIM .. "paint.lua")
dofile(minetest.get_modpath("gnode") .. DIR_DELIM .. "src" .. DIR_DELIM .. "machine.lua")
dofile(minetest.get_modpath("gnode") .. DIR_DELIM .. "src" .. DIR_DELIM .. "commands.lua")
dofile(minetest.get_modpath("gnode") .. DIR_DELIM .. "src" .. DIR_DELIM .. "formspec.lua")

skybox.add({"Interior", "#FFFFFF", 1.0, { density = 0}})
skybox.add({"Space", "#FFFFFF", 1.0, { density = 0}})

 --initializes the player
 minetest.register_on_joinplayer(function(player)
    player:hud_set_flags({hotbar = true, healthbar = false})
    player:set_properties({
        textures = { "blank.png", "blank.png" },
        visual = "upright_sprite",
        visual_size = { x = 1, y = 2 },
        collisionbox = {-0.49, 0, -0.49, 0.49, 2, 0.49 },
        initial_sprite_basepos = {x = 0, y = 0}
    })
    minetest.set_player_privs(player:get_player_name(), {fly=true, fast=true})
    player:set_physics_override({gravity = 0})
    skybox.set(player, 7)
    local item = ItemStack("gnode:paint_brush")
    if not player:get_inventory():contains_item("main", item) then
        player:get_inventory():add_item("main", item)
    end
end)

--generates wood nodes
minetest.register_on_generated(function(minp, maxp, blockseed)
    if minp.y > 0 or maxp.y < 0 then return end
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local data = vm:get_data()
    for z = minp.z, maxp.z do
        for x = minp.x, maxp.x do
            for y = -40,-1,1 do
                local vi = area:index(x, y, z)
                data[area:index(x, y, z)] = minetest.get_content_id("gnode:wood")
            end
        end
    end
    vm:set_data(data)
    vm:write_to_map(data)
end)

--gets the size of a table
function get_size(table)
    local size = 0
    for k,v in pairs(table) do
        size = size + 1
    end
    return size
end