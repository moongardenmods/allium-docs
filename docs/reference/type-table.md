---
prev: 
    text: 'Fundamentals - Type Conversions'
    link: '/reference/fundamentals#type-conversions'
next: false
---

# Type Mapping Reference

|  Lua Type  |                                                                               Java Type                                                                               |
| :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|   `nil`    |                                                                      `null`, `void`, `Void` [^1]                                                                      |
|  `number`  |                               `byte`, `short`, `int`, `long`, `float`, `double`, `Byte`, `Short`, `Int`, `Long`, `Float`, `Double` [^2]                               |
| `boolean`  |                                                                         `boolean`, `Boolean`                                                                          |
|  `string`  |                                                                               `String`                                                                                |
| `function` |                                                                            *instance* [^3]                                                                            |
|  `table`   | [See Source code](https://github.com/moongardenmods/allium/blob/main/allium/src/main/java/dev/hugeblank/allium/loader/type/coercion/TypeCoercions.java#L315-L330)[^4] |
| `userdata` |                                                                  *instance*, `Class`, `EClass` [^5]                                                                   |

[^1]: Can only be used as `void` or `Void` when describing a method to create or override during class building.
[^2]: If a number greater than the max size of the Java type is provided, it overflows, wrapping around. (ex. if passing 256 where a byte is expected, the resulting byte will be 0)
[^3]: When going from Lua to Java, converted to an instance of a functional interface (java interface with only one method), where applicable. see [Callback Methods](#callback-methods)
[^4]: When going from Java to Lua, converted only if the java method's return value is annotated with `@CoerceToNative`. When going from Lua to Java, converted unconditionally.
[^5]: Java classes and objects are wrapped as userdata. Additionally, where a `Class` or `EClass` are expected, a userdata passed directly from `require` can be used.