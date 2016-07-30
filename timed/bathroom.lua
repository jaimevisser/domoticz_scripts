scriptname = "T.BATHROOM"

local detector = Switch("Badkamer detector")
local timeout = minutes(3)

log("DETECTOR: " .. detector.lastupdate)

if (detector.off and
        round_minutes(detector.lastupdate - timeout) == 0) then
    log("nobody here for " .. timeout .. "s")

    Switch("Badkamer Licht").turnOff()
    Switch("Badkamer spiegellicht").turnOff()
end