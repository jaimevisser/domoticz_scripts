package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "LIVING"

commandArray = {}

local detector = Switch("Keuken detector aanrecht")
local timeout = 30

if (detector.off and round_minutes(detector.lastupdate - timeout) == 0) then
    log("nobody in the kitchen for " .. timeout .. "s")

    local kitchen_spots = Switch("Keuken Spots")

    if(kitchen_spots.on) then
        log("turning kitchen spots off")
        kitchen_spots.turnOff()
    end
end

return commandArray