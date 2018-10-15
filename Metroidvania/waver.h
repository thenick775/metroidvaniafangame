
//
//  waver.h
//  Metroidvania
//
//  Created by nick vancise on 10/10/18.
//
#import <Spritekit/Spritekit.h>
#import <GameplayKit/GameplayKit.h>

@interface waver : SKSpriteNode <GKAgentDelegate>

@property (nonatomic,assign) int health;
@property (nonatomic,assign) BOOL attacking;

-(instancetype)initWithPosition:(CGPoint)position;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds andPlayerpos:(CGPoint)playerpos;
-(void)attack;


@end
