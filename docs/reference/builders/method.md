---
prev: 
    text: 'Class Building - classBuilder:method()'
    link: '/reference/class-building#classbuilder-method'
next: false
---

# Method Builder

## `methodBuilder:index(index)`

Adds an index to this method that is used instead of the method name when running `classBuilder:define()`.

### Parameters

1. `index` - `string`: A unique index that will be used as the name of the handler function in the table provided to `classBuilder:define()`.

### Returns

- `userdata [instance]` This method builder.

## `methodBuilder:override(name, params)`

Overrides a method in the parent class. 

If provided, `methodBuilder:name()`, `methodBuilder:params()`, and `methodBuilder:returnType()` must not be used, 
and `methodBuilder:access()` can only be used to maintain or increase the scope of the method, never decrease.

### Parameters

1. `name` - `string`: The name of the method to override.
1. `params` - `table<userdata [class]>`: The parameters of the method to override.

### Returns

- `userdata [instance]` This method builder.

## `methodBuilder:access(access)`

Defines this methods access. If no access table is provided, the default `package-private` scope is used.

If the method to be created is abstract, a function defintion must not be submitted.

If the method is not static then `self` represents `this`. 

If the method is static then `self` reprents a `userdata [class]` of the class being built, with access to all static fields.

### Parameters

1. `access` - `table`: Access flags for the method. See [Access Modifier Table](#access-modifier-table)

### Returns

- `userdata [instance]` This method builder.

## `methodBuilder:name(name)`

Define a name for the method to be created.

### Parameters

1. `name` - `string`: The method name.

### Returns

- `userdata [instance]` This method builder.

## `methodBuilder:parameters(params)`

Defines the parameters of this method.

### Parameters

1. `params` - `table<userdata [class]>`: The parameters of the method.

### Returns

- `userdata [instance]` This method builder.

## `methodBuilder:returnType(returnType)`

Defines the return type of this method.

### Parameters

1. `returnType` - `userdata [class]`: The return type of the method.

### Returns

- `userdata [instance]` This method builder.

## `methodBuilder:build()`

Finalize the method, preparing it for definition in `classBuilder:define()`.

### Returns

- `userdata [instance]` The class builder for which this method is being built for.