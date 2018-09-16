//
//  Player.m
//  Metroidvania
//
// Created By Nick VanCise

#import "Player.h"
#import "SKTUtils.h"


@implementation Player{
    CGPoint _gravity;
    CGPoint _forewardMove;
    CGPoint _backwardMove;
    CGPoint _jumpMove;
    CGPoint _minmovement;
    CGPoint _maxmovement;
}

-(id)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname=name;
    if (self == [super initWithImageNamed:weakname]) {
        self.playervelocity = CGPointMake(0.0, 0.0);
        self.health=100;
        _gravity=CGPointMake(0.0, -450.0);
        _forewardMove=CGPointMake(800.0, 0.0);
        _backwardMove=CGPointMake(-800.0, 0.0);
        _jumpMove=CGPointMake(0.0, 253.0);
        _minmovement=CGPointMake(-120.0, -450.0);
        _maxmovement=CGPointMake(120.0, 250.0);
        
        __weak Player*weakself=self;
        SKTextureAtlas *animation=[SKTextureAtlas atlasNamed:@"Samus"];
        
        //damage related items
        self.plyrrecievingdmg=NO;
        NSArray *plrydmgarr=@[[SKAction waitForDuration:3.0],[SKAction runBlock:^{weakself.plyrrecievingdmg=NO;}]];
        self.plyrdmgwaitlock=[SKAction sequence:plrydmgarr];
        self.damageaction=[SKAction sequence:[NSArray arrayWithObjects:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.7 duration:0.1],[SKAction colorizeWithColorBlendFactor:0.0 duration:0.1], nil]];
        
        //case for jumping to stay jumping until on ground
        SKAction *jmpblk=[SKAction runBlock:^{/*NSLog(@"checkingjmpblk");*/if(weakself.onGround){
            if(weakself.goForeward)
            [weakself runAction:[SKAction repeatActionForever:weakself.runAnimation] withKey:@"runf"];
            else if(weakself.goBackward)
                [weakself runAction:[SKAction repeatActionForever:weakself.runBackwardsAnimation] withKey:@"runb"];
            [weakself removeActionForKey:@"jmpblk"];}}];
       
        self.jmptomfmbcheck=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.17],jmpblk, nil]];
        
        self.forwardtrack=YES;
        self.backwardtrack=NO;
        
        //melee actions
        self.meleeinaction=NO;
        self.meleedelay=NO;
        SKTextureAtlas *projectiles=[SKTextureAtlas atlasNamed:@"projectiles"];
        self.meleeweapon=[SKSpriteNode spriteNodeWithTexture:[projectiles textureNamed:@"samusmeleeright1.png"]];
        self.meleeweapon.position=CGPointMake(/*self.position.x+*/14, /*self.position.y+*/1);
        [self.meleeweapon setXScale:0.88];
        [self.meleeweapon setYScale:0.88];
        self.meleeweapon.alpha=0;
        //meleeweapon.anchorPoint=CGPointZero;
    
        SKAction *meleeanimatemove=[SKAction group:[NSArray arrayWithObjects:[SKAction animateWithTextures:[NSArray arrayWithObjects:[projectiles textureNamed:@"samusmeleeright1.png"],[projectiles textureNamed:@"samusmeleeright2.png"],[projectiles textureNamed:@"samusmeleeright3.png"],[projectiles textureNamed:@"samusmeleeright4.png"], nil] timePerFrame:0.18 resize:YES restore:YES],[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.41],[SKAction moveBy:CGVectorMake(2.5,13) duration:0.25],[SKAction moveBy:CGVectorMake(-2.5,-13) duration:0.01],nil]], nil] ];
        
        NSArray *plrymeleearr=@[[animation textureNamed:@"samusmelee1.png"],[animation textureNamed:@"samusmelee2.png"]];
        SKAction *playermeleeanimate=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.21],[SKAction animateWithTextures:plrymeleearr timePerFrame:0.24 resize:YES restore:YES], nil]];
        __weak SKSpriteNode *weakmeleeweapon=self.meleeweapon;
        
        SKAction *meleeblk=[SKAction runBlock:^{[weakmeleeweapon runAction:meleeanimatemove];
            [weakself runAction:playermeleeanimate];}];
        SKAction *meleedelay=[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:1 duration:0.03],meleeblk,[SKAction waitForDuration:0.9],[SKAction fadeAlphaTo:0 duration:0.1],[SKAction runBlock:^{[weakself removeAllChildren];weakself.meleeinaction=NO;}], nil]];
       
        
        SKAction *meleeanimatemovemirror=[SKAction group:[NSArray arrayWithObjects:[SKAction animateWithTextures:[NSArray arrayWithObjects:[projectiles textureNamed:@"samusmeleeright1.png"],[projectiles textureNamed:@"samusmeleeright2.png"],[projectiles textureNamed:@"samusmeleeright3.png"],[projectiles textureNamed:@"samusmeleeright4.png"], nil] timePerFrame:0.18 resize:YES restore:YES],[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.41],[SKAction moveBy:CGVectorMake(-2.5,13) duration:0.25],[SKAction moveBy:CGVectorMake(2.5,-13) duration:0.01],nil]], nil] ];
        
        NSArray *plrymeleearrmirror=@[[animation textureNamed:@"samusmelee1mirror.png"],[animation textureNamed:@"samusmelee2mirror.png"]];
        SKAction *playermeleeanimatemirror=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.21],[SKAction animateWithTextures:plrymeleearrmirror timePerFrame:0.24 resize:YES restore:YES], nil]];
        
        
        SKAction *meleeblkmirror=[SKAction runBlock:^{[weakmeleeweapon runAction:meleeanimatemovemirror];
            [weakself runAction:playermeleeanimatemirror];}];
        SKAction *meleedelaymirror=[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:1 duration:0.03],meleeblkmirror,[SKAction waitForDuration:0.9],[SKAction fadeAlphaTo:0 duration:0.1],[SKAction runBlock:^{[weakself removeAllChildren];weakself.meleeinaction=NO;[weakmeleeweapon setXScale:0.88];weakmeleeweapon.position=CGPointMake(14,1);}], nil]];
        
        
        self.meleeactionright=[SKAction runBlock:^{if(!weakself.meleeinaction){
            if(weakself.forwardtrack){
            //NSLog(@"meleeactionright");
            weakself.meleeinaction=YES;
            [weakself addChild:weakmeleeweapon];
            [weakmeleeweapon runAction:meleedelay];
            [weakself runAction:[SKAction moveBy:CGVectorMake(20,0) duration:0.3]];
            }
            else if(weakself.backwardtrack){
            //NSLog(@"meleeactionleft");
            weakself.meleeinaction=YES;
            weakmeleeweapon.position=CGPointMake(-14,1);
            [weakmeleeweapon setXScale:-0.88];
            [weakself addChild:weakmeleeweapon];
            [weakmeleeweapon runAction:meleedelaymirror];
            [weakself runAction:[SKAction moveBy:CGVectorMake(-20,0) duration:0.3]];
            }
        }
        }];
        
        
        self.backwards=[animation textureNamed:@"samus_fusion_backwards_orig3_v1.png"];
        self.forewards=[animation textureNamed:@"samus_fusion_walking3_v1.png"];
        
        NSArray *standArray=@[[animation textureNamed:@"samus_fusion_walking3_v1.png"],[animation textureNamed:@"samus_fusion_walking1_v2.png"],[animation textureNamed:@"samus_fusion_walking2_v2.png"]];
        
        NSArray*standingbackwardsarray=@[[animation textureNamed:@"samus_fusion_standingbackwards3_v1.png"],[animation textureNamed:@"samus_fusion_standingbackwards1_v2.png"],[animation textureNamed:@"samus_fusion_standingbackwards2_v2.png"]];
        
        NSArray *runarray=@[[animation textureNamed:@"samus_run1_v1_edited.png"],[animation textureNamed:@"samus_run2_v1_edited.png"],[animation textureNamed:@"samus_run3_v1_edited.png"],[animation textureNamed:@"samus_run4_v1_edited.png"],[animation textureNamed:@"samus_run5_v1_edited.png"],[animation textureNamed:@"samus_run6_v1_edited.png"],[animation textureNamed:@"samus_run7_v1_edited.png"],[animation textureNamed:@"samus_run8_v1_edited.png"],[animation textureNamed:@"samus_run9_v1_edited.png"],[animation textureNamed:@"samus_run10_v1_edited.png"]];
        
        NSArray *runbackwardsarray=@[[animation textureNamed:@"samus_runningbackwards1_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards2_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards3_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards4_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards5_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards6_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards7_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards8_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards9_v1_edited.png"],[animation textureNamed:@"samus_runningbackwards10_v1_edited.png"]];
       
        NSArray *jumpforewardsarray=@[[animation textureNamed:@"samus_jump2_v1_edited.png"],[animation textureNamed:@"samus_jump3_v1_edited.png"],[animation textureNamed:@"samus_jump4_v1_edited.png"],[animation textureNamed:@"samus_jump5_v1_edited.png"],[animation textureNamed:@"samus_jump6_v1_edited.png"],[animation textureNamed:@"samus_jump7_v1_edited.png"],[animation textureNamed:@"samus_jump8_v1_edited.png"],[animation textureNamed:@"samus_jump9_v1_edited.png"],[animation textureNamed:@"samus_jump10_v1_edited.png"]];
        
        NSArray *jumpbackwardsarray=@[[animation textureNamed:@"samus_jumpbackwards1_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards2_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards3_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards4_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards5_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards6_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards7_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards8_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards9_v1_edited.png"],[animation textureNamed:@"samus_jumpbackwards10_v1_edited.png"]];
        
        NSArray *travelthruportalarray=@[[animation textureNamed:@"travel1_edited.png"],[animation textureNamed:@"travel2_edited.png"],[animation textureNamed:@"travel3_edited.png"],[animation textureNamed:@"travel4_edited.png"],[animation textureNamed:@"travel5_edited.png"],[animation textureNamed:@"travel6_edited.png"],[animation textureNamed:@"travel7_edited.png"]];
        
        self.standAnimation=[SKAction animateWithTextures:standArray timePerFrame:(NSTimeInterval)0.40 resize:NO restore:NO];
        self.runAnimation=[SKAction animateWithTextures:runarray timePerFrame:0.075 resize:NO restore:NO];
        self.runBackwardsAnimation=[SKAction animateWithTextures:runbackwardsarray timePerFrame:0.075 resize:NO restore:NO];
        self.standbackwardsAnimation=[SKAction animateWithTextures:standingbackwardsarray timePerFrame:0.40 resize:NO restore:NO];
        self.jumpForewardsAnimation=[SKAction animateWithTextures:jumpforewardsarray timePerFrame:0.045 resize:NO restore:NO];
        self.jumpBackwardsAnimation=[SKAction animateWithTextures:jumpbackwardsarray timePerFrame:0.045 resize:NO restore:NO];
        self.travelthruportalAnimation=[SKAction animateWithTextures:travelthruportalarray timePerFrame:0.2];
    }
    
    
    return self;
}


-(void)update:(NSTimeInterval)delta{
    CGPoint gravitymove=CGPointMultiplyScalar(_gravity, delta);
    
    self.playervelocity=CGPointAdd(self.playervelocity,gravitymove);
    
    CGPoint forewardStep=CGPointMultiplyScalar(_forewardMove, delta);
    CGPoint backwardStep=CGPointMultiplyScalar(_backwardMove, delta);
    
    if (self.shouldJump)
       self.playervelocity=CGPointMake(self.playervelocity.x*0.98, self.playervelocity.y); //lets horizontall movement last longer if jumping due to onle 2% decrease in x velocity
    else if(self.goForeward || self.goBackward){
        self.playervelocity=CGPointMake(self.playervelocity.x*0.85, self.playervelocity.y);
    }
    else
    self.playervelocity=CGPointMake(self.playervelocity.x*0.80, self.playervelocity.y);  //horizontal dampening force "reducing" horizontal movement each frame
    
    
    //using calculated step values
   
    if(self.shouldJump && self.onGround){
        self.playervelocity=CGPointAdd(self.playervelocity, _jumpMove);
    }
    if(self.goForeward){
        self.playervelocity=CGPointAdd(self.playervelocity, forewardStep);
         self.texture=self.forewards;
    }
    if(self.goBackward){
        self.playervelocity=CGPointAdd(self.playervelocity, backwardStep);
        self.texture=self.backwards;
    }
    
    
    
    self.playervelocity=CGPointMake(Clamp(self.playervelocity.x, _minmovement.x, _maxmovement.x), Clamp(self.playervelocity.y, _minmovement.y, _maxmovement.y));
    
    //NSLog(@"playervelocity: %@",NSStringFromCGPoint(self.playervelocity));
    
    CGPoint velocitymove=CGPointMultiplyScalar(self.playervelocity, delta);
    
    self.desiredPosition=CGPointAdd(self.position, velocitymove);
}



- (CGRect)collisionBoundingBox
{
    CGRect boundingBox = CGRectInset(self.frame,6,0);
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingBox, diff.x, diff.y);
}


/*-(void)dealloc{
 NSLog(@"player deallocation");
 }*/




@end
