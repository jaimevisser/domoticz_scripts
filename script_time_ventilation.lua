package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "VENTILATION"

commandArray = {}

log("Starting")

local ventilation = Multiswitch({
    [2] = 'Ventilatie stand 2',
    [3] = 'Ventilatie stand 3'
})

local moisture_bathroom = Sensor('Badkamer')

local var_setting = Uservar('Script instelling ventilatie')

every(hours(1), function()
end)

for k, v in pairs(moisture_bathroom.value) do log("moisture sensor[" .. k .. "] " .. v) end

log("current ventilation: " .. ventilation.value)

local automatic = (ventilation.value == var_setting.value) or
        (ventilation.lastupdate > hours(1))

if (not automatic) then
    log("manual mode")
    return commandArray
end

local wanted_ventilation = 0

if (moisture_bathroom > moisture_bathroom.value[2]) then
    wanted_ventilation = 3
elseif (moisture_bathroom > moisture_bathroom.value[2]) then
    wanted_ventilation = 2
end

log('wanted: ' .. tostring(wanted_ventilation))

if (wanted_ventilation == ventilation.value) then
    return commandArray
end

if (wanted_ventilation < ventilation.value and ventilation.lastupdate < minutes(30)) then
    log("change too recent")
    return commandArray
end

ventilation.value = wanted_ventilation
var_setting.value = wanted_ventilation

log('changed to ' .. wanted_ventilation)

for k, v in pairs(commandArray) do log("commandArray[" .. k .. "] " .. v) end

return commandArray