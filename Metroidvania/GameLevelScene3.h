//
//  GameLevelScene3.h
//  Metroidvania
//
//  Created by nick vancise on 10/29/18.
//


#import <SpriteKit/SpriteKit.h>
#import "GameLevelScene.h"
#import "gameaudio.h"

@interface GameLevelScene3 : GameLevelScene

@property (nonatomic,strong) TMXLayer*background;
@property (nonatomic,strong) TMXLayer*foreground;
@property (nonatomic,strong) NSMutableArray*doors;

@end
