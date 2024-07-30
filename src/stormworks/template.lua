
---
--- Generated by Luanalysis
--- Created by kigawa.
--- DateTime: 2023/01/29 1:00
---
local NumChannel = {
    --- @return number
    getThrottle = function()
        return input.getNumber(1)
    end;
    --- @param value number
    setFuel = function(value)
        output.setNumber(2, value)
    end;
    --- @param value number
    setAir = function(value)
        output.setNumber(3, value)
    end;
}
local BoolChannel = {
    --- @return  boolean
    getKey = function()
        return input.getBool(1)
    end;
    --- @param value boolean
    setStarter = function(value)
        output.setBool(2, value)
    end;
    --- @param value boolean
    setBack = function(value)
        output.setBool(3, value)
    end;
}
local Property = {
    --- @field targetRps number
    minThrottle = property.getNumber("min throttle");
    --- @field targetRps number
    changeValue = property.getNumber("change value");
}
-- ---------------------------------------------------------
function onTick()

end