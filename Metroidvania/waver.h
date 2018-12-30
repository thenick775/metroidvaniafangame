
//
//  waver.h
//  Metroidvania
//
//  Created by nick vancise on 10/10/18.
//
#import <GameplayKit/GameplayKit.h>
#import "enemyBase.h"

@interface waver : enemyBase <GKAgentDelegate>

//@property (nonatomic,assign) int health;
@property (nonatomic,assign) BOOL attacking;

-(instancetype)initWithPosition:(CGPoint)position;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds andPlayerpos:(CGPoint)playerpos;
-(void)attack;


@end
