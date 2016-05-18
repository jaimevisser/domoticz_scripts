package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "BATHROOM"

commandArray = {}

local detector = Switch("Badkamer detector")
local timeout = minutes(4)
local moisture_bathroom = Sensor('Badkamer')
local var_m_long = Uservar('Vochtgemiddelde badkamer lang')

if (detector.off and round_minutes(detector.lastupdate - timeout) == 0 and
        (moisture_bathroom.value[2] - var_m_long.value) > 4) then
    log("nobody here for " .. timeout .. "s")

    local ceiling_light = Switch("Badkamer Licht")
    local mirror_light = Switch("Badkamer spiegellicht")

    if (ceiling_light.on) then
        log("turning ceiling light off")
        ceiling_light.turnOff()
    end

    if (mirror_light.on) then
        log("turning mirror light off")
        mirror_light.turnOff()
    end
end


return commandArray