---
--- Generated by Luanalysis
--- Created by kigawa.
--- DateTime: 2023/01/29 1:00
---
local NumChannel = {
    --- @return number
    getHandle = function()
        return input.getNumber(1)
    end;
    --- @param value number
    setLeft = function(value)
        output.setNumber(2, value)
    end;
    --- @param value number
    setRight = function(value)
        output.setNumber(3, value)
    end;
    --- @param value number
    setCount = function(value)
        output.setNumber(4, value)
    end;
}
local Property = {
    increaseRate = property.getNumber("increase rate");
    --- @return number
    getChangeSize = function()
        local value = property.getNumber("change size")
        if value < 1 then
            return 1.1
        end
        return value
    end;
}
-- ------------------------------
local HandlePosition = {
    CENTER = "center";
    LEFT = "left";
    RIGHT = "right";
}
--- @return "center" | "left" | "right"
function HandlePosition.getPosition()
    local handle = math.floor(NumChannel.getHandle() * 100) / 100
    if handle > 0 then
        return HandlePosition.RIGHT
    end
    if handle < 0 then
        return HandlePosition.LEFT
    end
    return HandlePosition.CENTER
end
-- ------------------------------
local count = 1
local prevHandle = HandlePosition.CENTER
local vHandle = 0
local function changeVHandle()
    local handle = HandlePosition.getPosition()
    if not prevHandle == handle then
        count = 1
    end
    count = count * (Property.increaseRate / 100)

    local change = (count * count) / Property.getChangeSize()

    if handle == HandlePosition.LEFT or (handle == HandlePosition.CENTER and vHandle > 0) then
        change = change * -1
    end

    if handle == HandlePosition.CENTER then
        if vHandle == 0 then
            count = 1
            return
        end
        if vHandle > 0 and vHandle < change * -1 then
            vHandle = 0
            return
        end
        if vHandle < 0 and vHandle > change * -1 then
            vHandle = 0
            return
        end
    end

    vHandle = vHandle + change

    if vHandle > 1 then
        vHandle = 1
        count = 1
    elseif vHandle < -1 then
        vHandle = -1
        count = 1
    end
end

-- -------------------------------------------------------
function onTick()
    changeVHandle()
    NumChannel.setRight(vHandle)
    NumChannel.setLeft(vHandle * -1)
    NumChannel.setCount(count)
end
-- ----------------------------------------------------------
