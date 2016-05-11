package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')

function log(s)
    print("[" .. scriptname .. "] " .. s)
end

function minutes(minutes)
    return minutes * 60
end

function hours(hours)
    return minutes(hours * 60)
end

function Device(a)
    local lastupdate = utils.timedifference(otherdevices_lastupdate[a])

    log("device created: " .. a .. " lastupdate " .. tostring(lastupdate))

    return {
        name = a,
        lastupdate = lastupdate
    }
end

function Sensor(a)
    local sensor = Device(a)

    return sensor
end

function Sensors(devices)
    local lastupdate
    local sensors = {}

    log("creating a Sensors collection")

    for i, v in pairs(devices) do
        log("adding device " .. v)
        sensors[i] = Sensor(v)
    end

    for i, v in pairs(sensors) do
        if (lastupdate == nil) then
            lastupdate = v.lastupdate
        else
            lastupdate = math.min(lastupdate, v.lastupdate)
        end
    end

    return {
        sensors = sensors,
        lastupdate = lastupdate
    }
end

local multiswitch = {
    __index = function(table, index)
        if (index == "value") then return table.getvalue() end
        return rawget(table, index)
    end,
    __newindex = function(table, index, value)
        log("setting: " .. index .. " to " .. value)
        if (index == "value") then table.setvalue(value) return end
        return rawset(table, index, value)
    end
}

function Multiswitch(devices)
    log("Creating a multiswitch device")
    local switch = Sensors(devices)

    switch.getvalue = function()
        local value = 0
        for i, v in pairs(switch.sensors) do
            if (otherdevices[v.name] == "On") then
                value = i
            end
        end
        return value
    end

    switch.setvalue = function(value)
        log("setting multiswitch value to " .. value)
        for i, v in pairs(switch.sensors) do
            log("  " .. tostring(i) .. " - " .. v.name .. " - " .. otherdevices[v.name])
            if (otherdevices[v.name] == "On" and not i == value) then
                log("  OFF")
                commandArray[v.name] = "Off"
            end
            if (otherdevices[v.name] == "Off" and i == value) then
                log("  ON")
                commandArray[v.name] = "On"
            end
        end
    end

    setmetatable(switch, multiswitch)
    return switch
end