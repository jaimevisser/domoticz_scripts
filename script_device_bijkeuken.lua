commandArray = {}

for deviceName, deviceValue in pairs(devicechanged) do
    print("Device based event fired on '" .. deviceName .. "', value '" .. tostring(deviceValue) .. "'");
    if (deviceName == 'Bijkeuken Deursensor') then
        print("Deursensor is " .. tostring(deviceValue))
        commandArray['Bijkeuken Licht'] = deviceValue -- "On" / "Off"
    end
end