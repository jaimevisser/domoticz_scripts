local plexurl = 'http://192.168.1.10:32400/'
local plextoken = '8f8a23640278ed745414aa63b776d20aeafd149a'
local clients = {}

scriptname = "M.PLEX"

local data = utils.getURL(plexurl .. 'status/sessions/?X-Plex-Token=' .. plextoken)

string.gsub(data, '<Player.-/>', function(s)
    local stat, c = string.match(s, 'state="(.-)".*title="(.-)"')
    log(c .. ":" .. stat)
    clients[c] = { status = stat }
end)



if (clients["Chromecast"] ~= nil and clients["Chromecast"].status == "playing") then
    PlexTV.turnOn()
    PlexTV.changed = true
else
    PlexTV.turnOff()
    PlexTV.changed = true
end

return {
    clients = clients
}