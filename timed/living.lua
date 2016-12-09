scriptname = "T.LIVING"

if (Living.detector.kitchen.off and
        Living.detector.kitchen.lastupdate == Living.timeout_kitchen) then
    log("nobody in the kitchen for " .. Living.timeout_kitchen .. "s")
    Living.light.kitchen_spots.turnOff()
end