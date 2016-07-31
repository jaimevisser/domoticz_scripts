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
    Living.lights.turnOn()
end)

Living.lux.whenChanged(function()
    if (Living.light.living.lastupdate > minutes(4)) then
        if (Living.presence) then
            log("There is presence in the living room")
            Living.lights.turnOn()
        end
        if (Living.bright) then
            log("It's getting bright, turning off lights")
            Living.lights.turnOff()
        end
    end
end)