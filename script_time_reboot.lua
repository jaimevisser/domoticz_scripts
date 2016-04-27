-- Reboot at midnight

commandArray = {}

time = os.date("*t")
print(tostring(time.minute))
if(time.hour == 12 and time.minute == 55) then
    print("Nightly reboot!")
    os.execute("sudo reboot")
end

return commandArray
