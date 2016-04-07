-- ingests tables: otherdevices,otherdevices_svalues

package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
mappings = require('activation_mappings')
utils = require('utils')

commandArray = {}

function check_device(device, mapping)
    local lastupdate = mapping.timeout + 1000

    for i, detector in ipairs(mapping) do
        if otherdevices[detector] ~= nil then
            if otherdevices[detector] == "On" then
                print(device .. " stays on because detector '" .. detector .. "' is still on")
                return
            end
            local td = utils.timedifference(otherdevices_lastupdate[detector])
            lastupdate = math.min(lastupdate, td)
        else
            print("Detector '" .. detector .. "' not found in devices!")
        end
    end

    if (lastupdate > mapping.timeout and lastupdate < (mapping.timeout + 60)) then
        commandArray[device] = 'Off'
        print(device .. " : Timeout reached, turning off after " .. tostring(lastupdate) .. " seconds")
    end
end

for device, mapping in pairs(mappings.map) do
    check_device(device, mapping)
end

return commandArray