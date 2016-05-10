package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')

function minutes(minutes)
    return minutes * 60
end

function hours(hours)
    return minutes(hours * 60)
end

function Device(a)
    return {
        name = a,
        lastupdate = utils.timedifference(otherdevices_lastupdate[a])
    }
end

function Sensor(a)
    local sensor = Device(a)

    return sensor
end

function Sensors(devices)
    local lastupdate
    local sensors = {}

    for i, v in ipairs(sensors) do
        sensors[i] = Sensor(v)
    end

    for i, v in ipairs(sensors) do
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
        if (index == "value") then table.setvalue(value) return end
        return rawset(table, index, value)
    end
}

function Multiswitch(devices)
    local switch = Sensors(devices)

    switch.getvalue = function()
        local value = 0
        for i, v in ipairs(switch.sensors) do
            if (otherdevices[v.name] == "On") then
                value = i
            end
        end
        return value
    end

    switch.setvalue = function(value)
        for i, v in ipairs(switch.sensors) do
            if (otherdevices[v.name] == "On" and not i == value) then
                commandArray[v.name] = "Off"
            end
            if (otherdevices[v.name] == "Off" and i == value) then
                commandArray[v.name] = "On"
            end
        end
    end

    setmetatable(switch, multiswitch)
    return switch
end

function log(s)
    print("[" .. scriptname .. "] " .. s)
end