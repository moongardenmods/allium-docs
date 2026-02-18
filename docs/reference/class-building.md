---
outline: [2, 3]
---

# Class Building

There are two class builder types. One is for general purpose class building, like creating a new block type by extending from `Block`. The other is for creating mixins to change the behavior of existing classes, like modifying a method in `CactusBlock` to increase the maximum height cacti can grow to.

## Standard Class Builder

Given the following class:

<<< @/reference/snippets/code/Animal.java

The following documentation uses this `Dog.lua` file, and specifically pulls in snippets of the relevant sections. The entire file is provided here for reference:

<<< @/reference/snippets/code/Dog.lua{Lua}

---

### `classBuilder:field(name, type, access, value)`

Creates a field.

#### Parameters

1. `name` - `string`: The name of the field to create.
2. `type` - `userdata [class]`: The class type of the field.
3. `access` - `table?`: Access flags for the field. See [Access Modifier Table](#access-modifier-table)
4. `value` - `number|string|boolean?`: Optional primitive value for defining the field.

#### Returns

- `userdata [instance]` The class builder for which this field is for.

#### Usage

Note that this field gets defined in the constructor, which was created with `definesFields()`.
<<< @/reference/snippets/code/Dog.lua#field{Lua:line-numbers=36}

---

### `classBuilder:clinit()`

Creates a class initializer builder, primarily used for defining static fields.

#### Returns

- `userdata [instance]` - A [Class Init Builder](/reference/builders/clinit)

#### Usage

<<< @/reference/snippets/code/Dog.lua#clinit{Lua:line-numbers=37}
<<< @/reference/snippets/code/Dog.lua#clinitDef{Lua:line-numbers=5}

---

### `classBuilder:constructor()`

Creates a constructor builder for adding a constructor to this class.

#### Returns

- `userdata [instance]` - A [Constructor Builder](/reference/builders/constructor)

#### Usage

<<< @/reference/snippets/code/Dog.lua#constructor{Lua:line-numbers=40}
<<< @/reference/snippets/code/Dog.lua#constructorDef{Lua:line-numbers=9}

---

### `classBuilder:method()`

Creates a method builder for creating an entirely new method, or overriding one 

#### Returns

- `userdata [instance]` - A [Method Builder](/reference/builders/method)

#### Usage

<<< @/reference/snippets/code/Dog.lua#method{Lua:line-numbers=50}
<<< @/reference/snippets/code/Dog.lua#methodDef{Lua:line-numbers=13}

---

### `classBuilder:build()`

Builds the class.

#### Returns

- `userdata [class]`: The completed class. 

#### Usage

<<< @/reference/snippets/code/Dog.lua#build{Lua:line-numbers=61}

---

### Access Modifier Table

Access modifier tables are used in almost every class builder method. They are defined as:

```Lua
{
    public = boolean?,
    protected = boolean?,
    private = boolean?,
    static = boolean?, -- only used for methods and fields
    final = boolean?, -- only used for fields and classes
    abstract = boolean?, -- only used for methods and classes
    interface = boolean? -- only used for classes
}
```

## Mixin Class Builder

Obtained from [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck), builds out a class that gets applied as a mixin.

<!--@include: ./snippets/mixin-danger.md-->

Given the following class:

<<< @/reference/snippets/code/Car.java

The following "usage" section of each method will modify this class in Lua, starting with:

<<< @/reference/snippets/code/CarMixin.lua#init{Lua}

The sections will also use an arbitrary "entrypoint" script representing the `main` entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#init{Lua}



### `mixinBuilder:createInjectMethod(hookId, methodAnnotations, sugarParameters)`

Create an inject method. Can **not** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

#### Parameters

1. `hookId` - `string`: hook ID to later apply a hook onto this mixin with [`mixin.get()`](/reference/mixin-lib#mixin-get-hookid).
2. `methodAnnotations` - `table<userdata [instance]>`: Table of annotations to apply to the injector method. Requires exactly one injector annotation. See [Mixin Library - Annotations](/reference/mixin-lib#annotations).
3. `sugarParameters` - `table<userdata [instance]>`: Table of sugar parameters to apply after the last parameter of the injector method. See [Mixin Library - Sugars](/reference/mixin-lib#sugars).

#### Returns

- `userdata [instance]` - The mixin builder

#### Usage

Modify the constructor to negate the added 5 speed:

<<< @/reference/snippets/code/CarMixin.lua#create{1,6 Lua:line-numbers=3}

Then in the `main` script entrypoint:

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

#### Returns

- `userdata [instance]` - The mixin builder

#### Usage

Add a setter and getter accessor for the speed:

<<< @/reference/snippets/code/CarMixin.lua#accessor{Lua:line-numbers=9}

Mess with it later on in the `main` entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#accessor{Lua:line-numbers=10}

### `mixinInterfaceBuilder:getAccessor(annotations)`

Defines a getter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target field name. It starts with `get`, then the first letter of the target field name is capitalized, and concatenated with the `get`. For example, given the target field `fooBar`, the method `getFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Returns

- `userdata [instance]` - The mixin builder

#### Usage

Add a getter accessor for the number of wheels:

<<< @/reference/snippets/code/CarMixin.lua#getaccessor{Lua:line-numbers=10}

Mess with it later on in the `main` entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#getaccessor{Lua:line-numbers=12}

### `mixinInterfaceBuilder:setAccessor(annotations)`

Defines a setter accessor using the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target field name. It starts with `set`, then the first letter of the target field name is capitalized, and concatenated with the `set`. For example, given the target field `fooBar`, the method `setFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Accessor`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Accessor.html) annotation.

#### Returns

- `userdata [instance]` - The mixin builder

#### Usage

Add a setter accessor for gas:

<<< @/reference/snippets/code/CarMixin.lua#setaccessor{Lua:line-numbers=11}

Mess with it later on in the `main` entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#setaccessor{Lua:line-numbers=13}

### `mixinInterfaceBuilder:invoker(annotations)`

Defines an invoker using the [`@Invoker`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Invoker.html) annotation. Can **only** be used on mixin builders where `duck` is `true`. See [`mixin.to()`](/reference/mixin-lib#mixin-to-targetclass-interfaces-targetenvironment-duck).

The method name is automatically generated from the target method name. It starts with `invoke`, then the first letter of the target method name is capitalized, and concatenated with the `invoke`. For example, given the target method `fooBar()`, the method `invokeFooBar()` is created. 

#### Parameters

1. `annotations` - `table`: An [annotation table](#annotation-tables) that matches the [`@Invoker`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/gen/Invoker.html) annotation.

#### Returns

- `userdata [instance]` - The mixin builder

#### Usage

Add an invoker for `isSpeeding()`:

<<< @/reference/snippets/code/CarMixin.lua#invoker{Lua:line-numbers=12}

Mess with it later on in the `main` entrypoint:

<<< @/reference/snippets/code/entrypoint.lua#invoker{Lua:line-numbers=14}

### `mixinBuilder:build(mixinId)`

Builds the mixin.

#### Parameters

1. `mixinId?` - `string`: A unique ID representing the mixin class. Used to obtain the duck interface for accessing fields and invoking methods. Only required if the mixin builder was created with `duck` set to `true`.

#### Usage

<<< @/reference/snippets/code/CarMixin.lua#build{Lua:line-numbers=13}
