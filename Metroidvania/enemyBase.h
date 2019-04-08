//
//  enemyBase.h
//  Metroidvania
//
//  Created by nick vancise on 12/21/18.
//

#import <SpriteKit/SpriteKit.h>

@interface enemyBase : SKSpriteNode
@property (nonatomic,assign) int health;
@property (nonatomic,assign) BOOL dead;
@property (nonatomic,assign) BOOL needsUpdate;
@property (nonatomic,assign) BOOL recievesMelee;

-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray*)arr withHit:(int)hit;
-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray*)arr;

@end
