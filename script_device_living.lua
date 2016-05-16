package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "LIVING DEVICE"

commandArray = {}

local kitchen_detector = Switch("Keuken detector aanrecht")

onChange(kitchen_detector, function()
    if (kitchen_detector.on) then
        local lights = Switch("Keuken Spots")
        log("presence detected, turning light on")
        lights.turnOn()
    end
end)

return commandArray