--[[
    GNode
    Version: 1
    Author: Droog71
    License: AGPLv3
]]--

local file_btn_keys = {}

--defines the inventory formspec
local function inventory_formspec(player)
    local display = output and "true" or "false"
    local formspec = {
        "size[8,10]",
        "bgcolor[#252525;false]",
        "button[1,1;2,0.5;cut;CNC]",
        "button[5,1;2,0.5;print;3D Printing]",
        "button[1,2;2,0.5;pause;Pause]",
        "button[3,2;2,0.5;resume;Resume]",
        "button[5,2;2,0.5;stop;Stop]",
        "button[1,3;2,0.5;speed-;Speed-]",
        "label[3.75,3;"..(12 - speed).."]",
        "button[5,3;2,0.5;speed+;Speed+]",
        "button[3,4;2,0.5;paint;Paint Color]",
        "checkbox[3.05,5;display;Show job info;" .. display .. "]",
        "list[current_player;main;0,6;8,4;]"
    }
    return formspec
end

--defines the cnc formspec
local function cut_formspec(player)
    local file_buttons = {}
    local file = io.open(minetest.get_modpath("gnode") .. DIR_DELIM .. "gcode" .. DIR_DELIM .. "files.json", "r")  
    if file then
        local data = minetest.parse_json(file:read "*a")
        if data then
            local index = 1
            for _,file in pairs(data.files) do
                if file.type == "cut" then
                    file_buttons[index] = "button[2," .. index .. ";6,2;" .. file.name .. ";" .. file.name .. "]"
                    file_btn_keys[file.name] = file.type
                    index = index + 1
                end
            end
        else
            minetest.log("error", "Failed to read files.json")
        end
        io.close(file)
    end
    local convert = height_to_depth and "true" or "false"
    local formspec = {
        "size[10,10]",
        "bgcolor[#252525;false]",
        "checkbox[2.7,0.25;convert;Height to depth conversion (experimental);" .. convert .. "]",
        table.concat(file_buttons),
        "button[2,8;6,2;back;Back]"
    }
    return formspec
end

--defines the 3d printing formspec
local function print_formspec(player)
    local file_buttons = {}
    local file = io.open(minetest.get_modpath("gnode") .. DIR_DELIM .. "gcode" .. DIR_DELIM .. "files.json", "r")  
    if file then
        local data = minetest.parse_json(file:read "*a")
        if data then
            local index = 1
            for _,file in pairs(data.files) do
                if file.type == "print" then
                    file_buttons[index] = "button[2," .. index .. ";6,2;" .. file.name .. ";" .. file.name .. "]"
                    file_btn_keys[file.name] = file.type
                    index = index + 1
                end
            end
        else
            minetest.log("error", "Failed to get file list for gnode.")
        end
        io.close(file)
    end
    local formspec = {
        "size[10,10]",
        "bgcolor[#252525;false]",
        table.concat(file_buttons),
        "button[2,8;6,2;back;Back]"
    }
    return formspec
end

--defines the paint color formspec
local function paint_formspec(player)
    local text = "The palette is read from left to right and from\n" ..
        "top to bottom. The indexing starts from 0.\n\n" ..

        "Examples:\n\n" ..

        "* 0: the top left corner\n" ..
        "* 4: the fifth pixel in the first row\n" ..
        "* 16: the pixel below the top left corner\n" ..
        "* 255: the bottom right corner\n"
    local formspec = {
        "size[30,22]",
        "bgcolor[#252525;false]",
        "image[2,0.5;18,18;".."palette_guide.png".."]",
        "label[18,7;"..text.."]",
        "field[10.5,18;6,2;paint_color;Paint Color;]",
        "button[19,18.25;3,0.75;back;Back]"
    }
    return formspec
end

--sets the inventory formspec
minetest.register_on_joinplayer(function(player)
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "" then return end
    for key, val in pairs(fields) do
        if key == "back" then
            local formspec = inventory_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        elseif key == "cut" then
            local formspec = cut_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        elseif key == "convert" then
            height_to_depth = not height_to_depth
            local convert = height_to_depth and "true" or "false"
            minetest.chat_send_all("Height to depth conversion: " .. convert)
        elseif key == "display" then
            output = not output
            local on_off = output and "on" or "off"
            minetest.chat_send_all("Job info: " .. on_off)
        elseif key == "print" then
            local formspec = print_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        elseif key == "paint" then
            local formspec = paint_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        elseif key == "pause" then
            pause_job()
        elseif key == "resume" then
            if paused then
                resume_job()
                close_gui(player)
            else
                minetest.chat_send_all("No paused job!")
            end
        elseif key == "stop" then
            stop_job("Stopped!")
        elseif key == "speed-" and speed < 10 then
            speed = speed + 1
            local formspec = inventory_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        elseif key == "speed+" and speed > 2 then
            speed = speed - 1
            local formspec = inventory_formspec(player)
            player:set_inventory_formspec(table.concat(formspec, ""))
        else
            for name,job in pairs(file_btn_keys) do
                if key == name then
                    if running == false then
                        if job == "cut" then
                            cutting = true
                            start_job(name)
                            close_gui(player)
                        elseif job == "print" then
                            cutting = false
                            start_job(name)
                            close_gui(player)
                        end
                    else
                        minetest.chat_send_all("Machine is already running!")
                    end
                end
            end
        end
    end 
    if fields.paint_color then
        local value = tonumber(fields.paint_color)
        if value then
            if value >= 0 and value <= 255 then
                paint_color = value
                minetest.chat_send_all("Paint color set to " .. paint_color)
            end
        end
    end
end)

--closes the gui
function close_gui(player)
    minetest.close_formspec(player:get_player_name(), "")
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end