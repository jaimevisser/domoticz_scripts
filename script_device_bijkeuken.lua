commandArray = {}

for deviceName, deviceValue in pairs(devicechanged) do
    if (deviceName == 'Bijkeuken Deursensor') then
        print("Device based event fired on '" .. deviceName .. "', value '" .. tostring(deviceValue) .. "'")
        print("SUN: " .. otherdevices_svalues['Weer Centrum - Zon'])
        local sunvalue = tonumber(otherdevices_svalues['Weer Centrum - Zon'])
        if (deviceValue == "On" and sunvalue < 150) then
            commandArray['Bijkeuken Licht'] = "On" -- "On" / "Off"
        elseif (deviceValue == "Off") then
            commandArray['Bijkeuken Licht'] = "Off"
        end
    end
end

return commandArray