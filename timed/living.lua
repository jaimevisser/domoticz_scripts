scriptname = "T.LIVING"

local detector = Switch("Keuken detector aanrecht")
local timeout = minutes(1)

if (detector.off and round_minutes(detector.lastupdate - timeout) == 0) then
    log("nobody in the kitchen for " .. timeout .. "s")

    Switch("Keuken Spots").turnOff()
end