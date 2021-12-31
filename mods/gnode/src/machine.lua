--[[
    GNode
    Version: 1
    Author: Droog71
    License: AGPLv3
]]--

local machine_pos = vector.new(0,0,0)
local old_nozzle_pos = vector.new(0,0,0)
local gcode_data = {}
local machine_path = {}
local machine_motion = {}
local machine_extrusion = {}
local depth_offset = 0
local path_length = 0
local path_index = 1
local timer = 0
local loaded = false
speed = 2
paused = false
running = false
cutting = false
output = true
current_job = ""
height_to_depth = false

--loads the machine state for existing worlds
minetest.register_on_joinplayer(function(player)
    if loaded == false then
        local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "save_data.json", "r")  
        if file then
            local data = minetest.parse_json(file:read "*a")
            if data then
                machine_pos = data.machine_pos and data.machine_pos or machine_pos
                old_nozzle_pos = data.old_nozzle_pos and data.old_nozzle_pos or old_nozzle_pos
                gcode_data = data.gcode_data and data.gcode_data or gcode_data
                machine_path = data.machine_path and data.machine_path or machine_path
                machine_motion = data.machine_motion and data.machine_motion or machine_motion
                machine_extrusion = data.machine_extrusion and data.machine_extrusion or machine_extrusion
                path_length = data.path_length and data.path_length or path_length
                path_index = data.path_index and data.path_index or path_index
                timer = data.timer and data.timer or timer
                speed = data.speed and data.speed or speed
                paused = data.paused and data.paused or paused
                running = data.running and data.running or running
                cutting = data.cutting and data.cutting or cutting
                output = data.output and data.output or output
                current_job = data.current_job and data.current_job or current_job
                height_to_depth = data.height_to_depth and data.height_to_depth or height_to_depth
            else
                minetest.log("error", "Failed to read save_data.json")
            end
            io.close(file)
        end
        loaded = true
    end
end)

--saves the machine state and stops the current job
minetest.register_on_shutdown(function()
    local save_vars = {
        machine_pos = machine_pos,
        old_nozzle_pos = old_nozzle_pos,
        gcode_data = gcode_data,
        machine_path = machine_path,
        machine_motion = machine_motion,
        machine_extrusion = machine_extrusion,
        path_length = path_length,
        path_index = path_index,
        timer = timer,
        speed = speed,
        paused = paused,
        running = running,
        cutting = cutting,
        output = output,
        current_job = current_job,
        height_to_depth = height_to_depth
    }
    local save_data = minetest.write_json(save_vars)
    local save_path = minetest.get_worldpath() .. DIR_DELIM .. "save_data.json"
    minetest.safe_file_write(save_path, save_data)
    stop_job("Stopped!")
end)

--starts the machine
function start_job(file_name)
    if running == false and paused == false then
        local file_data = {}
        local filepath = minetest.get_worldpath()
        local file = io.open(minetest.get_modpath("gnode") .. DIR_DELIM .. "gcode" .. DIR_DELIM .. file_name, "r")  
        if file then
            local content = file:read "*a"
            io.close(file)
            for line in string.gmatch(content, "([^".."\n".."]+)") do
                table.insert(file_data, line)
            end
            for line_number,line in pairs(file_data) do
                local block = {}
                for data in string.gmatch(line, "([^".." ".."]+)") do
                    table.insert(block, data)
                end
                table.insert(gcode_data, block)
            end
            parse_gcode(gcode_data)
            running = true
            paused = false
            current_job = file_name
            notify()
        else
            minetest.chat_send_all("Error: File does not exist!")
        end
    end
end

--stops the current job
function stop_job(message)
    if running then
        if cutting then
            minetest.remove_node(machine_path[path_index - 1])
        else
            minetest.remove_node(old_nozzle_pos)
        end
        cutting = false
        running = false
        machine_pos = vector.new(0,0,0)
        old_nozzle_pos = vector.new(0,0,0)
        gcode_data = {}
        machine_path = {}
        machine_motion = {}
        machine_extrusion = {}
        path_length = 0
        path_index = 1
        minetest.chat_send_all(message)
    else
        minetest.chat_send_all("No active job!")
    end
end

--pauses the current job
function pause_job()
    if running then
        running = false
        paused = true
        minetest.chat_send_all("Paused!")
    else
        minetest.chat_send_all("No active job!")
    end
end

--pauses the current job
function resume_job()
    if paused then
        running = true
        paused = false
    else
        minetest.chat_send_all("No paused job!")
    end
end

--creates a path
function parse_gcode(gcode_data)
    local index = 0
    local old_g = 0
    local old_e = 0
    local old_pos = vector.new(0,0,0)
    for _,data in pairs(gcode_data) do
        local new_g = nil
        local new_e = nil
        local new_pos = vector.new(old_pos.x,old_pos.y,old_pos.z)
        for _,value in pairs(data) do
            if value:sub(1, 1) == "G" then
                new_g = tonumber(value:sub(2, string.len(value)))
            elseif value:sub(1, 1) == "X" then
                new_pos.x = tonumber(value:sub(2, string.len(value)))
            elseif value:sub(1, 1) == "Y" then
                new_pos.z = tonumber(value:sub(2, string.len(value)))
            elseif value:sub(1, 1) == "Z" then
                new_pos.y = tonumber(value:sub(2, string.len(value)))
            elseif value:sub(1, 1) == "E" then
                new_e = tonumber(value:sub(2, string.len(value)))
            end
        end
        if new_g == nil then new_g = old_g else old_g = new_g end
        if new_pos.x == nil then new_pos.x = 0 end
        if new_pos.y == nil then new_pos.y = 0 end
        if new_pos.z == nil then new_pos.z = 0 end
        if new_e == nil then new_e = 0 end
        old_pos = new_pos
        index = index + 1
        machine_path[index] = new_pos
        machine_motion[index] = new_g
        machine_extrusion[index] = new_e
    end
    if height_to_depth then
        depth_offset = get_depth_offset(machine_path)
    end
    path_length = get_size(machine_path)
end

--runs the machine
minetest.register_globalstep(function(dtime)
    if running and machine_path ~= {} and path_length ~= 0 then
        timer = timer + 1
        if timer >= speed then
            if path_index < path_length then
                machine_pos = machine_path[path_index]
                if cutting and machine_motion[path_index] == 1 then
                    if height_to_depth then 
                        machine_pos.y = machine_pos.y - depth_offset 
                    end
                    for height = machine_pos.y, 1, 1 do
                        minetest.remove_node(vector.new(machine_pos.x, height, machine_pos.z))
                    end
                elseif machine_motion[path_index] == 1 and machine_extrusion[path_index] >= 0 then
                    local next_pos = machine_path[path_index + 1]
                    if next_pos then
                        if next_pos.y == machine_pos.y then
                            local x_dir = next_pos.x > machine_pos.x and 1 or -1
                            for x = machine_pos.x,next_pos.x,x_dir do
                                local z_dir = next_pos.z > machine_pos.z and 1 or -1
                                for z = machine_pos.z,next_pos.z,z_dir do
                                    minetest.set_node(vector.new(x,next_pos.y,z),{name="gnode:plastic"})
                                end
                            end
                        end
                    end
                end
                if path_index > 1 then
                    if cutting then
                        minetest.remove_node(machine_path[path_index - 1])
                        if path_index < path_length - 1 then
                            minetest.set_node(machine_pos,{name="gnode:machine"})
                        end
                    else
                        local nozzle_pos = machine_pos
                        nozzle_pos.y = nozzle_pos.y + 1
                        minetest.remove_node(old_nozzle_pos)
                        if path_index < path_length - 1 then
                            minetest.set_node(machine_pos,{name="gnode:machine"})
                        end
                        old_nozzle_pos = nozzle_pos
                    end
                end
                if output then
                    local percent_complete = math.floor((path_index / path_length) * 100) .. "% complete: "
                    local motion = " G" .. machine_motion[path_index]
                    local pos = " X" .. machine_pos.x .. " Y" .. machine_pos.z .. " Z" .. machine_pos.y
                    local extrusion = " E" .. machine_extrusion[path_index]
                    minetest.chat_send_all(percent_complete .. motion .. pos .. extrusion)
                end
                path_index = path_index + 1
                timer = 0
            else
                stop_job("Completed!")
            end
        end
    end
end)

--machine start notification
function notify()
    if cutting then
        if height_to_depth == true then
            minetest.chat_send_all("Engraving " .. current_job .. " with height to depth conversion.")
        else
            minetest.chat_send_all("Engraving " .. current_job)
        end
    else
        minetest.chat_send_all("Printing " .. current_job)
    end
end

--returns the highest y position in the table
function get_depth_offset(positions)
    local depth = 0
    for index,pos in pairs(positions) do
        if pos.y > depth then depth = pos.y end
    end
    return depth
end