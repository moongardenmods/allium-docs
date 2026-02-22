-- #region class
mixin.to("com.example.Car")
    :method("negateInitSpeed")
        :inject({ 
            method = { "<init>(I)V" },
            at = { "TAIL" }
        })
        :build()
:build("car_mixin")
-- #endregion class
-- #region interface
mixin.to("com.example.Car", nil, nil, true)
    :accessor({ "speed" })
    :getAccessor({ "wheels" })
    :setAccessor({ "gas" })
    :invoker({ "isSpeeding()Z" })
    :build("accessible_car")
-- #endregion interface