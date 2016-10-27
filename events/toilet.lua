scriptname = "E.TOILET"

local detector = Switch("WC Sensor")

detector.whenOn(function()
    log("presence detected, turning light on")
    local lights = Switch("WC Licht")
    lights.turnOn()
end)