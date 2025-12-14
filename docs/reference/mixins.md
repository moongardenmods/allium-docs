---
outline: [2, 3]
---

# Mixins

The following functions are provided to scripts via the `mixin` global.

::: danger 
Mixins are a very complicated topic that's very hard to grasp without a decent understanding of the JVM. If you would like to learn more about them, check out:
1. [Mixin's own wiki](https://github.com/SpongePowered/Mixin/wiki).
2. The [Mixin Cheatsheet](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/README.md).
3. [MixinExtras' Wiki](https://github.com/LlamaLad7/MixinExtras/wiki).
:::

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
4. `duck` - `boolean?`: Whether to make this mixin a duck interface.

::: warning
Unlike standard class building, class names are passed as strings. This is because:
1. mixins *must not* load the class they're mixing into, otherwise the application of the mixin will fail.
2. mixins are registered before the game properly launches (`mixin` Allium entrypoint, `preLaunch` Fabric entrypoint). In this pre-launch environment it is best practice to not load any game classes.
:::

#### Returns

- `userdata [instance]` - A mixin class builder.

#### Usage

See [Class Building - Mixin Class Builder](/reference/class-building#mixin-class-builder)

---

### `mixin.get(hookId)`

Get a reference to a mixin injection with the given `hookId`. This function can (and should) be used in `static` and `dynamic` script entrypoints. 

#### Parameters

1. `hookId` - `string`: The hook ID of the injector created in the `mixin` entrypoint.

#### Returns

- `userdata [instance]`: The injector's method hook. See [Method Hook](#method-hook)

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

    public void bat(boolean baz) {
        // ...
    }
}
```

and the following mixin to access the private field `foobar`:
```Lua [accessExampleMixin.lua]
local builder = mixin.to("com.example.Dummy")
builder:getAccessor({ value = "foobar" })
builder:build("accessible_foobar")
```

we use `mixin.quack()` to access the duck interface:
```Lua [main.lua]
local Dummy = require("com.example.Dummy")

local AccessExample = mixin.quack("accessibleFoobar")
local dummy = Dummy("asd")
local accessibleDummy = java.cast(dummy, AccessExample)
local foobar = accessibleDummy:getFoobar()
```

## Annotations

The following functions are provided on the `annotation` index of the `mixin` global.



Most of these functions represent injector annotations. Only one injector annotation can be provided per-method. The exceptions to this are `expression()` and `definition()`, which *can* be provided more than once per method.

::: tip
Clicking on the annotation names will take you to their javadoc.
:::

### Annotation Tables

All of these functions expect a table as the first parameter. This table gets recursively parsed and applied to the annotation interface that the function represents. The method names become keys, and the return values become the value. Arrays are a standard table with number indices. 

There is a special exception to the method name `value`, where if it's the only key-value pair being provided, the key name can be omitted. A common example of this is the mixin `@At` annotation. Both:
```Lua
{ value = "HEAD" }
```
and:
```Lua
{ "HEAD" }
```
are valid ways to define an `@At` annotation.

---

### `mixin.annotation.inject(annotation)`

Creates an [`@Inject`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/Inject.html) annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@Inject`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/Inject.html) annotation.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.modifyArg(annotation, targetType)`

Creates a [`@ModifyArg`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArg.html) annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@ModifyArg`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArg.html) annotation.
2. `targetType` - `string`: A type descriptor string of the argument being modified.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.modifyArgs(annotation)`

Creates a [`@ModifyArgs`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArgs.html) annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@ModifyArgs`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArgs.html) annotation.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.modifyExpressionValue(annotation, targetType)`

Creates a [`@ModifyExpressionValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyExpressionValue.html) annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@ModifyExpressionValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyExpressionValue.html) annotation.
2. `targetType` - `string`: A type descriptor string of the argument being modified.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.modifyReturnValue(annotation)`

Creates a [`@ModifyReturnValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyReturnValue.html) annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@ModifyReturnValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyReturnValue.html) annotation.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.wrapMethod(annotation)`

Creates a [`@WrapMethod`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/wrapmethod/WrapMethod.html) annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@WrapMethod`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/wrapmethod/WrapMethod.html) annotation.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.custom(annotation, annotationType, methodDescriptor, parameterTypes, returnType)`

Creates a custom injector annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the given `annotationType`.
2. `annotationType` - `userdata [class]`: The annotation class to be used.
3. `methodDescriptor` - `string`: The target method's descriptor string.
4. `parameterTypes` - `table<string>`: The parameters of the injector method. These may differ from the target method's descriptor.
5. `returnType` - `string`: The return type of the injector method. This may differ from the target method's dscriptor.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.expression(annotation)`

Creates an [`@Expression`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Expression.html) annotation. This method does not produce an injector annotation and may be used multiple times within an inject method.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@Expression`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Expression.html) annotation.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

### `mixin.annotation.definition(annotation)`

Creates a [`@Definition`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Definition.html) annotation. This method does not produce an injector annotation and may be used multiple times within an inject method.

#### Parameters

1. `annotation` - `table`: An [annotation table](#annotation-tables) that matches the [`@Definition`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Definition.html) annotation.

#### Returns

- `userdata [instance]`: A reference to the annotation for use in mixin method building.

---

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