---
outline: [2, 3]
---

# Class Building

There are two class builder types. One is for general purpose class building, like creating a new block type by extending from `Block`. The other is for creating mixins to change the behavior of existing classes, like modifying a method in `CactusBlock` to increase the maximum height cacti can grow to.

::: warning
This page is under construction
:::

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

The following usages of each method will build out a `Dog` class in Lua, starting with:
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