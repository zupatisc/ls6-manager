local function call_dmenu(options)
    local result = nil
    -- Build the command to pass the options to dmenu_run
    local command = string.format("echo '%s' | dmenu", options)

    -- Execute the command and capture the result
    local handle = io.popen(command)
    if handle then
        result = handle:read("*a")
        handle:close()
    else
        return nil
    end

    return result
end

local function get_services()
    local services = {}
    local result = nil
    local command = "sudo s6-rc-db list all" -- There could be a machinefriendly way to this but skarnet lacks manpages

    local handle = io.popen(command)
    if handle then
        result = handle:read("*a")
        handle:close()
    else
        return nil
    end

    -- Iterate over each line in the string and add it to the table
    for line in result:gmatch("[^\n]+") do
        table.insert(services, line)
    end
    services.string = result -- Keep the string version for dmenu

    return services
end

local function make_history(histfile)

end


-- [[
-- Start ==> Mode selection ==> Service selection
-- ]]


-- Modes, what we want to do with the service
local modes = { "Start", "Stop", "Restart"}
-- History file for ordering
local histfile = "~/.ls6_history"

-- Define our available services for selection
local services = get_services()
print("Services: ", services)

-- Make or get History
local history = make_history(histfile)

-- Adjust history to what services we actually found

-- 

-- Do something with the result obtained from dmenu_run
print("You selected: " .. call_dmenu(services.string))
