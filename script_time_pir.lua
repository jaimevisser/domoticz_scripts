-- ingests tables: otherdevices,otherdevices_svalues

package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
mappings = require('activation_mappings')
utils = require('utils')

commandArray = {}

for device, mapping in pairs(mappings.map) do
    local lastupdate = mapping.timeout * 2

    for i, detector in ipairs(mapping) do
        if otherdevices[detector] ~= nil then
            local td = utils.timedifference(otherdevices_lastupdate[detector])
            lastupdate = math.min(lastupdate, td)
        else
            print("Detector '"..detector.."' not found in devices!")
        end
    end

    print(device.." : last interaction with detectors was "..tostring(lastupdate).." seconds ago")

    if (lastupdate > mapping.timeout and lastupdate < (mapping.timeout + 60)) then
        commandArray[device] = 'Off'
        print(device.." : Timeout reached, turning off after "..tostring(lastupdate).." seconds")
    end
end

return commandArray