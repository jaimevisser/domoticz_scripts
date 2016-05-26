package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')

State = {
    on = "On",
    off = "Off"
}

function log(s)
    print("[" .. scriptname .. "] " .. s)
end

function onChange(device, f)
    for deviceName, deviceValue in pairs(devicechanged) do
        if (deviceName == device.name) then
            f()
        end
    end
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
    local i = 1

    sensor.value = {}

    string.gsub(otherdevices_svalues[a], "([0-9.]+)", function(s)
        sensor.value[i] = tonumber(s)
        i = i + 1
        return s
    end)

    return sensor
end

function Switch(a)
    local switch = Device(a)

    switch.on = otherdevices[a] == State.on
    switch.off = not switch.on
    switch.turnOn = function()
        commandArray[a] = State.on
    end
    switch.turnOff = function()
        commandArray[a] = State.off
    end

    switch.whenOn = function(f)
        onChange(switch, function()
            if (switch.on) then f() end
        end)
    end

    return switch
end

function MultiDevice(devs, builder)
    local lastupdate
    local devices = {}

    for i, v in pairs(devs) do
        devices[i] = builder(v)
    end

    for i, v in pairs(devices) do
        if (lastupdate == nil) then
            lastupdate = v.lastupdate
        else
            lastupdate = math.min(lastupdate, v.lastupdate)
        end
    end

    return {
        devices = devices,
        lastupdate = lastupdate
    }
end

function Multiswitch(devices)
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

    local switch = MultiDevice(devices, Switch)

    switch.getvalue = function()
        local value = 0
        for i, v in pairs(switch.devices) do
            if (v.on) then
                value = i
            end
        end
        return value
    end

    switch.setvalue = function(value)
        for i, v in pairs(switch.devices) do
            if (v.on and i ~= value) then
                v.turnOff()
            end
            if (v.off and i == value) then
                v.turnOn()
            end
        end
    end

    setmetatable(switch, multiswitch)
    return switch
end

function Uservar(var, conversion)
    conversion = conversion or tonumber

    local uservar = {
        __index = function(table, index)
            if (index == "value") then return table.getvalue() end
            return rawget(table, index)
        end,
        __newindex = function(table, index, value)
            if (index == "value") then table.setvalue(value) return end
            return rawset(table, index, value)
        end
    }

    local vartable = {
        name = var,
        getvalue = function()
            return conversion(uservariables[var])
        end,
        setvalue = function(value)
            commandArray['Variable:' .. var] = tostring(value)
        end
    }

    setmetatable(vartable, uservar)
    return vartable
end