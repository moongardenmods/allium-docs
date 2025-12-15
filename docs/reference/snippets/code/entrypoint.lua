-- #region init
local Car = require("com.example.Car")

-- Same ID as used in mixinInterfaceBuilder:build()
local AccessibleCar = mixin.quack("accessible_car")
local sedan = java.cast(Car(0))
-- #endregion init
-- #region create
mixin.get("negate_init_speed"):hook(function(this, speed)
    -- override the speed that was previously set.
    this.speed = speed
end)
-- #endregion create
-- #region accessor
sedan:setSpeed(10)
print(sedan:getSpeed())
-- #endregion accessor
-- #region getaccessor
print("sedan has", sedan:getWheels(), "wheels")
-- #endregion getaccessor
-- #region setaccessor
sedan:setGas(150)
-- #endregion setaccessor
-- #region invoker
print("sedan speeding:", sedan:invokeIsSpeeding())
-- #endregion invoker