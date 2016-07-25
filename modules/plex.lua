local plexurl = 'http://192.168.1.10:32400/'
local plextoken = '8f8a23640278ed745414aa63b776d20aeafd149a'
local clients = {}

scriptname = "T.PLEX"

local data = utils.getURL(plexurl .. 'status/sessions/?X-Plex-Token=' .. plextoken)

string.gsub(data, '<Player.-/>', function(s)
    local c, s = string.match(s, 'platform="(.-)" .* state="(.-)"')
    log(c .. ":" .. s)
    clients[c] = { status = s }
end)


if (Clients["Chromecast"] ~= nil and clients["Chromecast"].status == "Playing") then
    PlexTV.turnOn()
else
    PlexTV.turnOff()
end

return {
    clients = clients
}