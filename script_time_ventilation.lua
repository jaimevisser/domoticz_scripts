package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('functions')

commandArray = {}

function log(s)
    print("[VENTILATION] " .. s)
end

function get_ventilation()
    if (otherdevices['Ventilatie stand 3'] == "On") then return 3 end
    if (otherdevices['Ventilatie stand 2'] == "On") then return 2 end
    return 0
end

function last_ventilation_change()
    local chtime_v2 = sensor('Ventilatie stand 2').lastupdate
    local chtime_v3 = sensor('Ventilatie stand 3').lastupdate

    return math.min(chtime_v2, chtime_v3)
end

function get_automode()


    if (get_ventilation() == tonumber(uservariables['Script instelling ventilatie'])) then
        return true
    end

    if (last_ventilation_change() > hours(1)) then
        return true
    end

    return false
end

log("current ventilation: " .. get_ventilation())

if (not get_automode()) then
    log("manual mode")
    return commandArray
end

local moisture_bathroom = tonumber(string.match(otherdevices_svalues['Badkamer'], ";(.+);"))
local wanted_ventilation = 0

if (moisture_bathroom > 60) then
    wanted_ventilation = 3
elseif (moisture_bathroom > 50) then
    wanted_ventilation = 2
end

log('wanted: ' .. tostring(wanted_ventilation))

if (wanted_ventilation == get_ventilation()) then
    return commandArray
end

if (wanted_ventilation < get_ventilation() and last_ventilation_change() < minutes(30)) then
    log("change too recent")
    return commandArray
end


if (wanted_ventilation == 2) then
    commandArray['Ventilatie stand 2'] = "On"
    commandArray['Ventilatie stand 3'] = "Off"
elseif (wanted_ventilation == 3) then
    commandArray['Ventilatie stand 2'] = "Off"
    commandArray['Ventilatie stand 3'] = "On"
else
    commandArray['Ventilatie stand 2'] = "Off"
    commandArray['Ventilatie stand 3'] = "Off"
end
commandArray['Variable:Script instelling ventilatie'] = tostring(wanted_ventilation)

log('changed to ' .. wanted_ventilation)

return commandArray