---
prev: 
    text: 'Class Building - classBuilder:clinit()'
    link: '/reference/class-building#classbuilder-clinit'
next: false
---


# Class Initializer Builder

Class initializers are invoked on class load, and are meant to set static variables that do not have a pre-defined value.

## `clinitBuilder:index(index)`

Adds an index to this class initializer that is used instead of the default name `initializer` when running `classBuilder:define()`.

### Parameters

1. `index` - `string`: A unique index that will be used as the name of the handler function in the table provided to `classBuilder:define()`.

### Returns

- `userdata [instance]` This class initializer builder.

## `clinitBuilder:build()`

Finalize the class initializer, preparing it for definition in `classBuilder:define()`.

### Returns

- `userdata [instance]` The class builder for which this class initializer is being built for.