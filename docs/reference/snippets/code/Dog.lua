local Animal = require("com.example.Animal")

--#region definitionDef
local dogDefinition = {}
--#endregion definitionDef

--#region clinitDef
function dogDefinition:clinit(class)
    -- set static fields here
end
--#endregion clinitDef

--#region constructorDef
function dogDefinition:constructor(speed, weight)
    self.weight = weight
end
--#endregion constructorDef

--#region methodDef
function dogDefinition:noise(chasing, packSize)
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

function dogDefinition:isRunning()
    return self.speed >= 5
end
--#endregion methodDef

local Dog = java.extendClass(Animal)
--#region field
    :field("weight", java.int, { final = true, private = true })
--#endregion field
--#region clinit
    :clinit(class)
        :index("clinit")
        :build()
--#endregion clinit
--#region constructor
    :constructor()
        :super({java.int})
        :remapper(function(speed, weight)
            -- super constructor uses the speed value, so we return that
            return speed 
        end)
        :access({ public = true })
        :parameters({java.int, java.int})
        :definesFields()
        :build()
--#endregion constructor
--#region method
    :method()
        :override("noise", {java.boolean, java.int})
        :access({ public = true })
        :build()
    :method()
        :name("isRunning")
        :access({ public = true })
        :parameters({})
        :returnType(java.boolean)
        :build()
--#endregion method
--#region definition
    :define(dogDefinition)
--#endregion definition
--#region build
    :build()
--#endregion build

local inu = Dog(0, 10)
print(inu:noise()) -- prints "*woof!* *woof!*"
