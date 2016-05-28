package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "LIVING DEVICE"

commandArray = {}

local kitchen_detector = Switch("Keuken detector aanrecht")

kitchen_detector.whenOn(function()
    log("presence detected, turning light on")
    local lights = Switch("Keuken Spots")
    lights.turnOn()
end)

return commandArray