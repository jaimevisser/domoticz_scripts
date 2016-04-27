-- Reboot at midnight

time = os.date("*t")
if(time.hour == 12 and time.minute == 0) then
    os.execute("sudo reboot")
end

