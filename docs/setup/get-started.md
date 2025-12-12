---
outline: deep
---

# Get Started

By the end of this article you will have a workspace set up for Allium script development.

## Installation

### The Easy Way

For the least amount of friction while developing it is recommended to do so in an environment that is also conducive to Java modding. Grabbing class names and understanding what the game is doing are made much easier in an IDE that's set up for a java mod. The easiest way to do that is to clone Allium's own repository and work on your project within it. This guide demonstrates how to do it via IntelliJ, but VSCode and Eclipse are also viable IDE's.

1. Install [IntelliJ IDEA](https://www.jetbrains.com/idea/download)
2. Launch and Click "Clone Repository" 
::: details Screenshot
![A screenshot of IntelliJ IDEA's project menu with the Clone Repository selected](/get-started/01.png)
:::
3. Clone the repository using the URL in the "Code" button dropdown, or copy `git@github.com:moongardenmods/allium.git`. Click Clone, and wait for the project to finish importing. 
::: details Screenshot
![A screenshot of IntelliJ IDEA's Clone Repository menu](/get-started/02.png)
:::
4. In the top right there should be several run configurations in the dropdown. Pick either "Bouquet Client" or "Allium Client", and press the "Run" button. 
::: details Screenshot
![A screenshot of IntelliJ IDEA's Run Configuration Dropdown](/get-started/03.png)
:::
::: tip
The "Allium Client" run configuration launches the game without Bouquet. If you intend on using Bouquet as a dependency, consider using the "Bouquet Client" configuration.
:::
::: tip
"Server" run configurations are also provided to enable testing that a script works on a dedicated server.
:::
5. The prior step creates a folder `run` at the root of the project. Within that folder should be the folders one would expect to see in an instance of the game (ex. `saves`, `resourcepacks`, `mods`). Additionally, `allium` should be there, which is where scripts go. 

::: info
If you would like to add the example scripts to be run when launching the game, drag and drop the contents of `bouquet/examples` into the `run/allium` folder. To prevent confusion, especially if planning on modifying the example scripts, consider symlinking the `bouquet/examples` directory to `run/allium`.
:::

### The Hard Way

If the only goal is to create a simple script with little to no references to game logic, it might be preferable to skip setting up the IDE and do development in a production instance of the game. Do this using your preferred launcher (Prism, MultiMC, Vanilla, etc.). Download Allium, create the `allium` directory in the instance root, and optionally install Bouquet.
::: details Screenshot
![A Screenshot of the folder view of a Minecraft Instance with Allium](/get-started/04.png)
An example of the usual game instance with Allium
:::