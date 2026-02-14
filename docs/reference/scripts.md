---
outline: [2, 3]
---

# Scripts

Scripts are a collection of one or more Lua files and a manifest JSON file, stored in a directory, a zip archive, or within a Java mod. 

## Manifest

The manifest file describes information relevant to the execution of the script, and metadata that might be useful for other scripts. 

The following values are required:
- `id`: The script ID. Must match the regex pattern `[0-9a-z_]+` (lowercase alphanumeric & underscore.)
- `version`: A version string. Does not have to be "[semver](https://semver.org/)", but consider making it make sense.
- `name`: A proper, descriptive name of the script. May be capitalized.
- `entrypoints`: The entrypoints from which this script launches from. See below.

### Entrypoints

Scripts are provided 2 entrypoints to launch from: `mixin`, and `main`. Scripts **MUST** provide a `main` entrypoint in order to be valid.

#### `mixin`

The `mixin` entrypoint is where mixin classes and interfaces are built and registered. This entrypoint is executed during the `preLaunch` phase, and should avoid doing anything other than mixin building.

For more information see [Mixin Library](/reference/mixin-lib).

#### `main`

The main entrypoint is where everything else should reside.

The first value returned by this entrypoint becomes the script's module. This module is provided to other scripts that provide this script's ID to `require()`.

### Example

```JSON5 [manifest.json]
{
  "id": "example",
  "version": "1.0.0",
  "name": "Example Script",
  "entrypoints": {
    "mixin": "mixin.lua",
    "main": "main.lua",
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

Gets the module provided by the `main` entrypoint.

#### Returns

- `any?`: The script module.

### `script:getName()`

Gets the name provided by the script manifest.

#### Returns

- `string`: The script name.

### `script:getVersion()`

Gets the version provided by the script manifest.

#### Returns

- `string`: The script version.

### `script:regsiterReloadable(func)`

Register a function that gets called when added, and when the script gets reloaded. This method is useful for registering script resources, hooking into events, or hooking into certain mixins. 

::: info
Not all code can or should be reloaded. For example, anything that touches Minecraft's registries (blocks, items, etc.) are unlikely to be reloadable and may even cause a crash.
:::

::: info
The default behavior for events and mixins changes whether the hook or event (anything that has an optional `destroyOnReload` parameter,) is being registered inside or outside of the function given to this method. 
Outside of this method, hooks/events do not get destroyed on reload. However, when placed inside the given function, they will be destroyed on reload. 
Use the optional parameter provided if a more deterministic behavior is desired.
:::

#### Parameters

1. `func` - `function`: A function to be invoked initially, and then for every reload.

### `script:registerResource(resource)`

Register a temporary resource to this script that will close when the script unloads (or reloads). Particularly useful in tandem with `script:registerReloadable()`.

#### Parameters

1. `resource` - `userdata [instance]`: An instance of type [`ScriptResource`](https://github.com/moongardenmods/allium/blob/main/allium/src/main/java/dev/hugeblank/allium/api/ScriptResource.java). 

#### Returns

- `userdata [instance]`: A refernece to the `resource` that will clear the resource from within the script when `close()` is called.