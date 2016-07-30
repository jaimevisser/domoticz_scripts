scriptname = "E.LIVING"

local kitchen_detector = Switch("Keuken detector aanrecht")
local living_detector = Switch("Woonkamer Sensor")
local lux = Sensor("Woonkamer Lux")


kitchen_detector.whenOn(function()
    log("presence detected in kitchen")
    Switch("Keuken Spots").turnOn()
end)

living_detector.whenOn(function()
    log("presence detected in living room")
    if (PlexTV.off and lux.value[1] < 20) then
        Switch("Scene:Woonkamer aan").turnOn()
    end
end)

