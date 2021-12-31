--[[
    GNode
    Version: 1
    Author: Droog71
    License: AGPLv3
]]--

--starts a cutting job for the given file
minetest.register_chatcommand("cut", {
    privs = {interact = true},
    description = "Starts a cutting job for the given file name." ..
        "\nUsage: '/cut file_name false' for engraving." ..
        "\nUsage: '/cut file_name true' for height to depth conversion.",
    func = function(name, param)
        local file, convert = param:match("^(%S+)%s(.+)$")
        if file and file ~= "" then
            if convert and convert == "true" or convert == "false" then
                if running == false then
                    height_to_depth = convert == "true"
                    cutting = true
                    start_job(file)
                else
                    minetest.chat_send_all("Machine is already running!")
                end
            end
        else
            minetest.chat_send_all("Usage: '/cut file_name false' for engraving.")
            minetest.chat_send_all("Usage: '/cut file_name true' for height to depth conversion.")
        end
    end
})

--starts a printing job for the given file
minetest.register_chatcommand("print", {
    privs = {interact = true},
    description = "Starts a printing job for the given file name." ..
        "\nUsage: '/print file_name'",
    func = function(name, param)
        if param ~= "" then
            if running == false then
                cutting = false
                start_job(param)
            else
                minetest.chat_send_all("Machine is already running!")
            end
        else
            return true, "Usage: '/print file_name'"
        end
    end
})

--pauses the current job
minetest.register_chatcommand("pause", {
    privs = {interact = true},
    description = "Pauses the running job." ..
        "\nEnter /resume to continue",
    func = function(name, param)
        pause_job()
        return true
    end
})

--stops the current job
minetest.register_chatcommand("stop", {
    privs = {interact = true},
    description = "Stops the current job." ..
        "\nUsage: '/stop'",
    func = function(name, param)
        stop_job("Stopped!")
        return true
    end
})

--resumes the job in progress
minetest.register_chatcommand("resume", {
    privs = {interact = true},
    description = "Resumes the current job." ..
        "\nUsage: '/resume'",
    func = function(name, param)
        if paused then
            resume_job()
        else
            minetest.chat_send_all("No paused job!")
        end
    end
})

--toggles the display of job info
minetest.register_chatcommand("output", {
    privs = {interact = true},
    description = "Toggles the display of job info." ..
        "\nUsage: '/output'",
    func = function(name, param)
        output = not output
        local on_off = output and "on" or "off"
        return true, "Job info: " .. on_off
    end
})

--changes the paint brush color
minetest.register_chatcommand("paint_color", {
    privs = {interact = true},
    description = "Changes selected color for the paint brush." ..
        "\nUsage: '/paint_color <number>'" .. 
        "\nOptions are 0 to 255. Zero is the default color.",
    func = function(name, param)
        if param then
            local selection = tonumber(param)
            if selection then
                if selection >= 0 and selection <= 255 then
                    paint_color = selection
                    minetest.chat_send_all("Paint color set to " .. paint_color)
                else
                    minetest.chat_send_all("Usage: '/paint_color <number>'")
                    minetest.chat_send_all("Options are 0 to 255. Zero is the default color.")
                end
            else
                minetest.chat_send_all("Usage: '/paint_color <number>'")
                minetest.chat_send_all("Options are 0 to 255. Zero is the default color.")
            end
        else
            minetest.chat_send_all("Usage: '/paint_color <number>'")
            minetest.chat_send_all("Options are 0 to 255. Zero is the default color.")
        end
    end
})