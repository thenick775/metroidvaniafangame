//
//  desgeega.h
//  Metroidvania
//
//  Created by nick vancise on 8/23/19.
//

#import <GameplayKit/GameplayKit.h>
#import "enemyBase.h"


@interface desgeega : enemyBase

@property(nonatomic,strong) GKComponentSystem *agentSystem;
@property(nonatomic,strong) NSMutableArray*projectilesInAction;
@property(nonatomic,strong) GKAgent2D *target;
@property(nonatomic,assign) BOOL attacking;
-(instancetype)initWithPosition:(CGPoint)pos andPosConst:(SKRange*)constr andJmpHeight:(float)height andJmpDist:(float)dist;

@end

@interface desgeegaproj:SKSpriteNode<GKAgentDelegate>

@property (nonatomic,strong) GKAgent2D *agent;
@property (nonatomic,assign) BOOL ishanger,istracking;
@property (nonatomic,assign) int health;
@property (nonatomic,strong) SKAction *projectileexplode;
-(instancetype)initWithPosition:(CGPoint)position andTex:(SKTextureAtlas*)tex isHanger:(BOOL)ishanger;
-(void)addTrail;
-(float)calcSpeed:(int)pps otherPoint:(CGPoint)point;

@end

