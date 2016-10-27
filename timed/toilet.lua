scriptname = "T.TOILET"

local detector = Switch("WC Sensor")
local timeout = minutes(1)

if (detector.off and detector.lastupdate == timeout) then
    log("nobody here for " .. timeout .. "s")

    Switch("WC Licht").turnOff()
end