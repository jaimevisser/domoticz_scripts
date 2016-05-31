scriptname = "LIVING"

local kitchen_detector = Switch("Keuken detector aanrecht")

kitchen_detector.whenOn(function()
    log("presence detected, turning light on")
    local lights = Switch("Keuken Spots")
    lights.turnOn()
end)