//
//  spacepirate.h
//  Metroidvania
//
//  Created by nick vancise on 7/1/20.
//

#import "enemyBase.h"

@interface spacepirate : enemyBase

-(instancetype)initWithPosition:(CGPoint)pos onWall:(BOOL)onwall;

@end
