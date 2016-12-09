scriptname = "E.KITCHENETTE"

local kitchenette_door = Switch("Bijkeuken Deursensor")

kitchenette_door.whenOn(function()
    --if (Living.dark) then
        local kitchenette_light = Switch('Bijkeuken Licht')
        kitchenette_light.turnOn()
    --end
end)

kitchenette_door.whenOff(function()
    local kitchenette_light = Switch('Bijkeuken Licht')
    kitchenette_light.turnOff()
end)