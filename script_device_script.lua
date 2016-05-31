package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('modules/utils')
require('modules/devices')
require('modules/time')

commandArray = {}

require('events/bathroom')
require('events/kitchenette')
require('events/living')

return commandArray