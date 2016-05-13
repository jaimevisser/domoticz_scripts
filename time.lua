
function minutes(minutes)
    return minutes * 60
end

function hours(hours)
    return minutes(hours * 60)
end

function every(time, fun)
    local dtable = os.date("*t", os.time())

    local ostime = math.ceil((dtable.sec + minutes(dtable.min) + hours(dtable.hour))/60)
    local time = math.ceil(time/60)

    if((ostime % time) == 0) then
    	fun()
	end
end