local M = {}

function M.timedifference(s)
    local year = string.sub(s, 1, 4)
    local month = string.sub(s, 6, 7)
    local day = string.sub(s, 9, 10)
    local hour = string.sub(s, 12, 13)
    local minutes = string.sub(s, 15, 16)
    local seconds = string.sub(s, 18, 19)
    local t1 = os.time()
    local t2 = os.time { year = year, month = month, day = day, hour = hour, min = minutes, sec = seconds }
    local difference = os.difftime(t1, t2)
    return difference
end

function getURL(url)
    return os.execute("curl " .. url)
end

return M