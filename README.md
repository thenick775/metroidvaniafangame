# metroidvaniafangame

Written by Nicholas VanCise, credit for art and base assets provided below.

This is a simple 2d platformer fan game, all nintendo art assets do not belong to me, editing of assets was done by me. 
I have written the event driven animation scheme, collission detection, character physics, scene architecture, and game logic. 
This game is targeted for iphone 5 through 8+, and uses a MVC pattern.



Technical details:

-To minimize code duplication, the scenes are set up using inheritance and encapsulation. Everything needed for the scene to function is initialized in lvl1. If the demands of the level require different logic, the base functions should be overridden. If this is unfeasable, the new logic should be encapsulated with the object it relates to and should be added to an overridden base function.

-This app makes use of the third party library JSTileMap to make use of Tiled TMX tile maps.

-Multithreading (background tasks provided by Spritekit was used over GCD in this case) is used to smoothly transition between scenes, to preload assets without blocking the UI while transitioning, and to handle UI elements that use autolayout.

-This app uses a fuzzy logic rule system (GKRuleSystem) to quickly evaluate standard game logic for more complex enemies and provide the framework for fuzzy logic to be applied if more complex enemy action is needed.

-This app utilizes the NSPredicate query language to access state information about enemies using the fuzzy logic system decribed above. 

-To minimize tile collisions, instead of using a physics based tile collision system (SpriteKit), I have utilized a tile collision algorithm that only checks if a collision has occured with the 8 adjacent tiles to the player, thus the only information needed is the players position and the layers where collisions may occur (no physicsbodies required, and no alternate array required).

-The collision system I have written has two main components, player contact with enemies, and enemy contact with player. This allows different types of collisions from the player to enemies, and enemies to player (different attacks/projectiles with different specifications for each).

-This app uses GKAgent's (GameplayKit) in conjunction with SpriteKit to create event driven autonomous flocking behavior that simulates real-world physical movement and targeting using GKAgents, and dynamic wandering (ex. honeypot enemy, wavrt). This behavoir is lightweight and requires no physicsbodies/external nodes attatched to the target, and is integrated with my collision detection system for applicable enemies.

-Audio management of this game has been encapsulated in a class specifically designed to manage the audio of each scene. This class makes use of AVFoundation, specifically AVAudioPlayer and its related functions, along with GCD to play sounds asychronously. This allows relevent audio to be preloaded with each scene, and the load on the main thread and memory is as small as possible.

-NSNotificationCenter is used to handle the scene as the app transitions between background and active states.

The gifs may take some time to load due to the filesize, any FPS tags are slower than on actual device (gifs captured on simulator)


![](menuscenedemo.gif)

![](honeypottrackdemo.gif)

![](bossdemo.gif)


Credits for art assets ripped by:

Garact Jownson-some background objects from metroid fusion

Midiwaffle-crateria tileset

B Hopkins & Captain Invictus-samus normal suit

Ray Wenderlich.com-Base super mario assets (1st lvl)

Tommy Lee-"honeypot" walking cactus enemy, metroid sprite (used as volume slider)

N-finity-Arachnus boss, Waver enemy , Sciser enemy

ansimuz-space parallax backround (menu scene background)

Credit for music:

BurghRecords-Dystopian Future Fx Sounds (used in menuscene, background music) liscensed under Creative Commons 0 Liscense

Micah Young-Lost Moon's Grateful Eights (used in lvl1, background music) liscensed under Creative Commons Attribution Liscense

deleted_user_38815-newbit2 (used in lvl2, background music) liscensed under Creative Commons Attribution Liscense

Bob Bobium-Human Station Menuscene (space colony ceres), Door sprites

Greiga Master-Chozo Statue
