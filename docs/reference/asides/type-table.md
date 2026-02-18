---
prev: 
    text: 'Fundamentals - Type Conversions'
    link: '/reference/fundamentals#type-conversions'
next: false
---

# Aside - Type Mapping Reference

|  Lua Type  |                                                                               Java Type                                                                               |
| :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|   `nil`    |                                                                                `null`                                                                                 |
|  `number`  |                               `byte`, `short`, `int`, `long`, `float`, `double`, `Byte`, `Short`, `Int`, `Long`, `Float`, `Double` [^1]                               |
| `boolean`  |                                                                         `boolean`, `Boolean`                                                                          |
|  `string`  |                                                                               `String`                                                                                |
| `function` |                                                                            *instance* [^2]                                                                            |
|  `table`   | [See Source code](https://github.com/moongardenmods/allium/blob/main/allium/src/main/java/dev/hugeblank/allium/loader/type/coercion/TypeCoercions.java#L315-L330)[^3] |
| `userdata` |                                                                  *instance*, `Class`, `EClass` [^4]                                                                   |

[^1]: If a number greater than the max size of the Java type is provided, it overflows, wrapping around. (ex. if passing 256 where a byte is expected, the resulting byte will be 0)
[^2]: When going from Lua to Java, converted to an instance of a functional interface (java interface with only one method), where applicable. see [Callback Methods](#callback-methods)
[^3]: When going from Java to Lua, converted only if the java method's return value is annotated with `@CoerceToNative`. When going from Lua to Java, converted unconditionally.
[^4]: Java classes and objects are wrapped as userdata. Additionally, where a `Class` or `EClass` are expected, a userdata passed directly from `require` can be used.