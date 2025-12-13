---
outline: [2, 3]
---

# Class Building

There are two class builder types. One is for general purpose class building, like creating a new block type by extending from `Block`. The other is for creating mixins to change the behavior of existing classes, like modifying a method in `CactusBlock` to increase the maximum height cacti can grow to.

::: warning
This page is under construction
:::

## Standard Class Builder

The following functions use a hypothetical `classBuilder` instance obtained from calling [`java.extendClass()`](/reference/java-utils#java-extendclass-superclass-interfaces-access)

TODO: Create an example class and build out a lua file through each functions "usage" section

### `classBuilder:overrideMethod(methodName, parameters, access, func)`

Override an existing method of the parent class.

#### Parameters

1. `methodName` - `string`: The name of the method to override.
2. `parameters` - `table<userdata [class]>`: The parameters of the method to override.
3. `access` - `{ static = boolean? }`: Access flags for the overriding method. Set `static` if the method to override is static.
4. `func` - `function`: The function to call for handling when the method is invoked. If the overriding method is not static then the first parameter is `this`, followed by the rest of the parameters specified in `parameters`.

#### Usage



### `classBuilder:createMethod(methodName, parameters, returnClass, access, func)`



#### Parameters



#### Usage



### `classBuilder:build()`



#### Returns



#### Usage



## Mixin Class Builder