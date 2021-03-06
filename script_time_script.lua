commandArray = {}

package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
require('modules/time')
utils = require('modules/utils')
require('modules/devices')

PlexTV = Switch("TV - Plex")

Plex = require('modules/plex')

require('common/living')
require('timed/bathroom')
require('timed/toilet')
require('timed/living')
require('timed/reboot')
require('timed/ventilation')

return commandArray