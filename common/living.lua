scriptname = "C.LIVING"

local kitchen_detector = Switch("Keuken detector aanrecht")
local living_detector = Switch("Woonkamer Sensor")
local kitchenette_door = Switch("Bijkeuken Deursensor")
local lux = Sensor("Woonkamer Lux")
local living_lights = Dimmer("Zithoek Licht")

Living = {}
Living.timeout = minutes(90)
Living.presence = kitchen_detector.on or living_detector.on or kitchenette_door.on
Living.presence = Living.presence or (kitchen_detector.lastupdate < Living.timeout)
Living.presence = Living.presence or (living_detector.lastupdate < Living.timeout)
Living.presence = Living.presence or (living_detector.lastupdate < Living.timeout)
Living.dark = lux.value < 50
Living.bright = lux.value > 100

if (Living.presence) then
    log("Probably people present")
else
    log("Probably nobody present")
end

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