scriptname = "T.BATHROOM"

local detector = Switch("Badkamer detector")
local timeout = minutes(3)

if (detector.off and detector.lastupdate == timeout) then
    log("nobody here for " .. timeout .. "s")

    Switch("Badkamer Licht").turnOff()
    Switch("Badkamer spiegellicht").turnOff()
end