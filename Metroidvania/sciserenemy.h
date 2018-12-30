//
//  sciserenemy.h
//  Metroidvania
//
//  Created by nick vancise on 5/30/18.
//

#import "enemyBase.h"

@interface sciserenemy : enemyBase

//@property (nonatomic,assign) int health;
@property (nonatomic,strong) SKSpriteNode *enemybullet1;
@property (nonatomic,strong) SKSpriteNode *enemybullet2;
-(instancetype)initWithPos:(CGPoint)sciserpos;

@end
