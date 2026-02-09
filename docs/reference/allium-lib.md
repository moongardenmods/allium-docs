# Allium Library

The following functions are provided to scripts via the `allium` global.

## `allium.environment()`

Get the current environment the game is running in. If `"client"`, then client specific rendering classes are available for use. If `"server"`, then the client logic is unavailable, but anything else is available.

### Returns

- `string` - `"client"` or `"server"`.

### Usage

```Lua
print("environment is:", package.environment())
```

## `allium.isScriptPresent(id)`

Check if a script with the given ID is present and initialized.

### Parameters

1. `id` - `string`: The script ID to check for.

### Returns

- `boolean` - Whether or not a script with the given ID is present.

### Usage

```Lua {1}
if allium.isScriptLoaded("bouquet") then
    print("Bouquet is loaded!")
else
    print("Bouquet is not loaded.")
end
```

## `allium.getAllScripts()`

Get all currently running scripts.

### Returns

- `table<userdata [instance]>`: A table of scripts. See [Scripts - Functions](/reference/scripts#Functions).

### Usage

```Lua {1}
local scripts = allium.getAllScripts()
for _, script in ipairs(scripts) do
    print(script:getID(), script:getName())
end
```

## `allium.getScript(id)`

Get a script with the given ID.

### Parameters

1. `id` - `string`: The script ID to get.

### Returns

- `userdata [instance]?`: A script, if one with the given ID exists. See [Scripts - Functions](/reference/scripts#Functions).

### Usage

```Lua {1}
local bouquet = allium.getScript("bouquet")
if not bouquet then
    print("Bouquet not found!")
else
    print(bouquet:getName().." version: ", bouquet:getVersion())
end
```

