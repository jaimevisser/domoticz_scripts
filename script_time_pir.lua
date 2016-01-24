-- ingests tables: otherdevices,otherdevices_svalues

package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
mappings = require('activation_mappings')
utils = require('utils')


for device, mapping in pairs(mappings.map) do
    local lastupdate = mapping.timeout * 2

    for detector in ipairs(mapping) do
        if otherdevices[detector] ~= nil then
            lastupdate = min(lastupdate, utils.timedifference(otherdevices_lastupdate[detector]))
        else
            print("Detector '"..detector.."' not found in devices!")
        end
    end

    if (lastupdate > mapping.timeout and lastupdate < (mapping.timeout + 60)) then
        commandArray[device] = 'Off'
    end
end

commandArray = {}

return commandArray