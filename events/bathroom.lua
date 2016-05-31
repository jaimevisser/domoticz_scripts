scriptname = "BATHROOM"

local detector = Switch("Badkamer detector")

detector.whenOn(function()
    log("presence detected, turning light on")
    local lights = Switch("Badkamer Licht")
    lights.turnOn()
end)