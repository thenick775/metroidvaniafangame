//
//  enemyBase.h
//  Metroidvania
//
//  Created by nick vancise on 12/21/18.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLevelScene.h"
#import "SKTUtils.h"

@interface enemyBase : SKSpriteNode
@property (nonatomic,assign) int health;
@property (nonatomic,assign) BOOL dead;
@property (nonatomic,assign) int dx,dy;

-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray*)arr withHit:(int)hit;
-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray*)arr;
-(void)enemytoplayerandmelee:(GameLevelScene*)scene;

@end
