---
outline: [2, 3]
---

# Scripts

Scripts are a collection of one or more Lua files and a manifest JSON file, stored in a directory, a zip archive, or within a java mod. 


## Manifest

The manifest file describes information relevant to the execution of the script, and metadata that might be useful for other scripts. 

The following values are required:
- `id`: The script ID. Must match the regex pattern `[0-9a-z_]+` (lowercase alphanumeric & underscore.)
- `version`: A version string. Does not have to be "[semver](https://semver.org/)", but consider making it make sense.
- `name`: A proper, descriptive name of the script. May be capitalized.
- `entrypoints`: The entrypoints from which this script launches from. See below.

### Entrypoints

Scripts are provided 3 entrypoints to launch from: mixin, static, and dynamic. Scripts **MUST** provide a static or dynamic entrypoint in order to be valid.

#### `mixin`

The mixin entrypoint is where mixin classes and interfaces are built and registered. This entrypoint is executed during the `preLaunch` phase, and should avoid doing anything other than mixin building.

For more information see [Mixin Library](/reference/mixin-lib).

#### `static`

The static entrypoint is where code that is unable to be reloaded should reside. For instance, anything that touches one of the games many registries found in the `BuiltinRegistries` class is unlikely to be able to be reloaded.

The first value returned by this entrypoint becomes the script's module. This module is provided to other scripts that `require()` this script's ID.

#### `dynamic`

The dynamic entrypoint is where code that *can* be reloaded should reside. This includes [mixin method hooks](/reference/mixin-lib#method-hook), and event handlers.

::: info
Depending on where the mixin is, the reloadability might not be useful. For example if the mixin only executes once on launch then the reloaded hook will not be called.
:::

### Example

```JSON5 [manifest.json]
{
  "id": "example",
  "version": "1.0.0",
  "name": "Example Script",
  "entrypoints": {
    "mixin": "mixin.lua",
    "static": "main.lua",
    "dynamic": "dynamic.lua"
  }
}
```

## Functions

The `script` global is a `userdata [instance]` that represents the currently executing script. The following functions are provided.

### `script:getId()`

Gets the ID provided by the script manifest.

#### Returns

- `string`: The script ID.

### `script:getModule()`

Gets the module provided by the `static` entrypoint.

#### Returns

- `string`: The script module.

### `script:getName()`

Gets the name provided by the script manifest.

#### Returns

- `string`: The script name.

### `script:getVersion()`

Gets the version provided by the script manifest.

#### Returns

- `string`: The script version.

### `script:registerResource(resource)`

Register a temporary resource to this script that will close when the script unloads.

#### Parameters

1. `resource` - `userdata [instance]`: An instance of type [`ScriptResource`](https://github.com/moongardenmods/allium/blob/main/allium/src/main/java/dev/hugeblank/allium/api/ScriptResource.java). 

#### Returns

- `userdata [instance]`: A wrapped instance of the `resource` that clears the dangling resource from within the script when `close()` is called.