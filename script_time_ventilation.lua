package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "VENTILATION"

commandArray = {}

log("Starting")

local ventilation = Multiswitch {
    [2] = 'Ventilatie stand 2',
    [3] = 'Ventilatie stand 3'
}
local moisture_bathroom = Sensor('Badkamer')
local var_setting = Uservar('Script instelling ventilatie')
local var_m_long = Uservar('Vochtgemiddelde badkamer lang')
local var_m_short = Uservar('Vochtgemiddelde badkamer kort')

every(hours(1), function()
    var_m_long.value = var_m_long.value * .90 + moisture_bathroom.value[2] * .10
end)

var_m_short.value = var_m_short.value * .80 + moisture_bathroom.value[2] * .20


for k, v in pairs(moisture_bathroom.value) do log("moisture sensor[" .. k .. "] " .. v) end

log("current ventilation: " .. ventilation.value .. " - " .. tostring(var_setting.value))

local automatic = (ventilation.value == var_setting.value) or
        (ventilation.lastupdate > hours(1))

if (not automatic) then
    log("manual mode")
    return commandArray
end

local wanted_ventilation = 0
local long_diff = moisture_bathroom.value[2] - var_m_long.value
local short_diff = moisture_bathroom.value[2] - var_m_short.value

if (long_diff > 7) then
    wanted_ventilation = 3
    log("It's very moist")
elseif(short_diff > 3) then
    wanted_ventilation = 3
    log("Sudden moisture increase!")
elseif ((moisture_bathroom.value[1] > 24)) then
    log("It's hot (" .. tostring(moisture_bathroom.value[1]) .. "C)")
    wanted_ventilation = 3
elseif (long_diff > 4) then
    log("It's moist")
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