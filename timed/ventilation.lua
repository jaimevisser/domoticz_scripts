scriptname = "T.VENTILATION"

local ventilation = Multiswitch {
    [2] = 'Ventilatie stand 2',
    [3] = 'Ventilatie stand 3'
}
local sensor_bathroom = Sensor('Badkamer Temperatuur')
local sensor_living = Sensor('Woonkamer Temperatuur')
local var_setting = Uservar('Script instelling ventilatie')
local var_m_long = Uservar('Vochtgemiddelde badkamer lang')
local var_m_short = Uservar('Vochtgemiddelde badkamer kort')

every(hours(1), function()
    var_m_long.value = var_m_long.value * .90 + sensor_bathroom.value[2] * .10
end)

var_m_short.value = var_m_short.value * .80 + sensor_bathroom.value[2] * .20


for k, v in pairs(sensor_bathroom.value) do log("moisture sensor[" .. k .. "] " .. v) end

log("current ventilation: " .. ventilation.value .. " - " .. tostring(var_setting.value))

local automatic = (ventilation.value == var_setting.value) or
        (ventilation.lastupdate > hours(1))

if (not automatic) then
    log("manual mode")
    return
end

local wanted_ventilation = 0
local long_diff = sensor_bathroom.value[2] - var_m_long.value
local short_diff = sensor_bathroom.value[2] - var_m_short.value
local house_diff = sensor_bathroom.value[2] - sensor_living.value[2]

log("long diff: " .. tostring(long_diff))
log("short diff: " .. tostring(short_diff))

if (short_diff > 2) then
    wanted_ventilation = 3
    log("Sudden moisture increase!")
elseif (long_diff > 5) then
    wanted_ventilation = 3
    log("It's still very moist")
elseif ((sensor_bathroom.value[1] > 24)) then
    log("It's hot (" .. tostring(sensor_bathroom.value[1]) .. "C)")
    wanted_ventilation = 3
elseif (long_diff > 1) then
    log("It's moist")
    wanted_ventilation = 2
elseif (house_diff > 3) then
    log("Bathroom is more moist then living")
    wanted_ventilation = 2
elseif (ventilation.lastupdate > minutes(20) and short_diff < -1 ) then
    log("Moisture level is still decreasing")
    wanted_ventilation = 2
elseif (sensor_bathroom.value[2] > 65) then
    log("Bathroom is moist")
    wanted_ventilation = 2
end

log('wanted: ' .. tostring(wanted_ventilation))

if (wanted_ventilation == ventilation.value) then
    return
end

if (wanted_ventilation < ventilation.value and ventilation.lastupdate < minutes(30)) then
    log("change too recent")
    return
end

ventilation.value = wanted_ventilation
var_setting.value = wanted_ventilation

log('changed to ' .. wanted_ventilation)

for k, v in pairs(commandArray) do log("commandArray[" .. k .. "] " .. v) end