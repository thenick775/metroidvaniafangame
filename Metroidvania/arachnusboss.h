//
//  arachnusboss.h
//  Metroidvania
//
//  Created by nick vancise on 7/23/18.


#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface arachnusboss : SKSpriteNode

@property (nonatomic,assign) int health;
@property (nonatomic,assign) BOOL active;
@property (nonatomic,strong) SKSpriteNode *slashprojectile;
@property (nonatomic,strong) NSMutableArray *projectilesinaction;
@property (nonatomic,strong) SKLabelNode *healthlbl;

-(void)handleanimswithfocuspos:(CGFloat)focuspos;

@end
