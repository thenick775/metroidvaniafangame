//
//  choot.h
//  Metroidvania
//
//  Created by nick vancise on 5/20/19.
//

#import "enemyBase.h"

@interface choot : enemyBase


@property (nonatomic,assign) int orig_y;
@property(nonatomic,strong) NSMutableArray*projectilesInAction;
-(instancetype)initWithPos:(CGPoint)pos andDist:(int)dist andCount:(int)count andTime:(float)time Del:(float)del;
-(void)explode:(SKSpriteNode*)proj;

@end
