//
//  sciserenemy.h
//  SuperKoalio
//
//  Created by nick vancise on 5/30/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface sciserenemy : SKSpriteNode

@property (nonatomic,assign) int health;
@property (nonatomic,strong) SKSpriteNode *enemybullet1;
@property (nonatomic,strong) SKSpriteNode *enemybullet2;
-(instancetype)initWithPos:(CGPoint)sciserpos;

@end
