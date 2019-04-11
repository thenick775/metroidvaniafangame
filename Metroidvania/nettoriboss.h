//
//  nettoriboss.h
//  Metroidvania
//
//  Created by nick vancise on 12/31/18.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "enemyBase.h"

@interface nettoriboss : enemyBase

@property(nonatomic,strong) NSMutableArray*projectilesInAction;
-(instancetype)initWithPosition:(CGPoint)pos;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds;
-(void)startAttack;

@end

@interface petal : SKSpriteNode
-(instancetype)initWithAtlas:(SKTextureAtlas*)atlas andCS:(GKComponentSystem*)system andPos:(CGPoint)pos andArr:(NSMutableArray*)arr;
@end


@interface netprojbase : SKSpriteNode
@property (nonatomic,assign) BOOL canGiveDmg;
@property (nonatomic,assign) int dmgamt;
@property (nonatomic,strong) SKAction*dmgaction;
-(void)runDmgac;
@end

@interface petalprojectile : netprojbase <GKAgentDelegate>
@property (nonatomic,strong) GKAgent2D*agent;
//@property (nonatomic,assign) BOOL canGiveDmg;
-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)atlas andCS:(GKComponentSystem*)system andPos:(CGPoint)pos andArr:(NSMutableArray*)arr;
@end

@interface plant : netprojbase

//@property (nonatomic,assign) BOOL isattacking;
@property (nonatomic,strong) SKAction *plantidle,*plantattack;
-(instancetype)initWithPos:(CGPoint)pos andTextureAtlas:(SKTextureAtlas*)atlas;

@end

@interface netPlas : netprojbase

-(instancetype)initWithImageNamed:(NSString *)name andAtlas:(SKTextureAtlas*)atlas andArrayToRemoveFrom:(NSMutableArray*)arr;

@end
