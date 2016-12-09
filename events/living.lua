scriptname = "E.LIVING"

local kitchen_detector = Switch("Keuken detector aanrecht")
local living_detector = Switch("Woonkamer Sensor")

kitchen_detector.whenOn(function()
    log("presence detected in kitchen")
    if (PlexTV.off) then
        Switch("Keuken Spots").turnOn()
    end
end)

living_detector.whenOn(function()
    log("presence detected in living room")
    if (Living.light.living.lastupdate > minutes(10)) then
        Living.lights.turnOn()
    end
end)