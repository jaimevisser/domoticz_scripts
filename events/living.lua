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
        if (Living.dark) then
            if (PlexTV.on) then
                Switch("Scene:TV kijken").turnOn()
            else
                Switch("Scene:Woonkamer aan").turnOn()
            end
        end
        if (Living.bright) then
            Switch("Scene:Woonkamer uit").turnOn()
        end
    end
end)