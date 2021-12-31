--[[
    GNode
    Version: 1
    Author: Droog71
    License: AGPLv3
]]--

paint_color = 0
local paint_node_1 = ""
local paint_node_2 = ""
local paint_pos_1 = nil
local paint_pos_2 = nil

--registers the paint brush item
minetest.register_craftitem("gnode:paint_brush", {
    description = "Paint Brush",
    inventory_image = "paint_brush.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.under ~= nil then
            local node = minetest.get_node(pointed_thing.under)
            if node ~= nil then
                if node.name == "gnode:plastic" or node.name == "gnode:wood" then
                    if paint_pos_1 == nil then
                        paint_node_1 = node.name
                        paint_pos_1 = pointed_thing.under
                        minetest.set_node(pointed_thing.under, {name="gnode:pos_1"})
                    elseif paint_pos_2 == nil then
                        paint_node_2 = node.name
                        paint_pos_2 = pointed_thing.under
                        minetest.set_node(pointed_thing.under, {name="gnode:pos_2"})
                    end
                end
            end
        end
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        if paint_pos_1 ~= nil and paint_pos_2 ~= nil then
            if paint_node_1 == paint_node_2 then
                paint(paint_node_1)
            end
        end
    end
})

--paints nodes between pos 1 and pos 2
function paint(node_name)
    local x_dir = paint_pos_1.x < paint_pos_2.x and 1 or -1
    for x = paint_pos_1.x,paint_pos_2.x,x_dir do
        local z_dir = paint_pos_1.z < paint_pos_2.z and 1 or -1
        for z = paint_pos_1.z,paint_pos_2.z,z_dir do
            local y_dir = paint_pos_1.y < paint_pos_2.y and 1 or -1
            for y = paint_pos_1.y,paint_pos_2.y,y_dir do
                local target = minetest.get_node(vector.new(x,y,z)).name
                if target == node_name or target == "gnode:pos_1" or target == "gnode:pos_2" then
                    local painted_node = {name = node_name, param2 = paint_color}
                    minetest.set_node(vector.new(x,y,z), painted_node)
                end
            end
        end
    end
    paint_pos_1 = nil
    paint_pos_2 = nil
end