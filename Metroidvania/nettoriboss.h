//
//  nettoriboss.h
//  Metroidvania
//
//  Created by nick vancise on 12/31/18.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface nettoriboss : SKSpriteNode

@property (nonatomic,assign) int health;

-(instancetype)initWithPosition:(CGPoint)pos;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds;

@end


@interface petal : SKSpriteNode

-(instancetype)initWithAtlas:(SKTextureAtlas*)atlas andComponentSystem:(GKComponentSystem*)system andPosition:(CGPoint)pos;

@end

@interface petalprojectile : SKSpriteNode <GKAgentDelegate>

@property (nonatomic,strong) GKAgent2D*agent;

-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)atlas andComponentSystem:(GKComponentSystem*)system andPosition:(CGPoint)pos;

@end

