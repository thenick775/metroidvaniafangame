//
//  GameLevelScene2.h
//  Metroidvania
//
//  Created by nick vancise on 6/10/18.


#import <SpriteKit/SpriteKit.h>
#import "GameLevelScene.h"

@interface GameLevelScene2 : GameLevelScene 

@property (nonatomic,strong) TMXLayer*background;
@property (nonatomic,assign) bool hasHadBossInterac;

@end
