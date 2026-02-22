---
prev: 
    text: 'Class Building - mixinBuilder:method()'
    link: '/reference/class-building#mixinbuilder-method-index'
next: false
---

# Mixin Method Builder

## Method Annotations vs. Parameter Annotations

The following methods build out annotations that apply to the method being built:

- `methodBuilder:inject()`
- `methodBuilder:modifyArg()`
- `methodBuilder:modifyArgs()`
- `methodBuilder:modifyExpressionValue()`
- `methodBuilder:modifyReturnValue()`
- `methodBuilder:wrapMethod()`
- `methodBuilder:custom()`
- `methodBuilder:expression()`
- `methodBuilder:definition()`

Most of these functions represent injector annotations. Only one injector annotation can be provided per-method. The exceptions to this are `expression()` and `definition()`, which *can* be provided more than once per method.

The following methods build out sugar annotations that apply to parameters that are appended to the end of the parameter list of the method being built:

- `methodBuilder:localref()`
- `methodBuilder:share()`
- `methodBuilder:cancellable()`

---

## `methodBuilder:inject(annotation)`

Creates an [`@Inject`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/Inject.html) annotation.

For more information see:
- [Mixin Wiki - Advanced Mixin Usage - Callback Injectors](https://github.com/SpongePowered/Mixin/wiki/Advanced-Mixin-Usage---Callback-Injectors)
- [Mixin Cheatsheet - `@Inject`](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/inject.md)
- [Mixin Cheatsheet - `@Inject`, cancellable](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/inject.md)

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@Inject`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/Inject.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:modifyArg(annotation, targetType)`

Creates a [`@ModifyArg`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArg.html) annotation.

For more information see [Mixin Cheatsheet - `@ModifyArg`](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/modify-arg.md).

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@ModifyArg`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArg.html) annotation.
2. `targetType` - `string`: A type descriptor string of the argument being modified.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:modifyArgs(annotation)`

Creates a [`@ModifyArgs`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArgs.html) annotation.

For more information see [Mixin Cheatsheet - `@ModifyArgs`](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/modify-args.md).

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@ModifyArgs`](https://jenkins.liteloader.com/view/Other/job/Mixin/javadoc/index.html?org/spongepowered/asm/mixin/injection/ModifyArgs.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:modifyExpressionValue(annotation, targetType)`

Creates a [`@ModifyExpressionValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyExpressionValue.html) annotation.

For more information see [MixinExtras - ModifyExpressionValue](https://github.com/LlamaLad7/MixinExtras/wiki/ModifyExpressionValue)

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@ModifyExpressionValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyExpressionValue.html) annotation.
2. `targetType` - `string`: A type descriptor string of the argument being modified.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:modifyReturnValue(annotation)`

Creates a [`@ModifyReturnValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyReturnValue.html) annotation.

For more information see [MixinExtras - ModifyReturnValue](https://github.com/LlamaLad7/MixinExtras/wiki/ModifyReturnValue)

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@ModifyReturnValue`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/ModifyReturnValue.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:wrapMethod(annotation)`

Creates a [`@WrapMethod`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/wrapmethod/WrapMethod.html) annotation.

For more information see [MixinExtras - WrapMethod](https://github.com/LlamaLad7/MixinExtras/wiki/WrapMethod)

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@WrapMethod`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/injector/wrapmethod/WrapMethod.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:custom(annotation, annotationType, methodDescriptor, parameterTypes, returnType)`

Creates a custom injector annotation.

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the given `annotationType`.
2. `annotationType` - `userdata [class]`: The annotation class to be used.
3. `methodDescriptor` - `string`: The target method's descriptor string.
4. `parameterTypes` - `table<string>`: The parameters of the injector method. These may differ from the target method's descriptor.
5. `returnType` - `string`: The return type of the injector method. This may differ from the target method's descriptor.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:expression(annotation)`

Creates an [`@Expression`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Expression.html) annotation. This method does not produce an injector annotation and may be used multiple times within an inject method.

For more information see [MixinExtras - Expressions](https://github.com/LlamaLad7/MixinExtras/wiki/Expressions)

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@Expression`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Expression.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

## `methodBuilder:definition(annotation)`

Creates a [`@Definition`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Definition.html) annotation. This method does not produce an injector annotation and may be used multiple times within an inject method.

For more information see [MixinExtras - Expressions](https://github.com/LlamaLad7/MixinExtras/wiki/Expressions)

#### Parameters

1. `annotation` - `table`: An [annotation table](/reference/asides/annotation-tables) that matches the [`@Definition`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/expression/Definition.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this annotation is being applied to.

---

### `methodBuidler:localref(type, annotation, mutable)`

Creates a parameter with a [`@Local`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/sugar/Local.html) annotation.

See [MixinExtras Wiki - Local](https://github.com/LlamaLad7/MixinExtras/wiki/Local) for more information.

#### Parameters

1. `type` - `string`: A type descriptor string of the parameter.
2. `annotation` - `table?`: An optional [annotation table](/reference/asides/annotation-tables) that matches the [`@Local`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/sugar/Local.html) annotation.
3. `mutable` - `boolean?`: Whether this parameter should be mutable. 

::: warning
Setting `mutable` to `true` changes the parameter's type from the one passed in `type` to one from the [`LocalRef` family](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/sugar/ref/package-summary.html). 
:::

#### Returns

- `userdata [instance]`: The mixin method builder this parameter annotation is being applied to.

---

### `methodBuidler:share(type, annotation)`

Creates a parameter with a [`@Share`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/sugar/Share.html) annotation.

See [MixinExtras Wiki - Share](https://github.com/LlamaLad7/MixinExtras/wiki/Share) for more information.

#### Parameters

1. `type` - `string`: A type descriptor string of the parameter.
2. `annotation` - `table?`: An optional [annotation table](/reference/asides/annotation-tables) that matches the [`@Share`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/sugar/Share.html) annotation.

#### Returns

- `userdata [instance]`: The mixin method builder this parameter annotation is being applied to.

---

### `methodBuidler:cancellable()`

Creates a parameter with a [`@Cancellable`](https://javadoc.io/doc/io.github.llamalad7/mixinextras-fabric/latest/com/llamalad7/mixinextras/sugar/Cancellable.html) annotation.

See [MixinExtras Wiki - Cancellable](https://github.com/LlamaLad7/MixinExtras/wiki/Cancellable) for more information.

#### Returns

- `userdata [instance]`: The mixin method builder this parameter annotation is being applied to.