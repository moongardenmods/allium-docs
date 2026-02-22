---
outline: [2, 3]
---

# Mixin Library

The following functions are provided to scripts via the `mixin` global.

<!--@include: ./snippets/mixin-danger.md-->

::: warning
This page is under construction
:::

## Functions

### `mixin.to(targetClass, interfaces, targetEnvironment, duck)`

Mix into a specified class. 

#### Parameters

1. `targetClass` - `string`: The target class name, like what would be passed to `require()`.
2. `interfaces` - `table<string>?`: Optional interfaces to apply to the target class, using the `require()` format.
3. `targetEnvironment` - `string?`: The target environment, one of `"client"` or `"server"`. Leave `nil` to apply to common code.
4. `duck` - `boolean?`: Whether to make this mixin a duck interface builder.

::: warning
Unlike standard class building, class names are passed as strings. This is because:
1. mixins *must not* load the class they're mixing into, otherwise the application of the mixin will fail.
2. mixins are registered before the game properly launches (`mixin` Allium entrypoint, `preLaunch` Fabric entrypoint). In this pre-launch environment it is best practice to not load any game classes.
:::

#### Returns

- `userdata [instance]` - If `duck` is false, a [Mixin Class Builder](/reference/class-building#mixin-class-builder). If `duck` is true, a [Mixin Interface Builder](/reference/class-building#mixin-interface-builder).

#### Usage

See [Class Building - Mixin Class Builder](/reference/class-building#mixin-class-builder) & [Class Building - Mixin Interface Builder](/reference/class-building#mixin-interface-builder).

---

### `mixin.get(mixinId)`

Get a reference to a mixin class with the given `mixinId`. This function can (and should) be used in the `main` script entrypoint. 

#### Parameters

1. `mixinId` - `string`: The mixin ID of the class created in the `mixin` entrypoint.

#### Returns

- `userdata [instance]`: A hook definition for the class. See [Hook Definition](#hook-definition)

#### Usage

Assuming there exists an injection with the ID `"increase_cactus_height"`:
```Lua
local methodHook = mixin.get("increase_cactus_height")
```

---

### `mixin.quack(mixinId)`

Provides the duck interface associated to a given ID. Used to access the accessors and invokers on objects belonging to the duck interface's target class.

#### Parameters

1. `mixinId` - `string`: The ID of a duck interface mixin.

#### Returns

- `userdata [class]`: The mixin interface.

#### Usage

Provided the class:
```Java [Dummy.java]
package com.example;

import java.lang.String;

public class Dummy {
    private final String foobar;

    public Dummy(String foobar) {
        this.foobar = foobar + (int)(Math.random()*100);
    }

    private void bat(boolean baz) {
        // ...
    }
}
```

and the following mixin to access the private field `foobar`:
```Lua [accessExampleMixin.lua]
local builder = mixin.to("com.example.Dummy")
builder:getAccessor({ "foobar" })
builder:invoker({ "bat(Z)V" })
builder:build("foobar_interface")
```

we use `mixin.quack()` to access the duck interface:
```Lua [main.lua]
local Dummy = require("com.example.Dummy")

local AccessExample = mixin.quack("foobar_interface")
local dummy = Dummy("asd")
local accessibleDummy = java.cast(dummy, AccessExample)
local foobar = accessibleDummy:getFoobar()
accessibleDummy:invokeBat(false)
```

## Hook Definition

Because of the restrictions of the `mixin` entrypoint, the Lua functions that are to be put into the injectors on a mixin class have to be hooked in from the `main` entrypoint. The hook definition is how this is done. It has a single function:

### `hookDefinition:define(definition, destroyOnUnload)`

Hooks the given methods into the injectors with matching indexes on the represented mixin class.

#### Parameters

1. `definition` - `table<function>`: A table with methods whose names match the indexes provided when creating the method builder. Parameters passed into these functions depend on the injector. If the injection does not target a static method, the first parameter passed to the function is `this`, followed by the remaining parameters specified by the injection annotation and sugar parameter annotations.
2. `destroyOnUnload` - `boolean?`: Whether or not to remove the hook definition from the mixin class on unload (or reload.)

::: tip
It can be hard to visualize where a mixin should be made and what parameters it will provide. Scaffolding out the mixin in java first, where linting and auto-fill can help guide to the correct results, is a good idea. 
:::

::: info HELP WANTED
It would be nice to be able to auto-fill in the parameters using the mixin annotation information right in the Lua file itself. If you have extension development experience in any IDE, and have an interest in contributing to an IDE extension for Allium, join the Discord linked in the top right!
:::

#### Usage

TODO: A better example

```Lua
local definition = {}

function definition:anInjectorMethod()
    print(self:meaningOfLife())
end


methodHook:define(definition)
```