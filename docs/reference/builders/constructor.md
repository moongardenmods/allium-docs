---
prev: 
    text: 'Class Building - classBuilder:constructor()'
    link: '/reference/class-building#classbuilder-constructor'
next: false
---

# Constructor Builder

## `constructorBuilder:index(index)`

Adds an index to this constructor that is used instead of the default name `constructor` when running `classBuilder:define()`.

### Parameters

1. `index` - `string`: A unique index that will be used as the name of the method in the table provided to `classBuilder:define()`.

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:access(access)`

Defines this constructors access. If no access table is provided, the default `package-private` scope is used.

### Parameters

1. `access` - `table`: Access flags for the constructor. See [Access Modifier Table](#access-modifier-table)

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:this(params)`

Indicates that this constructor should initialize using another constructor within this class.

### Parameters

1. `params` - `table<userdata [class]>`: The parameters of the `this` constructor.

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:super(params)`

Indicates that this constructor should initialize using one of the parent's class constructors.

### Parameters

1. `params` - `table<userdata [class]>`: The parameters of the `super` constructor.

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:parameters(params)`

Defines the parameters of this constructor. If omitted, defaults to the parameters of the `this` or `super` constructor, whichever is defined.
If the parameters of the constructor being built, and `super` or `this` constructor match, parameters do not need to be defined.

### Parameters

1. `params` - `table<userdata [class]>`: The parameters of the constructor.

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:remapper(func)`

Function that allows for the parameters of the constructor being built to be adapted to the `this` or `super` constructor, whichever is defined.
If the parameters of the constructor being built, and `super` or `this` constructor match, a remapper function is not needed.

### Parameters

1. `remapper` - `function?`: An function that accepts the parameters of the constructor that will eventually be built. Returns what will be fed into the `super` or `this` constructor.

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:definesFields()`

Indicates that this constructor will define instance fields. Constructors without this method invoked will not be able to define fields.
If invoked, Instance fields created by `classBuilder:field()` that do not have a default value must be initialized in this constructor.

### Returns

- `userdata [instance]` This constructor builder.

## `constructorBuilder:build()`

### Returns

- `userdata [instance]` The class builder for which this constructor is being built for.

Finalize the constructor, preparing it for definition in `classBuilder:define()`.