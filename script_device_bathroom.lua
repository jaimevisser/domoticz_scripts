package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "BATHROOM DETECTOR"

commandArray = {}

local detector = Switch("Badkamer detector")
local lights = Switch("Badkamer Licht")

onChange(detector, function()
    if (detector.on) then
        log("presence detected, turning light on")
        lights.turnOn()
    end
end)

return commandArray