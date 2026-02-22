-- #region definition
local definition = {}

function definition:negateInitSpeed(speed)
    -- override the speed that was previously set.
    self.speed = speed
end

-- Same ID as used in mixinClassBuilder:build()
mixin.get("car_mixin"):define(definition)

-- Require AFTER defining hooks.
-- #region duck
local Car = require("com.example.Car")
-- #endregion definition

-- Same ID as used in mixinInterfaceBuilder:build()
local AccessibleCar = mixin.quack("accessible_car")
local sedan = java.cast(Car(0), AccessibleCar)
sedan:setSpeed(10)
print(sedan:getSpeed())
print("sedan has", sedan:getWheels(), "wheels")
sedan:setGas(150)
print("sedan speeding:", sedan:invokeIsSpeeding())
-- #endregion duck