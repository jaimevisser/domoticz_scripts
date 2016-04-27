-- Reboot at midnight

commandArray = {}

time = os.date("*t")
print(tostring(time))
if(time.hour == 12 and time.minute == 45) then
    print("Nightly reboot!")
    os.execute("sudo reboot")
end

return commandArray
