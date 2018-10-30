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

-(instancetype)initWithSize:(CGSize)size;
@property (nonatomic,strong) TMXLayer*background;

@end
