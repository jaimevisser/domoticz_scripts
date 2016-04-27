-- Reboot at midnight

commandArray = {}

time = os.date("*t")
print(tostring(time.min))
if(time.hour == 12 and time.min == 55) then
    print("Nightly reboot!")
    os.execute("sudo reboot")
end

return commandArray
