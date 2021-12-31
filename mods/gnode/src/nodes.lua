--[[
    GNode
    Version: 1
    Author: Droog71
    License: AGPLv3
]]--

minetest.register_node("gnode:machine", {
    name = "machine",
    description = "Machine",
    tiles = {"machine.png"},
    drawtype = "mesh",
    mesh = "machine.obj"
})

minetest.register_node("gnode:wood", {
    name = "wood",
    description = "Wood",
    paramtype2 = "color",
    place_param2 = 0,
    palette = "palette.png",
    description = "wood",
    tiles = {"wood.png"}
})

minetest.register_node("gnode:plastic", {
    name = "plastic",
    description = "Plastic",
    paramtype2 = "color",
    place_param2 = 0,
    palette = "palette.png",
    tiles = {"plastic.png"}
})

minetest.register_node("gnode:pos_1", {
    name = "pos_1",
    description = "pos_1",
    description = "pos_1",
    drawtype = "glasslike",
    light_source = 10,
    tiles = {"pos_1.png"}
})

minetest.register_node("gnode:pos_2", {
    name = "pos_2",
    description = "pos_2",
    description = "pos_2",
    drawtype = "glasslike",
    light_source = 10,
    tiles = {"pos_2.png"}
})

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if node.name == "gnode:wood" then
        local item = ItemStack("gnode:wood")
        if puncher:get_inventory():add_item("main", item) then
            minetest.remove_node(pos)
        end
    elseif node.name == "gnode:plastic" then
        local item = ItemStack("gnode:plastic")
        if puncher:get_inventory():add_item("main", item) then
            minetest.remove_node(pos)
        end
    end
end)