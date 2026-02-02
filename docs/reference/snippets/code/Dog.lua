-- #region init
local Animal = require("com.example.Animal")

local dogClassBuilder = java.extendClass(Animal)
-- #endregion init
-- #region field
local setField = {}
dogClassBuilder:field("weight", java.int, { final = true }, function(this) 
    local weight = setField[this]
    setField[this] = nil
    return weight
end)
-- #endregion field
-- #region constructor
dogClassBuilder:constructor({java.int, java.int}, nil, true)
function dogClassBuilder:constructor(self, speed, weight)
    self:super(speed)
    setField[self] = weight
end
-- #endregion constructor
-- #region override
dogClassBuilder:override("noise", {java.boolean, java.int}, {})

function dogClassBuilder:noise(this, chasing, packSize)
    if this:makesNoise() then
        -- We create isRunning() later, but can use it here!
        if this.weight >= 20 then
            return "*huff*, *huff*"
        elseif this:isRunning() or chasing then 
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
local inu = Dog(0, 10)
print(inu:noise()) -- prints "*woof!* *woof!*"
--#endregion build