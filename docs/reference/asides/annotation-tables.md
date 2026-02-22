---
prev: false
next: false
---

## Annotation Tables

Annotation tables are tables that gets recursively parsed and applied to the annotation interface that the function represents. The method names become keys, and the return values become the value. Arrays are a standard table with number indices. 

There is a special exception to the method name `value`, where if it's the only key-value pair being provided, the key name can be omitted. A common example of this is the mixin `@At` annotation. Both:
```Lua
{ value = "HEAD" }
```
and:
```Lua
{ "HEAD" }
```
are valid ways to define an `@At` annotation.