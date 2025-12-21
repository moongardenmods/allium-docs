# Java Library

The following functions are provided to scripts via the `java` global.

## `java.cast(object, class)`

Casts a Java object `object` to `class`.

### Parameters

1. `object` - `userdata [instance]`: An object instance.
2. `class` - `userdata [class]`: A class that the object instance is cast to.

### Returns

- `userdata [instance]`: The casted object.

### Usage

See [Fundamentals - Casting](/reference/fundamentals#casting)

## `java.coerce(tableLike, class)`

Coerces `tableLike` to a table.

### Parameters

1. `tableLike` - `userdata [instance]`: A table-like object instance (one of `Map`, `List`, or `Set`).
2. `class` - `userdata [class]`: A class representing both the type of `tableLike`, and the types of the elements within `tableLike`.

### Returns

- `table`: A table from the values contained within `tableLike`.

### Usage

Given the Java class:

<<< @/reference/snippets/code/CoerceExample.java

The usage for each type would be:

<<< @/reference/snippets/code/coerceExample.lua{8-10 Lua}

## `java.wrap(value, class)`

Wraps a Lua value in a provided class. Seldom useful due to type conversion being automatically handled by Allium.

### Parameters

1. `value` - `boolean | number | string | userdata [instance]`: Lua value (or Java object) to be wrapped. 
2. `class` - `userdata [class]`: Class for value to be wrapped in.

### Returns

`userdata [instance]` - Wrapped value of type provided by `class`.

### Usage

```Lua
local Double = require("java.lang.Double")

local wrappedPi = java.wrap(3.14159265, Double) -- [!code highlight]
```

## `java.instanceOf(object, class)`

Check whether the given object is of the given class.

### Parameters

1. `object` - `userdata [instance]`: The object instance to test.
2. `class` - `userdata [class]`: The class that the object instance is tested against.

### Returns

- `boolean`: Whether or not `object` is of type `class`

### Usage

```Lua
local Blocks = require("net.minecraft.world.level.block.Blocks")
local VegetationBlock = require("net.minecraft.world.level.block.VegetationBlock")

local result
if java.instanceOf(Blocks.ALLIUM, VegetationBlock) then -- [!code highlight]
    result = "is"
else
    result = "is not"
end
print("Allium", result, "a VegetationBlock.")
```
::: info
In Minecraft's code, `Blocks.ALLIUM` is of type `FlowerBlock`, which inherits from `VegetationBlock`. Therefore in this example, `java.instanceOf` should return `true`.
:::

## `java.callWith(function, paramTypes, params...)`

Invokes a java method (either static or instance) with the given `paramTypes`, using the given lua `params...`. Useful for when generic types abstract away the type, confusing Allium's automatic method resolution.

::: tip
If you get an error that Allium can't find a method that is present, and one of the parameters types is `T` (or some other letter, generally); use this function.
:::

### Parameters

1. `function` - `function`: The method to be called.
2. `paramTypes` - `table<userdata [class]>`: The list of classes representing each parameter.
3. `params...` - `any`: A variable amount of parameters to be passed to the method. If this method is an instance method, supply the instance that the method should be called on. Supplying the type of the instance in `paramTypes` is not necessary.

### Returns

- `any...`: Technically a variable number of arguments, but is generally just the single return value of the `function` being called.

### Usage

Parses a table, converting it into a text component. Example derived from [Bouquet API - component.lua](https://github.com/moongardenmods/allium/blob/main/bouquet/src/main/resources/bouquet/api/component.lua).

```Lua
local ComponentSerialization = require("net.minecraft.network.chat.ComponentSerialization")
local LuaOps = require("dev.hugeblank.bouquet.util.LuaOps")
local LuaValue = require("org.squiddev.cobalt.LuaValue")

local data = {
    text = "Hello world!",
    color = "green",
    hover_event = { action = "show_text", value = "Secret message!" }
}

local dataResult = java.callWith(ComponentSerialization.CODEC.parse, {LuaOps, LuaValue}, ComponentSerialization.CODEC, LuaOps(script:getState()), data) -- [!code highlight]
if result:isError() and dataResult:error():isPresent() then
    error(dataResult:error():get():message())
elseif dataResult:isError() then
    error("An unknown error occurred during parsing.")
end
local component = dataResult:getOrThrow() -- This would be sent in a command response, or something similar.
```

## `java.getRawClass(className)`

Gets a raw class or interface representation as an `EClass` (enhanced representation of the standard `Class` type). Seldom useful due to Allium's automatic conversion of `userdata [class]` to `EClass` and `Class` types where necessary.

### Parameters

1. `className` - `string`: The class name, as it would be provided to `require()`.

### Returns

- `userdata [instance]`: an `EClass` instance representing the class matching `className`.

### Usage

```Lua
local eClass = java.getRawClass("net.minecraft.world.level.block.Blocks") -- [!code highlight]
eClass:fields():forEach(function(field)
    print(field:name())
end)
```


## `java.throw(exception)`

Throw an exception in Java.

### Parameters

1. `exception` - `userdata [instance]`: The exception instance to be thrown.

### Usage

See [Throwing Exceptions](/reference/fundamentals#throwing-exceptions)

## `java.extendClass(superclass, interfaces, access)`

Provides a class builder extending from the given `superclass`. Optionally applies `interfaces`, and is created with the given `access`.

### Parameters

1. `superclass` - `userdata [class]`: The parent class of the class being built.
2. `interfaces` - `table<userdata [class]>?`: An optional table of interfaces to be applied to the class.
3. `access` - `{ static = boolean?, interface = boolean?, abstract = boolean? }?`: An optional table of flags to define properties of the class.

### Returns

- `userdata [instance]`: A class builder.

### Usage
See [Class Building - Standard Class Builder](/reference/class-building#standard-class-builder).

## Primitives

The `java` global also provides all of the primitives as `userdata [class]` for use in class building.

They are:
- `java.boolean`
- `java.byte`
- `java.short`
- `java.int`
- `java.long`
- `java.float`
- `java.double`
- `java.char`