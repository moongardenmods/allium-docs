---
outline: deep
---

# Fundamentals

The following is a list of Java conventions, and how they map to Lua. 

## Imports

### Basic Case
::: code-group
```Lua
local BlockState = require("net.minecraft.world.level.block.state.BlockState")
```
```Java
import net.minecraft.world.level.block.state.BlockState;
```
:::
::: tip
You are not beholden to Java's whims. The variable that the imported class is stored in can be named whatever you like. 

However, it's good practice to keep naming consistent between Lua and Java to avoid confusion. All Lua code on this wiki follows this standard.
:::

### Nested Class

In Lua, the last `.` between the outer and inner class becomes a `$`.

::: code-group
```Lua
local OffsetType = require(
    "net.minecraft.world.level.block.state.BlockBehaviour$OffsetType"
)
```
```Java
import net.minecraft.world.level.block.state.BlockBehaviour.OffsetType;
```
:::

## Object Construction

::: code-group
```Lua
local ExampleObject = require("com.example.ExampleObject")

local example = ExampleObject(1, 2, 3) -- [!code highlight]
```
```Java
import com.example.ExampleObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3); // [!code highlight]
```
:::

## Static Methods & Fields

::: code-group
```Lua
local ExampleObject = require("com.example.ExampleObject")

local value = ExampleObject.FIELD -- [!code highlight]
ExampleObject.testMethod("hello!") -- [!code highlight]
```
```Java
import com.example.ExampleObject;
// ...
int value = ExampleObject.FIELD; // [!code highlight]
ExampleObject.testMethod("hello!"); // [!code highlight]
```
:::

## Instance Methods & Fields

In Lua, the `.` changes to a `:` for instance method invocation.

::: code-group
```Lua
local ExampleObject = require("com.example.ExampleObject")

local example = ExampleObject(1, 2, 3)
local value = example.field -- [!code highlight]
local example:updateField(value+1) -- [!code highlight]
```
```Java
import com.example.ExampleObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
double value = example.field; // [!code highlight]
example.updateField(value+1); // [!code highlight]
```
:::

## Casting

See [Java Library - `java.cast()`](/reference/java-lib#java-cast-object-class)

::: code-group
```Lua
local ExampleObject = require("com.example.ExampleObject")
local CastedObject = require("com.example.CastedObject")

local example = ExampleObject(1, 2, 3)
local castedObject = java.cast(example, CastedObject) -- [!code highlight]
```
```Java
import com.example.ExampleObject;
import com.example.CastedObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
CastedObject castedObject = (CastedObject) example; // [!code highlight]
```
:::

## Type Conversions

Given a class like:

<<< @/reference/snippets/code/FooBar.java

Primitive types (and their respective wrapper types) are seamlessly converted:
::: code-group
```Lua
local FooBar = require("com.example.FooBar")

local foobar = FooBar(10, 7000000000)
foobar:addPrecise(0.1, 0.0001)
local fineList = foobar:getFineList()
local veryFineList = foobar:getVeryFineList()
local old = foobar:changeInteger(fineList:size())
local bigold = foobar:changeBigInteger(fineList:size()+veryFineList:size())
local longString = foobar:isLongString("Hello World!")
local notLongString = foobar:invert(longString)
```
```Java
import com.example.FooBar;
// ...
FooBar foobar = new FooBar(10, 7000000000);
foobar.addPrecise(0.1f, 0.0001d);
List<Float> fineList = foobar.getFineList();
List<Double> veryFineList = foobar.getVeryFineList();
int old = foobar.changeInteger(fineList.size());
long bigold = foobar.changeBigInteger(fineList.size()+veryFineList.size());
boolean longString = foobar.isLongString("Hello World!");
boolean notLongString = foobar.invert(longString);
```
:::

Types are converted as follows:
|  Lua Type  |                                              Java Type                                               | Notes                                                                                                                                                                              |
| :--------: | :--------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   `nil`    |                                        `null`, `void`, `Void`                                        | Can only be used as `void` or `Void` when describing a method to create or override during class building.                                                                         |
|  `number`  | `byte`, `short`, `int`, `long`, `float`, `double`, `Byte`, `Short`, `Int`, `Long`, `Float`, `Double` | If a number greater than the max size of the Java type is provided, it overflows, wrapping around. (ex. if passing 256 where a byte is expected, the resulting byte will be 0)     |
| `boolean`  |                                         `boolean`, `Boolean`                                         |                                                                                                                                                                                    |
|  `string`  |                                               `String`                                               |                                                                                                                                                                                    |
| `function` |                                              *instance*                                              | When going from Lua to Java, converted to an instance of a functional interface (java interface with only one method), where applicable. see [Callback Methods](#callback-methods) |
|  `table`   |                                         `List`, `Set`, `Map`                                         | When going from Java to Lua, converted only if the java method's return value is annotated with `@CoerceToNative`. When going from Lua to Java, converted unconditionally.         |
| `userdata` |                                    *instance*, `Class`, `EClass`                                     | Java classes and objects are wrapped as userdata. Additionally, where a `Class` or `EClass` are expected, a userdata passed directly from `require` can be used.                   |

::: info
In these docs, a userdata that wraps a class is represented as `userdata [class]`, while a userdata that wraps an object is represented as `userdata [instance]`. On a `userdata [class]` static methods and fields are accessible, while on a `userdata [instance]` instance methods and fields are accessible.
:::

## Throwing exceptions

See [Java Library - `java.throw()`](/reference/java-lib#java-throw-exception)

::: code-group
```Lua
local IllegalStateException = require("java.lang.IllegalStateException")

java.throw(IllegalStateException("Oh no!")) -- [!code highlight]
```
```Java
import java.lang.IllegalStateException;
// ...
throw new IllegalStateException("Oh no!"); // [!code highlight]
```
:::

## Functional Interfaces

::: code-group
```Lua
local ExampleObject = require("com.example.ExampleObject")

local example = ExampleObject(1, 2, 3)
local message = "Hello World!"
local numbers = example:getList()
numbers:forEach(function(otherObj) -- [!code highlight]
    otherObj:sendMessage(message) -- [!code highlight]
    otherObj:flush() -- [!code highlight]
end) -- [!code highlight]
```
```Java
import com.example.ExampleObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
String message = "Hello World!";
List<SomeOtherObject> numbers = example.getList();
numbers.forEach((otherObj) -> { // [!code highlight]
    otherObj.sendMessage(message); // [!code highlight]
    otherObj.flush(); // [!code highlight]
}); // [!code highlight]
```
:::
::: tip
If the type is in the package `java.util.function` you can be confident it's a functional interface of some kind.
:::

## Generic Types

A generic class can be indexed with a table of classes before construction. This applies a lower boundary of possible types that the generic class can contain.

::: code-group
```Lua
local ArrayList = require("java.util.ArrayList")
local Integer = require("java.lang.Integer")

local intList = ArrayList[{Integer}]() -- [!code highlight]
intList:addAll(3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 9)
```
```Java
import java.util.List;
import java.util.ArrayList;
import java.lang.Integer;
// ...
List<Integer> intList = new ArrayList<>(); // [!code highlight]
intList.addAll(3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 9);
// ...
```
:::