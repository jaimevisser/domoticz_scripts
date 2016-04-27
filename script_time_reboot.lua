-- Reboot at midnight

time = os.date("*t")
if(time.hour == 12 and time.minute == 0) then
    print("Nightly reboot!")
    os.execute("sudo reboot")
end

