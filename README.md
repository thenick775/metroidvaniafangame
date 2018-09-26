# metroidvaniafangame

This is a simple 2d platformer fan game, all nintendo art assets do not belong to me, editing of assets was done by me. 
I have written the event driven animation scheme, collission detection, scene architecture, and game logic. 
This game is targeted for iphone 5 through 8+, and uses a MVC pattern.



Technical details:

To minimize code duplication, the scenes are set up using inheritance and encapsulation. Everything needed for the scene to function is initialized in lvl1. If the demands of the level require different logic, the base functions should be overridden. If this is unfeasable, the new logic should be encapsulated with the object it relates to and should be added to an overridden base function.

This app uses a fuzzy logic rule system (GKRuleSystem) to quickly evaluate standard game logic for enemies and provide the framework for fuzzy logic if more complex enemy action is needed.

This app utilizes the NSPredicate query language to access state information about enemies using the fuzzy logic system decribed above. 

To minimize tile collisions, instead of using a physics based tile collision system (SpriteKit), I have utilized a tile collision algorithm that only checks if a collision has occured with the 8 adjacent tiles to the player, thus the only information needed is the players position and the layers where collisions may occur (no physicsbodies required, and no alternate array required).


![](menuscenedemo.gif)

![](metroidvaniademo.gif)
