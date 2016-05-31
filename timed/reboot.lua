-- Reboot at midnight

local time = os.date("*t")
if(time.hour == 1 and time.min == 0) then
    print("Nightly reboot!")
    os.execute("sudo reboot")
end
