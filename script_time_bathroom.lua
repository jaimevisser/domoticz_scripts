package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "BATHROOM DETECTOR"

commandArray = {}

local detector = Switch("Badkamer detector")
local ceiling_light = Switch("Badkamer Licht")
local mirror_light = Switch("Badkamer spiegellicht")
local timeout = minutes(5)


if (detector.off and round_minutes(detector.lastupdate) == timeout) then
    log("nobody here for " .. timeout .. "s")

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