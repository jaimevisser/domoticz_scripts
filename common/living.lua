scriptname = "C.LIVING"

local living_lights = Dimmer("Zithoek Licht")

if (PlexTV.changed) then
    log("Plex changed!")
    if (living_lights.on) then
        if (PlexTV.on) then
            Switch("Scene:TV kijken").turnOn()
        else
            Switch("Scene:Woonkamer aan").turnOn()
        end
    end
end