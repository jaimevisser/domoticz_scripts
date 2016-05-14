package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')
require('devices')
require('time')
scriptname = "BATHROOM DETECTOR"

local detector = Switch("Badkamer detector")

onChange(detector,function()
    log("change")


end)