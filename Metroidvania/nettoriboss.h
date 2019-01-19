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

@end


@interface petal : SKSpriteNode

-(instancetype)initWithAtlas:(SKTextureAtlas*)atlas andCS:(GKComponentSystem*)system andPos:(CGPoint)pos andArr:(NSMutableArray*)arr;

@end

@interface petalprojectile : SKSpriteNode <GKAgentDelegate>

@property (nonatomic,strong) GKAgent2D*agent;

-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)atlas andCS:(GKComponentSystem*)system andPos:(CGPoint)pos andArr:(NSMutableArray*)arr;

@end

