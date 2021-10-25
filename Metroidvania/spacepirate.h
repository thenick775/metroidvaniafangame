//
//  spacepirate.h
//  Metroidvania
//
//  Created by nick vancise on 7/1/20.
//

#import "enemyBase.h"
#import <GameplayKit/GameplayKit.h>

@interface spacepirate : enemyBase

-(instancetype)initWithPosition:(CGPoint)pos onWall:(BOOL)onwall withOrientation:(BOOL)orientation;

@end
