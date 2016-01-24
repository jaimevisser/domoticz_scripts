-- ingests tables: otherdevices,otherdevices_svalues

package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
mappings = require('activation_mappings')


for k, v in pairs(mappings.activation) do print(k..":"..v[1]) end

commandArray = {}

return commandArray