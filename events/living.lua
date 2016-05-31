scriptname = "E.LIVING"

local kitchen_detector = Switch("Keuken detector aanrecht")

kitchen_detector.whenOn(function()
    log("presence detected, turning light on")
    Switch("Keuken Spots").turnOn()
end)