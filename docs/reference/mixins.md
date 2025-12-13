---
outline: [2, 3]
---

# Mixins

The following functions are provided to scripts via the `mixin` global.

::: warning
This page is under construction
:::

## Functions

### `mixin.to(targetClass, interfaces, targetEnvironment, duck)`

Mix into a specified class. 

::: info
Mixins are a very complicated topic that's very hard to understand without a decent understanding of Java. If you would like to learn more about them, check out [Mixin's own wiki](https://github.com/SpongePowered/Mixin/wiki).
:::

#### Parameters

1. `targetClass` - `string`: The target class name, like what would be passed to `require()`.
2. `interfaces` - `table<string>?`: Optional interfaces to apply to the target class, using the `require()` format.
3. `targetEnvironment` - `string?`: The target environment, one of `"client"` or `"server"`. Leave `nil` to apply to common code.
4. `duck` - `boolean?`: Whether to make this mixin a duck interface.

::: info
Unlike standard class building, class names are passed as strings. This is because:
1. mixins *must not* load the class they're mixing into, otherwise the application of the mixin will fail.
2. mixins are registered before the game properly launches (`mixin` Allium entrypoint, `preLaunch` Fabric entrypoint). In this pre-launch environment it is best practice to not load any game classes.
:::

#### Returns

- `userdata [instance]` - A mixin class builder.

#### Usage

See [Class Building - Mixin Class Builder](/reference/class-building#mixin-class-builder)

### `mixin.get(eventId)`

Get a reference to a mixin injection with the given `eventId`. This function can (and should) be used in `static` and `dynamic` script entrypoints. 

#### Parameters

1. `eventId` - `string`: The event ID of the injector created in the `mixin` entrypoint.

#### Returns

- `userdata [instance]`: The injector's method hook. See [Method Hook](#method-hook)

#### Usage

Assuming there exists an injection with the ID `"increase_cactus_height"`:
```Lua
methodHook = mixin.get("increase_cactus_height")
```

### `mixin.quack(mixinId)`

Provides the duck interface associated to a given ID. Used to access the accessors and invokers on objects belonging to the duck interface's target class.

#### Parameters

1. `mixinId` - `string`: The ID of a duck interface mixin.

#### Returns

- `userdata [class]`: The mixin interface.

#### Usage

TODO: Actually produce the class, and example mixin here

Assuming a mixin has been applied to class `Dummy`, an accessor was created for field `foobar`, and then was built with the ID `"accessible_targetclass"`:
```Lua
Dummy = require("com.example.Dummy")

AccessExample = mixin.quack("accessible_targetclass")
dummy = Dummy("asd")
accessibleDummy = java.cast(dummy, AccessExample)
foobar = accessibleDummy:getFoobar()
```

## Annotations

## Sugars

## Method Hook

Because of the restrictions of the `mixin` entrypoint, the Lua function that is to be put into the injector has to be hooked in from the `static` or `dynamic` entrypoints. The method hook is how this is done. It has a single function:

### `methodHook:hook(func)`

Hooks the given function into the given mixin injection.

#### Parameters

1. `func` - `function`: The function to be run when the injector gets invoked. Parameters passed into this function depend on the injector. If the injection does not target a static method, the first parameter passed to the function is `this`, followed by the remaining parameters specified by the injection annotation.

::: tip
It can be hard to visualize where a mixin should be made and what parameters it will provide. Scaffolding out the mixin in java first, where linting and auto-fill can help guide to the correct results, is a good idea. 
:::

::: info HELP WANTED
It would be nice to be able to auto-fill in the parameters using the mixin annotation information right in the Lua file itself. If you have extension development experience in any IDE, and have an interest in contributing to an IDE extension for Allium, join the Discord linked in the top right!
:::

#### Usage

TODO: A better example

```Lua
methodHook:hook(function(this, ...)

end)
```