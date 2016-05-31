scriptname = "LIVING"

local detector = Switch("Keuken detector aanrecht")
local timeout = minutes(1)

if (detector.off and round_minutes(detector.lastupdate - timeout) == 0) then
    log("nobody in the kitchen for " .. timeout .. "s")

    local kitchen_spots = Switch("Keuken Spots")

    if(kitchen_spots.on) then
        log("turning kitchen spots off")
        kitchen_spots.turnOff()
    end
end