--fixes map lighting
local function mapfix(minp, maxp)
	local vm = minetest.get_voxel_manip(minp, maxp)
	vm:write_to_map()
	vm:update_map()
	local emin, emax = vm:get_emerged_area()
end

--calls the mapfix function
minetest.register_chatcommand("mapfix", {
	description = "Recalculate the light of a chunk",
	func = function(name, param)
    local player = minetest.get_player_by_name(name)
		local pos = vector.round(player:get_pos())
		local minp = vector.subtract(pos, 112)
		local maxp = vector.add(pos, 112)
		mapfix(minp, maxp)
		return true, "Map fixed!"
	end,
})
