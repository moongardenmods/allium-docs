---
outline: deep
---

# Fundamentals

## Direct Conventions

The following is a list of Java conventions, and how they map to Lua. 

::: info
In these examples `local` has been omitted from the Lua side for readability. This reference is not intended to be an example of good Lua hygiene.
:::

### Imports

#### Basic Case
::: code-group
```Java
import net.minecraft.world.level.block.state.BlockState;
```
```Lua
BlockState = require("net.minecraft.world.level.block.state.BlockState")
```
:::
::: tip
You are not beholden to Java's whims. The variable that the imported class is stored in can be named whatever you like. 

However, it's good practice to keep naming consistent between Lua and Java to avoid confusion. All Lua code on this wiki follows this standard.
:::

#### Nested Class

In Lua, the last `.` between the outer and inner class becomes a `$`.

::: code-group
```Java
import net.minecraft.world.level.block.state.BlockBehaviour.OffsetType;
```
```Lua
OffsetType = require(
    "net.minecraft.world.level.block.state.BlockBehaviour$OffsetType"
)
```
:::

### Object Construction

::: code-group
```Java
import com.example.ExampleObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
```
```Lua
ExampleObject = require("com.example.ExampleObject")

example = ExampleObject(1, 2, 3)
```
:::

### Static Methods & Fields

::: code-group
```Java
import com.example.ExampleObject;
// ...
int value = ExampleObject.FIELD;
ExampleObject.testMethod("hello!");
```
```Lua
ExampleObject = require("com.example.ExampleObject")

value = ExampleObject.FIELD
ExampleObject.testMethod("hello!")
```
:::

### Instance Methods & Fields

In Lua, the `.` changes to a `:` for instance method invocation.

::: code-group
```Java
import com.example.ExampleObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
double value = example.field;
example.updateField(value+1);
```
```Lua
ExampleObject = require("com.example.ExampleObject")

example = ExampleObject(1, 2, 3)
value = example.field
example:updateField(value+1) 
```
:::

### Casting

See [Java Utilities - `java.cast()`](/reference/java-utils#java-cast-object-class)

::: code-group
```Java
import com.example.ExampleObject;
import com.example.CastedObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
CastedObject castedObject = (CastedObject) example;
```
```Lua
ExampleObject = require("com.example.ExampleObject")
CastedObject = require("com.example.CastedObject")

example = ExampleObject(1, 2, 3)
castedObject = java.cast(example, CastedObject)
```
:::

### Type Conversions

Given a class like:
```java [FooBar.java]
package com.example;

// import ...

public class FooBar {
    private int integer;
    private long biginteger;
    private final List<Float> fineList = new ArrayList<>();
    private final List<Double> veryFineList = new ArrayList<>();

    public FooBar(int integer, long biginteger) {
        this.integer = integer;
        this.biginteger = biginteger;
    }

    public void addPrecise(float preciseNumber, double veryPreciseNumber) {
        fineList.add(preciseNumber);
        veryFineList.add(veryPreciseNumber);
    }

    public List<Float> getFineList() {
        return this.fineList;
    }

    public List<Double> getVeryFineList() {
        return this.veryFineList;
    }

    public Integer changeInteger(Integer newInteger) {
        Integer oldInteger = Integer.valueOf(this.integer);
        this.integer = newInteger;
        return oldInteger;
    }

    public Long changeBigInteger(Long newBigInteger) {
        Long oldBigInteger = Long.valueOf(this.biginteger);
        this.biginteger = newBigInteger;
        return oldBigInteger;
    }

    public boolean isLongString(String text) {
        return text.length() > 10;
    }

    public Boolean invert(Boolean value) {
        return Boolean.valueOf(!value);
    }
}
```
Primitive types (and their respective wrapper types) are seamlessly converted:
::: code-group
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
```Lua
FooBar = require("com.example.FooBar")

foobar = FooBar(10, 7000000000)
foobar:addPrecise(0.1, 0.0001)
fineList = foobar:getFineList()
veryFineList = foobar:getVeryFineList()
old = foobar:changeInteger(fineList:size())
bigold = foobar:changeBigInteger(fineList:size()+veryFineList:size())
longString = foobar:isLongString("Hello World!")
notLongString = foobar:invert(longString)
```
:::

Types are converted as follows:
|  Lua Type  |                                              Java Type                                               | Notes                                                                                                                                                                                    |
| :--------: | :--------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   `nil`    |                                        `null`, `void`, `Void`                                        | Can only be used as `void` or `Void` when describing a method to create or override during class building.                                                                               |
|  `number`  | `byte`, `short`, `int`, `long`, `float`, `double`, `Byte`, `Short`, `Int`, `Long`, `Float`, `Double` | If a number greater than the max size of the Java type is provided, it will simply overflow and wrap around. (ex. if passing 256 where a byte is expected, the resulting byte will be 0) |
| `boolean`  |                                         `boolean`, `Boolean`                                         |                                                                                                                                                                                          |
|  `string`  |                                               `String`                                               |                                                                                                                                                                                          |
| `function` |                                                  *                                                   | When going from Lua to Java, converted to a functional interface (java interface with only one method), where applicable. see [Callback Methods](#callback-methods)                    |
|  `table`   |                                         `List`, `Set`, `Map`                                         | When going from Java to Lua, converted only if the java method's return value is annotated with `@CoerceToNative`. When going from Lua to Java, converted unconditionally.               |
| `userdata` |                                         *, `Class`, `EClass`                                         | Java classes and objects are userdata and can be used where needed. Additionally, where a `Class` or `EClass` are expected, a userdata passed directly from `require` can be used.       |

### Throwing exceptions

See [Java Utilities - `java.throw()`](/reference/java-utils#java-throw-exception)

::: code-group
```Java
import java.lang.IllegalStateException;
// ...
throw new IllegalStateException("Oh no!");
```
```Lua
IllegalStateException = require("java.lang.IllegalStateException")

java.throw(IllegalStateException("Oh no!"))
```
:::

### Functional Interfaces

::: code-group
```Java
import com.example.ExampleObject;
// ...
ExampleObject example = new ExampleObject(1, 2, 3);
String message = "Hello World!";
List<SomeOtherObject> numbers = example.getList();
numbers.forEach((otherObj) -> {
    otherObj.sendMessage(message);
    otherObj.flush();
});
```
```Lua
ExampleObject = require("com.example.ExampleObject")

example = ExampleObject(1, 2, 3)
message = "Hello World!"
numbers = example:getList()
numbers:forEach(function(otherObj)
    otherObj:sendMessage(message)
    otherObj:flush()
end)
```
:::
::: tip
If the type is in the package `java.util.function` you can be confident it's a functional interface of some kind.
:::

### Generic Types

A generic class can be indexed with a table of classes before construction. This applies a lower boundary of possible types that the generic class can contain.

::: code-group
```Java
import java.util.List;
import java.util.ArrayList;
import java.lang.Integer;
// ...
List<Integer> intList = new ArrayList<>();
intList.addAll(3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 9);
// ...
```
```Lua
ArrayList = require("java.util.ArrayList")
Integer = require("java.lang.Integer")

intList = ArrayList[{Integer}]()
intList:addAll(3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 9)
```
:::