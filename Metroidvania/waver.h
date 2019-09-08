
//
//  waver.h
//  Metroidvania
//
//  Created by nick vancise on 10/10/18.
//
#import <GameplayKit/GameplayKit.h>
#import "enemyBase.h"

@interface waver : enemyBase <GKAgentDelegate>

@property (nonatomic,assign) BOOL attacking;

-(instancetype)initWithPosition:(CGPoint)position xRange:(int)xrange yRange:(int)yrange;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds andPlayerpos:(CGPoint)playerpos;
-(void)attack;

@end
