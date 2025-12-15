::: danger 
Mixins are a very complicated topic that's very hard to grasp without a decent understanding of the JVM. If you would like to learn more about them, check out:
1. [Mixin's own wiki](https://github.com/SpongePowered/Mixin/wiki).
2. The [Mixin Cheatsheet](https://github.com/dblsaiko/mixin-cheatsheet/blob/master/README.md).
3. [MixinExtras' Wiki](https://github.com/LlamaLad7/MixinExtras/wiki).
:::

::: danger DOUBLE DANGER
Due to a limitation in how mixins are applied, if another mod chooses to apply mixins during the `preLaunch` phase, all Allium script mixins will **NOT** apply. If a script mixin appears to not be applying properly, this might be why.
:::