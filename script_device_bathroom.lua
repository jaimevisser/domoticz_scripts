package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "BATHROOM DETECTOR"

commandArray = {}

local detector = Switch("Badkamer detector")

detector.whenOn(function()
    log("presence detected, turning light on")
    local lights = Switch("Badkamer Licht")
    lights.turnOn()
end)

return commandArray