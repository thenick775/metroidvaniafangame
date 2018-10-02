//
//  Player.h
//  Metroidvania
//
//  Created by Nick VanCise

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property (nonatomic,assign) CGPoint playervelocity;
@property (nonatomic,assign) CGPoint desiredPosition;
@property (nonatomic,assign) BOOL onGround;
@property (nonatomic,assign) BOOL shouldJump;
@property (nonatomic,assign) BOOL goForeward;
@property (nonatomic,assign) BOOL goBackward;
//@property (nonatomic,assign) BOOL fireProjectile;
@property (nonatomic,assign) int health;
@property (nonatomic,strong) SKAction *standAnimation;
@property (nonatomic,strong) SKAction *standbackwardsAnimation;
@property (nonatomic,strong) SKAction *runAnimation;
@property (nonatomic,strong) SKAction *runBackwardsAnimation;
@property (nonatomic,strong) SKAction *jumpForewardsAnimation;
@property (nonatomic,strong) SKAction *jumpBackwardsAnimation;
@property (nonatomic,strong) SKAction *travelthruportalAnimation;
@property (nonatomic,strong) SKTexture *backwards;
@property (nonatomic,strong) SKTexture *forewards;
@property (nonatomic,assign) BOOL plyrrecievingdmg;
@property (nonatomic,strong) SKAction *plyrdmgwaitlock;
@property (nonatomic,assign) BOOL meleedelay;
@property (nonatomic,strong) SKAction *damageaction;
@property (nonatomic,strong) SKAction *jmptomfmbcheck;
@property (nonatomic,strong) SKAction *meleeactionright;
@property (nonatomic,strong) SKSpriteNode *meleeweapon;
@property (nonatomic,assign) BOOL meleeinaction;
@property (nonatomic,assign) BOOL forwardtrack;  //to tell which direction player is facing
@property (nonatomic,assign) BOOL backwardtrack;


-(void)update:(NSTimeInterval)delta;
-(CGRect)collisionBoundingBox;

@end
