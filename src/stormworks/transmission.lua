---
--- Generated by Luanalysis
--- Created by kigawa.
--- DateTime: 2023/01/29 1:00
---
local NumChannel = {
    --- @return number
    getRps = function()
        return input.getNumber(1)
    end;
    --- @param value number
    setClutch = function(value)
        output.setNumber(2, value)
    end;
}
local BoolChannel = {
    --- @param value boolean
    setOne = function(value)
        output.setBool(1, value)
    end;
    --- @param value boolean
    setTwo = function(value)
        output.setBool(2, value)
    end;
    --- @param value boolean
    setThree = function(value)
        output.setBool(3, value)
    end;
    --- @param value boolean
    setFor = function(value)
        output.setBool(4, value)
    end;
}
local Property = {
    --- @field targetRps number
    targetRps = property.getNumber("target rps");
    --- @field targetRps number
    changeRate = property.getNumber("change rate");
}
-- ------------------------------
local Rps = {
    MIN = 0;
    MAX = 65;
}
local beforeRps = 0;
local currentRps = 0;
-- ---------------------------------------------------------
--- @field current number
local Clutch = {
    MIN = 5000;
    MAX = 10000;
}
local currentClutch = 1000;
local function maxClutchDiff()
    return Clutch.MAX - Clutch.MIN
end
-- ---------------------------------------------------------
local Gear = {
    MAX = 4;
    MIN = 1;
}
local gearOne = false
local gearTwo = false
local gearThree = false
local gearFour = false
function Gear.up()
    if gearOne then
        if gearTwo then
            currentClutch = Clutch.MAX
            return
        end
        gearOne = false
        gearTwo = true
        return
    end

    if gearTwo then
        if gearThree then
            gearOne = true
            return
        end
        gearTwo = false
        gearThree = true
        return
    end

    if gearThree then
        if gearFour then
            gearOne = true
            return
        end
        gearThree = false
        gearFour = true
        return
    end
    gearOne = true
    return
end
function Gear.down()
    if gearOne and not gearTwo and not gearThree and not gearFour then
        currentClutch = Clutch.MIN
        return
    end
    if gearOne then
        gearOne = false
        return
    end
    if gearTwo then
        gearOne = true
        gearTwo = false
        return
    end
    if gearThree then
        gearTwo = true
        gearThree = false
        return
    end
    gearThree = true
    gearFour = false
    return
end
-- ---------------------------------------------------------
local function down()
    local maxDiff = currentRps - Rps.MIN
    local diff = Property.targetRps - currentRps
    local diffRate = diff / maxDiff
    currentClutch = currentClutch - ((currentClutch * diffRate) * (Property.changeRate / 100))
    if currentClutch < Clutch.MIN then
        currentClutch = Clutch.MAX
        Gear.down()
    end
end
-- ---------------------------------------------------------
local function up()
    local maxDiff = Rps.MAX - currentRps
    local diff = currentRps - Property.targetRps
    local diffRate = diff / maxDiff
    currentClutch = currentClutch + ((currentClutch * diffRate) * (Property.changeRate / 100))
    if currentClutch > Clutch.MAX then
        currentClutch = Clutch.MIN
        Gear.up()
    end
end
-- ---------------------------------------------------------
function onTick()
    currentRps = NumChannel.getRps()
    if currentRps > Property.targetRps then
        up()
    else
        down()
    end
    NumChannel.setClutch(currentClutch / Clutch.MAX)
    BoolChannel.setOne(gearOne)
    BoolChannel.setTwo(gearTwo)
    BoolChannel.setThree(gearThree)
    BoolChannel.setFor(gearFour)
    beforeRps = currentRps
end