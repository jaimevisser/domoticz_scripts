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
    if (Living.dark) then
        if (PlexTV.on) then
            Switch("Scene:TV kijken").turnOn()
        else
            Switch("Scene:Woonkamer aan").turnOn()
        end
    end
end)

lux.whenChanged(function()
    if (Living.presence) then
        log("There is presence in the living room")
        if (Living.dark) then
            if (PlexTV.on) then
                Switch("Scene:TV kijken").turnOn()
            else
                Switch("Scene:Woonkamer aan").turnOn()
            end
        end
    end
    if (Living.bright) then
        log("It's getting bright, turning off lights")
        Switch("Scene:Woonkamer uit").turnOn()
    end
end)