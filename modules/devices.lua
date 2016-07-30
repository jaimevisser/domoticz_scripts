package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('modules/utils')

scriptname = "M.DEVICES"

function log(s)
    print("[" .. scriptname .. "] " .. s)
end

function debug(name, table)
    for i, v in pairs(table) do log(name .. "['" .. i .. "'] = " .. tostring(v)) end
end

if (devicechanged ~= nil) then
    debug("devicechanged", devicechanged)
end
--debug("otherdevices", otherdevices)
--debug("otherdevices_svalues", otherdevices_svalues)

State = {
    on = "On",
    off = "Off"
}

local function changed(device)
    for deviceName, deviceValue in pairs(devicechanged) do
        if (deviceName == device.name) then
            return true
        end
    end

    return false
end

function onChange(device, f)
    if (changed(device)) then
        f()
    end
end

function Device(name)
    local device = {}

    device.name = name
    device.lastupdate = utils.timedifference(otherdevices_lastupdate[a])
    device.changed = changed(device)
    device.whenChanged = function(f)
        if (device.changed) then f() end
    end

    return device
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
        if (switch.off) then
            switch.off = false
            switch.on = true
            switch.changed = true
            log("Turning " .. a .. " on")
            commandArray[a] = State.on
        end
    end

    switch.turnOff = function()
        if (switch.on) then
            switch.off = true
            switch.on = false
            switch.changed = true
            log("Turning " .. a .. " off")
            commandArray[a] = State.off
        end
    end

    switch.whenOn = function(f)
        if (switch.changed and switch.on) then f() end
    end

    switch.whenOff = function(f)
        if (switch.changed and switch.off) then f() end
    end

    return switch
end

function Dimmer(a)
    local dimmer = Sensor(a)

    dimmer.on = dimmer.value[1] > 0
    dimmer.off = not dimmer.on

    return dimmer
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