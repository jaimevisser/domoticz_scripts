package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('functions')
scriptname = "VENTILATION"

commandArray = {}

log("Starting")

local ventilation = Multiswitch({
    [2] = 'Ventilatie stand 2',
    [3] = 'Ventilatie stand 3'
})
local m_bathroom = Sensor('Badkamer')

local automatic = (ventilation.value == tonumber(uservariables['Script instelling ventilatie'])) or
        (ventilation.lastupdate > hours(1))

log("current ventilation: " .. ventilation.value)

if (not automatic) then
    log("manual mode")
    return commandArray
end

local moisture_bathroom = tonumber(string.match(otherdevices_svalues['Badkamer'], ";(.+);"))
local wanted_ventilation = 0

if (moisture_bathroom > 60) then
    wanted_ventilation = 3
elseif (moisture_bathroom > 55) then
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

commandArray['Variable:Script instelling ventilatie'] = tostring(wanted_ventilation)

log('changed to ' .. wanted_ventilation)

for k, v in pairs(commandArray) do log("commandArray[" .. k .. "] " .. v) end

return commandArray