scriptname = "C.LIVING"

Living = {}
Living.detector = {}
Living.detectors = {}
Living.light = {}
Living.lights = {}

Living.detector.living = Switch("Woonkamer Sensor")
Living.detector.kitchen = Switch("Keuken detector aanrecht")
Living.detector.door = Switch("Bijkeuken Deursensor")
local detector = Living.detector

Living.detectors.lastupdate = DeviceCollection(detector).lastupdate
Living.detectors.on = detector.living.on or detector.kitchen.on or detector.door.on

Living.light.living = Dimmer("Zithoek Licht")
Living.light.kitchen = Dimmer("Keuken Licht")
Living.light.kitchen_spots = Switch("Keuken Spots")
Living.light.dining = Dimmer("Zithoek Licht")
local light = Living.light

Living.lights.lastupdate = DeviceCollection(light).lastupdate
Living.lights.on = light.living.on or light.kitchen.on or
        light.kitchen_spots.on or light.dining.on

Living.lux = Sensor("Woonkamer Lux")

Living.lights.turnOff = function() Switch("Scene:Woonkamer uit").turnOn() end
Living.lights.turnOn = function()
    if (Living.dark) then
        if (PlexTV.on) then
            Switch("Scene:TV kijken").turnOn()
        else
            Switch("Scene:Woonkamer aan").turnOn()
        end
    end
end

Living.timeout = minutes(10)
Living.timeout_kitchen = minutes(1)
Living.lastupdate = math.min(Living.lights.lastupdate, Living.detectors.lastupdate)
Living.presence = Living.detectors.on or PlexTV.on or
        Living.lastupdate < Living.timeout or
        PlexTV.lastupdate < Living.timeout
Living.dark = Living.lux.value < 50
Living.bright = Living.lux.value > 90

if (Living.presence) then
    log("Probably people present")
else
    log("Probably nobody present")
end

PlexTV.whenChanged(function()
    log("Plex changed!")
    if (Living.lights.on) then
        Living.lights.turnOn()
    end
end)