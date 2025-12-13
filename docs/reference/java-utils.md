# Java Utilities

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

Coerces `tableLike`, to a table.

### Parameters

1. `tableLike` - `userdata [instance]`: A table-like object instance (one of `Map`, `List`, or `Set`).
2. `class` - `userdata [class]`: A class representing the type of both the type of `tableLike`, and the types of the elements within `tableLike`.

### Returns

- `table`: A table from the values contained within `tableLike`.

### Usage

Given the Java class:
```Java [CoerceExample.java]
package com.example;

import java.util.List;
import java.util.Set;
import java.util.Map;
import java.util.HashMap;
import java.lang.Integer;
import java.lang.String;

public class CoerceExample {
    
    public static List<Integer> getList() {
        return List.of(3, 1, 4, 1, 5, 9);
    }

    public static Set<Integer> getSet() {
        return Set.of(3, 1, 4, 5, 9);
    }

    public static Map<String, Integer> getMap() {
        Map<String, Integer> map = new HashMap<>();
        map.put("hello", 5);
        map.put("world!", 6);
        return map;
    }
}
```

```Lua [coerceExample.lua]
List = require("java.util.List")
Set = require("java.util.Set")
Map = require("java.util.Map")
Integer = require("java.lang.Integer")
String = require("java.lang.String")
CoerceExample = require("com.example.CoerceExample")

list = java.coerce(CoerceExample.getList(), List[{Integer}])
set = java.coerce(CoerceExample.getSet(), Set[{Integer}])
map = java.coerce(CoerceExample.getMap(), Map[{String, Integer}])
```

## `java.wrap(value, class)`

Wraps a Lua value in a provided class. Seldom useful due to type conversion being automatically handled by Allium.

### Parameters

1. `value` - `boolean | number | string | userdata [instance]`: Lua value (or Java object) to be wrapped. 
2. `class` - `userdata [class]`: Class for value to be wrapped in.

### Returns

`userdata [instance]` - Wrapped value of type provided by `class`.

### Usage

```Lua
Double = require("java.lang.Double")

wrappedPi = java.wrap(3.14159265, Double)
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
Blocks = require("net.minecraft.world.level.block.Blocks")
VegetationBlock = require("net.minecraft.world.level.block.VegetationBlock")

local result
if java.instanceOf(Blocks.ALLIUM, VegetationBlock) then
    result = "is"
else
    result = "is not"
end
print("Allium", result, "a VegetationBlock.")
```
::: info
In Minecraft's code, `Blocks.ALLIUM` is of type `FlowerBlock`, which inherits from `VegetationBlock`. Therefore in this example, `java.instanceOf` should return `true`.
:::

## `java.getRawClass(className)`

Gets a raw class or interface representation as an `EClass` (enhanced representation of the standard `Class` type). Seldom useful due to Allium's automatic conversion of `userdata [class]` to `EClass` and `Class` types where necessary.

### Parameters

1. `className` - `string`: The class name, as it would be provided to `require()`.

### Returns

- `userdata [instance]`: an `EClass` instance representing the class matching `className`.

### Usage



## `java.throw(exception)`

Throw an exception in Java.

### Parameters

1. `exception` - `userdata [instance]`: The exception instance to be thrown.

### Returns

- `nil`

### Usage

See [Throwing Exceptions](/reference/fundamentals#throwing-exceptions)

## `java.extendClass(superclass, interfaces, access)`

Provides a class builder extending from the given `superclass`. Optionally applies `interfaces`, and is created with the given `access`.

### Parameters

1. `superclass` - `userdata [class]`: The parent class of the class being built.
2. `interfaces` - `table<userdata [class]>?`: An optional table of interfaces to be applied to the class.
3. `access` - `{ static = boolean?, interface = boolean?, abstract = boolean? }`: An optional table of flags to define properties of the class.

### Returns

- `userdata [instance]`: A class builder.

### Usage
See [Class Building](/reference/class-building).