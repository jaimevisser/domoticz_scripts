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

    return {
        name = a,
        lastupdate = lastupdate
    }
end

function Sensor(a)
    local sensor = Device(a)

    sensor.value = {}

    log("sensor "..a.." - "..otherdevices_svalues[a])
    string.gsub(otherdevices_svalues[a], "([^;]+)", function(s)
        log("sensor value: " .. s)
        sensor.value[#sensor.value] = s
        return s
    end)


    return sensor
end

function MultiDevice(devices, builder)
    local lastupdate
    local sensors = {}

    for i, v in pairs(devices) do
        sensors[i] = builder(v)
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
        if (index == "value") then table.setvalue(value) return end
        return rawset(table, index, value)
    end
}

function Multiswitch(devices)
    local switch = MultiDevice(devices, Device)

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
        for i, v in pairs(switch.sensors) do
            if (otherdevices[v.name] == "On" and i ~= value) then
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