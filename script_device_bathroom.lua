package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "BATHROOM DETECTOR"

local detector = Switch("Badkamer detector")
local lights = Switch("Badkamer Licht")

onChange(detector, function()
    log("change")
    if (detector.on) then
        lights.turnOn()
    end
end)