-- #region init
local Animal = require("com.example.Animal")

local dogClassBuilder = java.extendClass(Animal)
-- #endregion init
-- #region override
dogClassBuilder:override("noise", {java.boolean, java.int}, {})

function dogClassBuilder:noise(this, chasing, packSize)
    if this:makesNoise() then
        -- We create isRunning() later, but can use it here!
        if this:isRunning() or chasing then 
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

function dogClassBuilder:isRunning(this)
    return this.speed >= 5
end
-- #endregion create
-- #region build
local Dog = dogClassBuilder:build()
local inu = Dog(0)
print(inu:noise()) -- prints "*woof!* *woof!*"
--#endregion build