# metroidvaniafangame

This is a simple 2d platformer fan game, all nintendo art assets do not belong to me, editing of assets was done by me. 
I have written the event driven animation scheme, collission detection, scene architecture, and game logic. 
This game is targeted for iphone 5 through 8+, and uses a MVC pattern.



Technical details:

-To minimize code duplication, the scenes are set up using inheritance and encapsulation. Everything needed for the scene to function is initialized in lvl1. If the demands of the level require different logic, the base functions should be overridden. If this is unfeasable, the new logic should be encapsulated with the object it relates to and should be added to an overridden base function.

-Multithreading (Grand Central Dispatch) is used to smoothly transition between scenes, and to preload assets that are not immediately needed.

-This app uses a fuzzy logic rule system (GKRuleSystem) to quickly evaluate standard game logic for more complex enemies and provide the framework for fuzzy logic if more complex enemy action is needed.

-This app utilizes the NSPredicate query language to access state information about enemies using the fuzzy logic system decribed above. 

-To minimize tile collisions, instead of using a physics based tile collision system (SpriteKit), I have utilized a tile collision algorithm that only checks if a collision has occured with the 8 adjacent tiles to the player, thus the only information needed is the players position and the layers where collisions may occur (no physicsbodies required, and no alternate array required).

-The collision system I have written has two main components, player contact with enemies, and enemy contact with player. This allows different types of collisions from the player to enemies, and enemies to player (different attacks/projectiles with different specifications for each).

-This app uses GKAgent's (GameplayKit) in conjunction with SpriteKit to create event driven autonomous flocking behavior that simulates real-world physical movement and targeting using GKAgents (ex. honeypot enemy). This behavoir is lightweight and requires no physicsbodies/external nodes attatched to the target, and is integrated with my collision detection system.

The gifs may take some time to load due to the filesize, any FPS tags are slower than on actual device (gifs captured on simulator)


![](menuscenedemo.gif)

![](honeypottrackdemo.gif)

![](bossdemo.gif)


Credits for art assets ripped by:

Garact Jownson-some background objects from metroid fusion

Midiwaffle-crateria tileset

B Hopkins & Captain Invictus-samus normal suit

Ray Wenderlich.com-Base super mario assets (1st lvl)

Tommy Lee-"honeypot" walking cactus enemy

