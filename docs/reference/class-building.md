---
outline: [2, 3]
---

# Class Building

There are two class builder types. One is for general purpose class building, like creating a new block type by extending from `Block`. The other is for creating mixins to change the behavior of existing classes, like modifying a method in `CactusBlock` to increase the maximum height cacti can grow to.

## Standard Class Builder

::: warning
The standard class builder is one of the most in-development aspects of Allium. Expect it to change dramatically over the course of the Beta.
:::

Given the following class:

<<< @/reference/snippets/code/Animal.java

The following "usage" section of each method will build out a `Dog` class in Lua, starting with:

<<< @/reference/snippets/code/Dog.lua#init{Lua}

---

### `classBuilder:override(methodName, parameters, access)`

Override an existing method of the parent class.

#### Parameters

1. `methodName` - `string`: The name of the method to override.
2. `parameters` - `table<userdata [class]>`: The parameters of the method to override.
3. `access` - `{ static = boolean? }`: Access flags for the overriding method. Set `static` if the method to override is static.
4. `func` - `function`: The function to call for handling when the method is invoked. 

#### Usage

In addition to overriding the method we must supply a function to the builder on the index matching `methodName`.
If the overriding method is not static then the first parameter to the submitted function is `this`, followed by the rest of the parameters specified in `parameters`.

<<< @/reference/snippets/code/Dog.lua#override{1 Lua:line-numbers=4}

---

### `classBuilder:method(methodName, parameters, returnClass, access)`

Create an entirely new method on the class.

#### Parameters

1. `methodName` - `string`: The method name. Must not exist in any parent classes.
2. `parameters` - `table<userdata [class]>`: A table representing the parameter types in order.
3. `returnClass` - `userdata [class]`: The class to be returned by this method.
4. `access` - `{ abstract = boolean?, static = boolean? }`: Access flags for overriding the method.
5. `func` - `function`: The function to call for handling when the method is invoked. If the parameter `access.abstract` is `true`, this parameter is ignored.

#### Usage

If the method to be created is abstract, a function does not have to be submitted.
If the method is not static then the first parameter to the submitted function is `this`, followed by the rest of the parameters specified in `parameters`.

<<< @/reference/snippets/code/Dog.lua#create{1 Lua:line-numbers=21}

---

### `classBuilder:build()`

Builds the class.

#### Returns

- `userdata [class]`: The completed class. 

#### Usage

<<< @/reference/snippets/code/Dog.lua#build{1 Lua:line-numbers=26}

## Mixin Class Builder

Obtained from [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck), builds out a class that gets applied as a mixin.

<!--@include: ./snippets/mixin-danger.md-->

Given the following class:

<<< @/reference/snippets/code/Car.java

The following "usage" section of each method will modify this class in Lua, starting with:

<<< @/reference/snippets/code/CarMixin.lua#init{Lua}

The sections will also use an arbitrary "entrypoint" script representing either the `static` or `dynamic` entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#init{Lua}



### `mixinBuilder:createInjectMethod(hookId, methodAnnotations, sugarParameters)`

Create an inject method. Can **not** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

#### Parameters

1. `hookId` - `string`: hook ID to later apply a hook onto this mixin with [`mixin.get()`](/reference/mixin-lib#mixin-get-hookid).
2. `methodAnnotations` - `table<userdata [instance]>`: Table of annotations to apply to the injector method. Requires exactly one injector annotation. See [Mixin Library - Annotations](/reference/mixin-lib#annotations).
3. `sugarParameters` - `table<userdata [instance]>`: Table of sugar parameters to apply after the last parameter of the injector method. See [Mixin Library - Sugars](/reference/mixin-lib#sugars).

#### Usage

Modify the constructor to negate the added 5 speed:

<<< @/reference/snippets/code/CarMixin.lua#create{1,6 Lua:line-numbers=3}

Then in either the `static` or `dynamic` script entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#create{Lua:line-numbers=6}

::: tip
To inject into constructors, and static blocks, use `<init>()V` and `<clinit>()V` as target method names, respectively. Don't forget to fill in parameters!
:::

### `mixinInterfaceBuilder:accessor(annotations)`

Defines a setter and getter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

This is a convenience method that simply calls both `mixinInterfaceBuilder:getAccessor()` and `mixinInterfaceBuilder:setAccessor()` with the same `annotations` table.

For more information see [Mixin Cheatsheet - `@Accessor`](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/accessor.md).

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Usage

Add a setter and getter accessor for the speed:

<<< @/reference/snippets/code/CarMixin.lua#accessor{Lua:line-numbers=9}

Mess with it later on in the `static` or `dynamic` entrypoints:

<<< @/reference/snippets/code/entrypoint.lua#accessor{Lua:line-numbers=10}

### `mixinInterfaceBuilder:getAccessor(annotations)`

Defines a getter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target field name. It starts with `get`, then the first letter of the target field name is capitalized, and concatenated with the `get`. For example, given the target field `fooBar`, the method `getFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Usage

Add a getter accessor for the number of wheels:

<<< @/reference/snippets/code/CarMixin.lua#getaccessor{Lua:line-numbers=10}

Mess with it later on in the `static` or `dynamic` entrypoints:

<<< @/reference/snippets/code/entrypoint.lua#getaccessor{Lua:line-numbers=12}

### `mixinInterfaceBuilder:setAccessor(annotations)`

Defines a setter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target field name. It starts with `set`, then the first letter of the target field name is capitalized, and concatenated with the `set`. For example, given the target field `fooBar`, the method `setFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Usage

Add a setter accessor for gas:

<<< @/reference/snippets/code/CarMixin.lua#setaccessor{Lua:line-numbers=11}

Mess with it later on in the `static` or `dynamic` entrypoints:

<<< @/reference/snippets/code/entrypoint.lua#setaccessor{Lua:line-numbers=13}

### `mixinInterfaceBuilder:invoker(annotations)`

Defines an invoker using the [`@Invoker`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Invoker.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target method name. It starts with `invoke`, then the first letter of the target method name is capitalized, and concatenated with the `invoke`. For example, given the target method `fooBar()`, the method `invokeFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Invoker`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Invoker.html) annotation.

#### Usage

Add an invoker for `isSpeeding()`:

<<< @/reference/snippets/code/CarMixin.lua#invoker{Lua:line-numbers=12}

Mess with it later on in the `static` or `dynamic` entrypoints:

<<< @/reference/snippets/code/entrypoint.lua#invoker{Lua:line-numbers=14}

### `mixinBuilder:build(mixinId)`

Builds the mixin.

#### Parameters

1. `mixinId?` - `string`: A unique ID representing the mixin class. Used to obtain the duck interface for accessing fields and invoking methods. Only required if the mixin builder was created with `duck` set to `true`.

#### Usage

<<< @/reference/snippets/code/CarMixin.lua#build{Lua:line-numbers=13}
