package.path = package.path .. ';' .. '/home/pi/domoticz/scripts/lua/?.lua'
utils = require('utils')

function minutes(minutes)
    return minutes * 60
end

function hours(hours)
    return minutes(hours * 60)
end

function sensor(sensor)
    local lastupdate_secs = utils.timedifference(otherdevices_lastupdate[sensor])

    return {
        lastupdate = lastupdate_secs
    }
end