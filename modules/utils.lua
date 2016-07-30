local M = {}

M.maxtime = days(9000)

function M.timedifference(s)
    if (s == nil) then return M.maxtime end

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

function M.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

function M.getURL(url)
    return M.capture("curl " .. url, false)
end

return M