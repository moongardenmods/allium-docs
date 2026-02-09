-- #region init
local Animal = require("com.example.Animal")

local dogClassBuilder = java.extendClass(Animal)
-- #endregion init
-- #region field
dogClassBuilder:field("weight", java.int, { final = true })

function dogClassBuilder:clinit(class)
    -- set static fields here
end
-- #endregion field
-- #region using
local superUse = dogClassBuilder:usingSuper({java.int}, function(speed, weight)
    -- super constructor uses the speed value, so we return that
    return speed 
end)
-- #endregion using
-- #region constructor
dogClassBuilder:constructor(superUse, {java.int,  java.int}, nil, true)
function dogClassBuilder:init(speed, weight)
    self.weight = weight
end
-- #endregion constructor
-- #region override
dogClassBuilder:override("noise", {java.boolean, java.int}, {})

function dogClassBuilder:noise(chasing, packSize)
    if self:makesNoise() then
        -- We create isRunning() later, but can use it here!
        if self.weight >= 20 then
            return "*huff*, *huff*"
        elseif self:isRunning() or chasing then 
            return "*pant*, *pant*"
        else
            if packSize > 2 then
                return "*awoo!*"
            else
                return "*woof!* *woof!*"
            end
        end
    end
    return this.super:noise()
end
-- #endregion override
-- #region create
dogClassBuilder:method("isRunning", {}, java.boolean, {})

function dogClassBuilder:isRunning()
    return self.speed >= 5
end
-- #endregion create
-- #region build
local Dog = dogClassBuilder:build()
local inu = Dog(0, 10)
print(inu:noise()) -- prints "*woof!* *woof!*"
--#endregion build