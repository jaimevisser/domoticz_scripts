scriptname = "E.LIVING"

local kitchen_detector = Switch("Keuken detector aanrecht")
local living_detector = Switch("Woonkamer Sensor")

kitchen_detector.whenOn(function()
    log("presence detected in kitchen")
    Switch("Keuken Spots").turnOn()
end)

living_detector.whenOn(function()
    log("presence detected in living room")
    if (PlexTV.off) then
        Switch("Scene:Woonkamer aan").turnOn()
    end
end)