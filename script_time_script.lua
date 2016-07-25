package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('modules/utils')
require('modules/devices')
require('modules/time')

PlexTV = Switch("TV - Plex")

Plex = require('modules/plex')

commandArray = {}

require('timed/bathroom')
require('timed/living')
require('timed/reboot')
require('timed/ventilation')

return commandArray