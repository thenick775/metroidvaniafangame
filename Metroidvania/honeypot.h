//
//  honeypot.h
//  Metroidvania
//
//  Created by nick vancise on 9/29/18.
//
#import <Spritekit/Spritekit.h>
#import <GameplayKit/GameplayKit.h>


@interface honeypotproj:SKSpriteNode<GKAgentDelegate>
@property (nonatomic,strong) GKAgent2D *agent;

-(instancetype)initWithPosition:(CGPoint)position andTex:(SKTexture*)tex andAnger:(BOOL)angry;
@end



@interface honeypot : SKSpriteNode
@property (nonatomic,assign) int health;
@property (nonatomic,strong) SKAction *explode;
@property (nonatomic,strong) SKAction *explodeangry;
@property (nonatomic,assign) BOOL dead;
@property (nonatomic,strong) GKComponentSystem *agentSystem;
@property (nonatomic,strong) GKAgent2D *target;
-(instancetype)init;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds;
@end

