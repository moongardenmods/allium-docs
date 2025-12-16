# Package Library

The package library is in its usual place in the `package` global. It has a reasonable number of distinctions to the standard Lua 5.2 `package` global, they are noted here.

::: info
Libraries (like `package`) are distinct between scripts. If a package is provided in the `package.preload` table in script A, it will not be present in the `package.preload` of script B.
:::

## `package.config`

While the `package.config` string is the same between standard Lua and Allium, The fourth (`!`) and fifth (`-`) lines are unused.

For more information see [Lua 5.2 Reference Manual - `package.config`](https://www.lua.org/manual/5.2/manual.html#pdf-package.config)

## `package.cpath`

Allium uses [Cobalt](https://github.com/cc-tweaked/Cobalt), a Lua interpreter written in Java. There's no ability for C libraries to be loaded. As such, the value of `package.cpath` is `nil`.

For more information see [Lua 5.2 Reference Manual - `package.cpath`](https://www.lua.org/manual/5.2/manual.html#pdf-package.cpath)

## `package.loadlib()`

Similar to `package.cpath`, C libraries cannot be loaded by Cobalt. `package.loadlib()` is not present (`nil`).

[Lua 5.2 Reference Manual - `package.loadlib`](https://www.lua.org/manual/5.2/manual.html#pdf-package.loadlib)

## `package.path`

The default `package.path` is `"./?.lua;./?/init.lua"`

[Lua 5.2 Reference Manual - `package.path`](https://www.lua.org/manual/5.2/manual.html#pdf-package.path)

## `package.searchers`

Package searchers are iterated over by `require`. The following searchers are provided in this order:
1. **Preload**: The standard preload loader. If a match is found within the `package.preload` table, the resulting function is treated as the searcher.
2. **Path**: The standard path loader. Searches the scripts root directory for a file that matches one of the patterns in `package.path`.
3. **External Script**: The first loader that's unique to Allium. When provided a script ID, if it has a module, will provide it. A script provides a module by returning it in 
4. **Java**: The second and final loader that's unique to Allium. When provided a path to a class, the class will be loaded, and then provided.

[Lua 5.2 Reference Manual - `package.searchers`](https://www.lua.org/manual/5.2/manual.html#pdf-package.searchers)

## `package.searchpath()`

The working directory of `package.searchpath()` is the script's root.

[Lua 5.2 Reference Manual - `package.searchpath`](https://www.lua.org/manual/5.2/manual.html#pdf-package.searchpath)