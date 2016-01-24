-- ingests tables: otherdevices,otherdevices_svalues

package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
mappings = require('activation_mappings')


print(mappings.activation)

commandArray = {}

return commandArray