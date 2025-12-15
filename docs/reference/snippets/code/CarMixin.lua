-- #region init
local mixinBuilder = mixin.to("com.example.Car")
local mixinInterfaceBuilder = mixin.to("com.example.Car", nil, nil, true)
-- #endregion init
-- #region create
mixinBuilder:createInjectMethod("negate_init_speed", {
    mixin.annotation.inject({ 
        method = { "<init>(I)V" },
        at = { "TAIL" }
    })
})
-- #endregion create
-- #region accessor
mixinInterfaceBuilder:accessor({ "speed" })
-- #endregion accessor
-- #region getaccessor
mixinInterfaceBuilder:getAccessor({ "wheels" })
-- #endregion getaccessor
-- #region setaccessor
mixinInterfaceBuilder:setAccessor({ "gas" })
-- #endregion setaccessor
-- #region invoker
mixinInterfaceBuilder:invoker({ "isSpeeding()Z" })
-- #endregion invoker
-- #region build
mixinBuilder:build()
mixinInterfaceBuilder:build("accessible_car")
-- #endregion build