---
outline: [2, 3]
---

# Class Building

There are two class builder types. One is for general purpose class building, like creating a new block type by extending from `Block`. The other is for creating mixins to change the behavior of existing classes, like modifying a method in `CactusBlock` to increase the maximum height cacti can grow to.

## Standard Class Builder

::: warning
The standard class builder is one of the most in-development aspects of Allium. Expect it to change dramatically over the course of the Beta.
:::

Given the following class:
```Java [Animal.java]
package com.example;

public class Animal {

    protected int speed;

    public Animal(int speed) {
        this.speed = speed;
    }

    protected boolean makesNoise() {
        return true;
    }

    public String noise(boolean chasing, int packSize) {
        return makesNoise() ? "*rustle, rustle*" : "*silence*";
    }
}
```

The following "usage" section of each method will build out a `Dog` class in Lua, starting with:
```Lua [Dog.lua] 
local Animal = require("com.example.Animal")

local dogClassBuilder = java.extendClass(Animal)
```

### `classBuilder:overrideMethod(methodName, parameters, access, func)`

Override an existing method of the parent class.

#### Parameters

1. `methodName` - `string`: The name of the method to override.
2. `parameters` - `table<userdata [class]>`: The parameters of the method to override.
3. `access` - `{ static = boolean? }`: Access flags for the overriding method. Set `static` if the method to override is static.
4. `func` - `function`: The function to call for handling when the method is invoked. If the overriding method is not static then the first parameter is `this`, followed by the rest of the parameters specified in `parameters`.

#### Usage

```Lua:line-numbers=4 [Dog.lua]
dogClassBuilder:overrideMethod("noise", {java.boolean, java.int}, {}, function(this, chasing, packSize)  -- [!code highlight]
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
end)  -- [!code highlight]
```

### `classBuilder:createMethod(methodName, parameters, returnClass, access, func)`

Create an entirely new method on the class.

#### Parameters

1. `methodName` - `string`: The method name. Must not exist in any parent classes.
2. `parameters` - `table<userdata [class]>`: A table representing the parameter types in order.
3. `returnClass` - `userdata [class]`: The class to be returned by this method.
4. `access` - `{ abstract = boolean?, static = boolean? }`: Access flags for overriding the method.
5. `func` - `function`: The function to call for handling when the method is invoked. If the parameter `access.abstract` is `true`, this parameter is ignored.

#### Usage

```Lua:line-numbers=14 [Dog.lua]
dogClassBuilder:createMethod("isRunning", {}, java.boolean, {}, function(this)  -- [!code highlight]
    return this.speed >= 5
end)  -- [!code highlight]
```

### `classBuilder:build()`

Builds the class.

#### Returns

- `userdata [class]`: The completed class. 

#### Usage

```Lua:line-numbers=17 [Dog.lua]
local Dog = dogClassBuilder:build() -- [!code highlight]
local inu = Dog(0)
print(inu:noise()) -- prints "*woof!* *woof!*"
```

## Mixin Class Builder

Obtained from [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck), builds out a class that gets applied as a mixin.

<!--@include: ./snippets/mixin-danger.md-->

Given the following class:
```Java [Car.class]
package com.example;

public class Car {
    private int speed;
    private int gas;
    private final int wheels;

    public Car(int speed) {
        this.speed = speed+5;
        this.wheels = 4;
        this.gas = 100;
    }

    private boolean isSpeeding() {
        return gas > 0 && speed > 10;
    }

    public int getRemainingGas() {
        return this.gas;
    }

    public String drive() {
        if (gas == 0) {
            return "*sputter*";
        } else if (wheels < 4) {
            gas--;
            return "putt putt putt";
        } else if (isSpeeding()) {
            gas-=5;
            return "VROOM!!!";
        } else {
            gas--;
            return "vroom!";
        }
    }
}
```

The following "usage" section of each method will modify this class in Lua, starting with:
```Lua [CarMixin.lua] 
local mixinBuilder = mixin.to("com.example.Car")
local mixinInterfaceBuilder = mixin.to("com.example.Car", nil, nil, true)
```
The sections will also use an arbitrary "entrypoint" script representing either the `static` or `dynamic` entrypoint:
```Lua [entrypoint.lua]
local Car = require("com.example.Car")

-- Same ID as used in mixinInterfaceBuilder:build()
local AccessibleCar = mixin.quack("accessible_car")
local sedan = java.cast(Car(0))
```



### `mixinBuilder:createInjectMethod(hookId, methodAnnotations, sugarParameters)`

Create an inject method. Can **not** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

#### Parameters

1. `hookId` - `string`: hook ID to later apply a hook onto this mixin with [`mixin.get()`](/reference/mixin-lib#mixin-get-hookid).
2. `methodAnnotations` - `table<userdata [instance]>`: Table of annotations to apply to the injector method. Requires exactly one injector annotation. See [Mixin Library - Annotations](/reference/mixin-lib#annotations).
3. `sugarParameters` - `table<userdata [instance]>`: Table of sugar parameters to apply after the last parameter of the injector method. See [Mixin Library - Sugars](/reference/mixin-lib#sugars).

#### Usage

Modify the constructor to negate the added 5 speed:
```Lua:line-numbers=3 [CarMixin.lua]
mixinBuilder:createInjectMethod("negate_init_speed", { -- [!code highlight]
    mixin.annotation.inject({ 
        method = { "<init>(I)V" },
        at = { "TAIL" }
    })
}) -- [!code highlight]
```
Then in either the `static` or `dynamic` script entrypoint:
```Lua:line-numbers=6 [entrypoint.lua]
mixin.get("negate_init_speed"):hook(function(this, speed)
    -- override the speed that was previously set.
    this.speed = speed
end)
```

::: tip
To inject into constructors, and static blocks, use `<init>()V` and `<clinit>()V` as target method names, respectively. Don't forget to fill in parameters!
:::

### `mixinInterfaceBuilder:accessor(annotations)`

Defines a setter and getter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

This is a convenience method that simply calls both `mixinInterfaceBuilder:getAccessor()` and `mixinInterfaceBuilder:setAccessor()` with the same `annotations` table.

For more information see [Mixin Cheatsheet - `@Accessor`](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/accessor.md).

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Usage

Add a setter and getter accessor for the speed:
```Lua:line-numbers=9 [CarMixin.lua]
mixinInterfaceBuilder:accessor({ "speed" })
```
Mess with it later on in the `static` or `dynamic` entrypoints:
```Lua:line-numbers=10 [entrypoint.lua]
sedan:setSpeed(10)
print(sedan:getSpeed())
```

### `mixinInterfaceBuilder:getAccessor(annotations)`

Defines a getter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target field name. It starts with `get`, then the first letter of the target field name is capitalized, and concatenated with the `get`. For example, given the target field `fooBar`, the method `getFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Usage

Add a getter accessor for the number of wheels:
```Lua:line-numbers=10 [CarMixin.lua]
mixinInterfaceBuilder:getAccessor({ "wheels" })
```
Mess with it later on in the `static` or `dynamic` entrypoints:
```Lua:line-numbers=12 [entrypoint.lua]
print("sedan has", sedan:getWheels(), "wheels")
```

### `mixinInterfaceBuilder:setAccessor(annotations)`

Defines a setter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target field name. It starts with `set`, then the first letter of the target field name is capitalized, and concatenated with the `set`. For example, given the target field `fooBar`, the method `setFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Usage

Add a setter accessor for gas:
```Lua:line-numbers=11 [CarMixin.lua]
mixinInterfaceBuilder:setAccessor({ "gas" })
```
Mess with it later on in the `static` or `dynamic` entrypoints:
```Lua:line-numbers=13 [entrypoint.lua]
sedan:setGas(150)
```

### `mixinInterfaceBuilder:invoker(annotations)`

Defines an invoker using the [`@Invoker`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Invoker.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target method name. It starts with `invoke`, then the first letter of the target method name is capitalized, and concatenated with the `invoke`. For example, given the target method `fooBar()`, the method `invokeFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Invoker`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Invoker.html) annotation.

#### Usage

Add an invoker for `isSpeeding()`:
```Lua:line-numbers=12 [CarMixin.lua]
mixinInterfaceBuilder:invoker({ "isSpeeding()Z" })
```
Mess with it later on in the `static` or `dynamic` entrypoints:
```Lua:line-numbers=14 [entrypoint.lua]
print("sedan speeding:", sedan:invokeIsSpeeding())
```

### `mixinBuilder:build(mixinId)`

Builds the mixin.

#### Parameters

1. `mixinId?` - `string`: A unique ID representing the mixin class. Used to obtain the duck interface for accessing fields and invoking methods. Only required if the mixin builder was created with `duck` set to `true`.

#### Usage

```Lua:line-numbers=13 [CarMixin.lua]
mixinBuilder:build()
mixinInterfaceBuilder:build("accessible_car")
```

### Complete Files

Putting all the snippets together, the two files combined are provided here.

```Lua [CarMixin.lua] 
local mixinBuilder = mixin.to("com.example.Car")
local mixinInterfaceBuilder = mixin.to("com.example.Car", nil, nil, true)
mixinBuilder:createInjectMethod("negate_init_speed", {
    mixin.annotation.inject({ 
        method = { "<init>(I)V" },
        at = { "TAIL" }
    })
})
mixinInterfaceBuilder:accessor({ "speed" })
mixinInterfaceBuilder:getAccessor({ "wheels" })
mixinInterfaceBuilder:setAccessor({ "gas" })
mixinInterfaceBuilder:invoker({ "isSpeeding()Z" })
mixinBuilder:build()
mixinInterfaceBuilder:build("accessible_car")
```

```Lua [entrypoint.lua]
local Car = require("com.example.Car")

-- Same ID as used in mixinInterfaceBuilder:build()
local AccessibleCar = mixin.quack("accessible_car")
local sedan = java.cast(Car(0))
mixin.get("negate_init_speed"):hook(function(this, speed)
    -- override the speed that was previously set.
    this.speed = speed
end)
sedan:setSpeed(10)
print(sedan:getSpeed())
print("sedan has", sedan:getWheels(), "wheels")
sedan:setGas(150)
print("sedan speeding:", sedan:invokeIsSpeeding())
```
