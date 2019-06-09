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
    SKAction*fire_anim;
}

-(id)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname=name;
    self = [super initWithImageNamed:weakname];
    if (self != nil) {
        self.playervelocity = CGPointMake(0.0, 0.0);
        self.health=100;
        _gravity=CGPointMake(0.0, -450.0);
        _forewardMove=CGPointMake(860.0, 0.0);
        _backwardMove=CGPointMake(-860.0, 0.0);
        _jumpMove=CGPointMake(0.0, 253.0);
        _minmovement=CGPointMake(-190.0, -255.0);
        _maxmovement=CGPointMake(190.0, 250.0);
        self.currentBulletRange=180/*220*/;
        self.currentBulletDamage=1;
        self.currentBulletType=@"default";//types available, default, plasma, chargereg, charge
        self.chargebeamenabled=NO;
        self.chargebeamactive=NO;
        self.lockmovement=NO;
        
        __weak Player*weakself=self;
        SKTextureAtlas *samusregsuit=[SKTextureAtlas atlasNamed:@"Samusregsuit"];
        self.xScale=0.75;
        self.yScale=0.75;
        
        //damage related items
        self.plyrrecievingdmg=NO;
        self.plyrdmgwaitlock=[SKAction sequence:@[[SKAction waitForDuration:3.0],[SKAction runBlock:^{weakself.plyrrecievingdmg=NO;}]]];
        self.damageaction=[SKAction sequence:@[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.7 duration:0.1],[SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]]];
        self.meleedelayac=[SKAction sequence:@[[SKAction runBlock:^{weakself.meleedelay=YES;}],[SKAction waitForDuration:1.2],[SKAction runBlock:^{weakself.meleedelay=NO;}]]];
        
        //case for jumping to stay jumping until on ground
        SKAction *jmpblk=[SKAction runBlock:^{/*NSLog(@"checkingjmpblk");*/
            if(weakself.onGround && !weakself.shouldJump){
            if(weakself.goForeward)
                [weakself runAction:[SKAction repeatActionForever:weakself.runAnimation] withKey:@"runf"];
            else if(weakself.goBackward)
                [weakself runAction:[SKAction repeatActionForever:weakself.runBackwardsAnimation] withKey:@"runb"];
            [weakself removeActionForKey:@"jmpblk"];}}];
       
        self.jmptomfmbcheck=[SKAction sequence:@[[SKAction waitForDuration:0.1],jmpblk]];
        
        self.forwardtrack=YES;
        self.backwardtrack=NO;
        
        //melee actions
        self.meleeinaction=NO;
        self.meleedelay=NO; //this variable locks melee to 1 hit every 1.2 sec
        SKTextureAtlas *projectiles=[SKTextureAtlas atlasNamed:@"projectiles"];
        self.meleeweapon=[SKSpriteNode spriteNodeWithTexture:[projectiles textureNamed:@"samusmeleeright1.png"]];
        self.meleeweapon.position=CGPointMake(16,4);
        self.meleeweapon.alpha=0;
        self.meleeweapon.zPosition=self.zPosition+1;
        SKAction *meleeanimatemove=[SKAction group:@[[SKAction animateWithTextures:@[[projectiles textureNamed:@"samusmeleeright1.png"],[projectiles textureNamed:@"samusmeleeright2.png"],[projectiles textureNamed:@"samusmeleeright3.png"],[projectiles textureNamed:@"samusmeleeright4.png"]] timePerFrame:0.14 resize:YES restore:NO],[SKAction sequence:@[[SKAction waitForDuration:0.31],[SKAction moveBy:CGVectorMake(5.5,16) duration:0.18],[SKAction waitForDuration:0.1],[SKAction setTexture:[projectiles textureNamed:@"samusmeleeright1.png"] resize:YES],[SKAction moveBy:CGVectorMake(-5.5,-16) duration:0.04]]]]];
        
        SKAction *playermeleeanimate=[SKAction sequence:@[[SKAction waitForDuration:0.21],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_meleer1.png"]/*,[samusregsuit textureNamed:@"samus_meleer2.png"]*/] timePerFrame:0.23 resize:YES restore:YES],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_meleer2.png"]] timePerFrame:0.16 resize:YES restore:YES]]];
        __weak SKSpriteNode *weakmeleeweapon=self.meleeweapon;
        
        SKAction *meleeblk=[SKAction runBlock:^{[weakmeleeweapon runAction:meleeanimatemove];
            [weakself runAction:playermeleeanimate];}];
        SKAction *meleedelay=[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:0.03],meleeblk,[SKAction waitForDuration:0.78],[SKAction fadeAlphaTo:0 duration:0.1],[SKAction runBlock:^{[weakself removeAllChildren];weakself.meleeinaction=NO;}]]];
        meleedelay.timingMode=SKActionTimingEaseOut;
        
        SKAction *meleeanimatemovemirror=[SKAction group:@[[SKAction animateWithTextures:@[[projectiles textureNamed:@"samusmeleeright1.png"],[projectiles textureNamed:@"samusmeleeright2.png"],[projectiles textureNamed:@"samusmeleeright3.png"],[projectiles textureNamed:@"samusmeleeright4.png"]] timePerFrame:0.14 resize:YES restore:NO],[SKAction sequence:@[[SKAction waitForDuration:0.31],[SKAction moveBy:CGVectorMake(-5.5,16) duration:0.18],[SKAction waitForDuration:0.1],[SKAction setTexture:[projectiles textureNamed:@"samusmeleeright1.png"] resize:YES],[SKAction moveBy:CGVectorMake(5.5,-16) duration:0.04]]]] ];
        
        SKAction *playermeleeanimatemirror=[SKAction sequence:@[[SKAction waitForDuration:0.21],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_meleel1.png"]/*,[samusregsuit textureNamed:@"samus_meleel2.png"]*/] timePerFrame:0.23 resize:YES restore:YES],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_meleel2.png"]] timePerFrame:0.16 resize:YES restore:YES]]];
        
        SKAction *meleeblkmirror=[SKAction runBlock:^{[weakmeleeweapon runAction:meleeanimatemovemirror];
            [weakself runAction:playermeleeanimatemirror];}];
        SKAction *meleedelaymirror=[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:0.03],meleeblkmirror,[SKAction waitForDuration:0.78],[SKAction fadeAlphaTo:0 duration:0.1],[SKAction runBlock:^{[weakself removeAllChildren];weakself.meleeinaction=NO;[weakmeleeweapon setXScale:1];weakmeleeweapon.position=CGPointMake(16,4);}]]];
        meleeblkmirror.timingMode=SKActionTimingEaseOut;
        
        SKAction*charging_lower=[SKAction animateWithTextures:@[[projectiles textureNamed:@"charging_lower1_3.png"],[projectiles textureNamed:@"charging_lower2_4_8.png"],[projectiles textureNamed:@"charging_lower1_3.png"],[projectiles textureNamed:@"charging_lower2_4_8.png"],[projectiles textureNamed:@"charging_lower5_7_10.png"],[projectiles textureNamed:@"charging_lower6.png"],[projectiles textureNamed:@"charging_lower5_7_10.png"],[projectiles textureNamed:@"charging_lower2_4_8.png"],[projectiles textureNamed:@"charging_lower9_11_13.png"],[projectiles textureNamed:@"charging_lower5_7_10.png"],[projectiles textureNamed:@"charging_lower9_11_13.png"],[projectiles textureNamed:@"charging_lower12.png"],[projectiles textureNamed:@"charging_lower9_11_13.png"]] timePerFrame:0.08 resize:YES restore:NO];
        SKAction*charging_upper=[SKAction animateWithTextures:@[[projectiles textureNamed:@"charging_upper1.png"],[projectiles textureNamed:@"charging_upper2.png"],[projectiles textureNamed:@"charging_upper3.png"],[projectiles textureNamed:@"charging_upper4.png"]] timePerFrame:0.08 resize:YES restore:NO];
        SKAction*ready_lower=[SKAction animateWithTextures:@[[projectiles textureNamed:@"ready_lower1.png"],[projectiles textureNamed:@"ready_lower2.png"],[projectiles textureNamed:@"ready_lower3.png"],[projectiles textureNamed:@"ready_lower4.png"]] timePerFrame:0.08 resize:YES restore:NO];
        SKAction*ready_upper=[SKAction animateWithTextures:@[[projectiles textureNamed:@"ready_upper1.png"],[projectiles textureNamed:@"ready_upper2.png"],[projectiles textureNamed:@"ready_upper3.png"],[projectiles textureNamed:@"ready_upper4.png"],[projectiles textureNamed:@"ready_upper5.png"]] timePerFrame:0.04 resize:YES restore:NO];
        fire_anim=[SKAction animateWithTextures:@[[projectiles textureNamed:@"charge_flame1.png"],[projectiles textureNamed:@"charge_flame2.png"],[projectiles textureNamed:@"charge_flame3.png"],[projectiles textureNamed:@"charge_flame4.png"],[projectiles textureNamed:@"charge_flame5.png"]] timePerFrame:0.05 resize:YES restore:NO];
        self.lower=[SKSpriteNode spriteNodeWithTexture:[projectiles textureNamed:@"charging_lower_1_3.png"]];
        self.lower.zPosition=self.zPosition+1;
        self.upper=[SKSpriteNode spriteNodeWithTexture:[projectiles textureNamed:@"charging_upper1.png"]];
        self.upper.zPosition=self.zPosition+1;
        self.flame=[SKSpriteNode spriteNodeWithTexture:[projectiles textureNamed:@"charge_flame1.png"]];
        self.flame.zPosition=self.zPosition+1;
        SKAction*charge_blk=[SKAction runBlock:^{
            weakself.chargebeamactive=YES;//switch to active here pair the other with active charge beam
            weakself.lower.position=weakself.forwardtrack ? CGPointMake(12,4):CGPointMake(-12, 4);
            weakself.upper.position=weakself.forwardtrack ? CGPointMake(12,4):CGPointMake(-12, 4);
            [weakself addChild:weakself.lower];
            [weakself addChild:weakself.upper];
            [weakself.lower runAction:charging_lower completion:^{
                [weakself.upper removeActionForKey:@"chgupp"];
                [weakself.upper runAction:[SKAction repeatActionForever:ready_upper]];
                [weakself.lower runAction:[SKAction repeatActionForever:ready_lower]];
            }];
            [weakself.upper runAction:[SKAction repeatActionForever:charging_upper] withKey:@"chgupp"];
        }];
        SKAction*chargeini=[SKAction runBlock:^{
            [weakself runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction colorizeWithColor:[SKColor purpleColor] colorBlendFactor:0.7 duration:0.1],[SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]]]] withKey:@"chgini"];
        }];
        
        self.chargebeamtimer=[SKAction sequence:@[[SKAction group:@[[SKAction waitForDuration:2.0],[SKAction sequence:@[[SKAction waitForDuration:0.9],[SKAction group:@[charge_blk,chargeini]]]]]],[SKAction runBlock:^{[weakself switchbeamto:@"charge"];weakself.chargebeamrunning=YES;
            [weakself removeActionForKey:@"chgini"];
            [weakself runAction:[SKAction repeatActionForever:weakself.damageaction] withKey:@"chgflash"];}]]];//fix timing
        
        self.meleeactionright=[SKAction runBlock:^{if(!weakself.meleeinaction){
            weakself.meleeinaction=YES;
            if(weakself.forwardtrack){
            //NSLog(@"meleeactionright");
            [weakself addChild:weakmeleeweapon];
            [weakmeleeweapon runAction:meleedelay];
            [weakself runAction:[SKAction moveBy:CGVectorMake(20,0) duration:0.3]];
            }
            else if(weakself.backwardtrack){
            //NSLog(@"meleeactionleft");
            weakmeleeweapon.position=CGPointMake(-16,4);
            [weakmeleeweapon setXScale:-1];
            [weakself addChild:weakmeleeweapon];
            [weakmeleeweapon runAction:meleedelaymirror];
            [weakself runAction:[SKAction moveBy:CGVectorMake(-20,0) duration:0.3]];
            }
        }
        }];
        
        
        self.backwards=[samusregsuit textureNamed:@"samus_standb.png"];
        self.forewards=[samusregsuit textureNamed:@"samus_standf.png"];
        
        NSArray *runarray=@[[samusregsuit textureNamed:@"samus_runf1.png"],[samusregsuit textureNamed:@"samus_runf2.png"],[samusregsuit textureNamed:@"samus_runf5.png"],[samusregsuit textureNamed:@"samus_runf3.png"],[samusregsuit textureNamed:@"samus_runf4.png"],[samusregsuit textureNamed:@"samus_runf7.png"],[samusregsuit textureNamed:@"samus_runf6.png"],[samusregsuit textureNamed:@"samus_runf8.png"],[samusregsuit textureNamed:@"samus_runf9.png"],[samusregsuit textureNamed:@"samus_runf10.png"]];
        
        NSArray *runbackwardsarray=@[[samusregsuit textureNamed:@"samus_runb1.png"],[samusregsuit textureNamed:@"samus_runb2.png"],[samusregsuit textureNamed:@"samus_runb3.png"],[samusregsuit textureNamed:@"samus_runb4.png"],[samusregsuit textureNamed:@"samus_runb5.png"],[samusregsuit textureNamed:@"samus_runb6.png"],[samusregsuit textureNamed:@"samus_runb7.png"],[samusregsuit textureNamed:@"samus_runb8.png"],[samusregsuit textureNamed:@"samus_runb9.png"],[samusregsuit textureNamed:@"samus_runb10.png"]];
        
       // NSArray *jumpforwardsstartarray=@[[samusregsuit textureNamed:@"samus_jumpr1.png"],[samusregsuit textureNamed:@"samus_jumpr2.png"]];
        NSArray *jumpforewardsarray=@[[samusregsuit textureNamed:@"samus_jumpr3.png"],[samusregsuit textureNamed:@"samus_jumpr4.png"],[samusregsuit textureNamed:@"samus_jumpr5.png"],[samusregsuit textureNamed:@"samus_jumpr6.png"],[samusregsuit textureNamed:@"samus_jumpr7.png"],[samusregsuit textureNamed:@"samus_jumpr8.png"],[samusregsuit textureNamed:@"samus_jumpr9.png"],[samusregsuit textureNamed:@"samus_jumpr10.png"]];
        
       // NSArray *jumpbackwardsstartarray=@[[samusregsuit textureNamed:@"samus_jumpb1.png"],[samusregsuit textureNamed:@"samus_jumpb2.png"]];
        NSArray *jumpbackwardsarray=@[[samusregsuit textureNamed:@"samus_jumpb3.png"],[samusregsuit textureNamed:@"samus_jumpb4.png"],[samusregsuit textureNamed:@"samus_jumpb5.png"],[samusregsuit textureNamed:@"samus_jumpb6.png"],[samusregsuit textureNamed:@"samus_jumpb7.png"],[samusregsuit textureNamed:@"samus_jumpb8.png"],[samusregsuit textureNamed:@"samus_jumpb9.png"],[samusregsuit textureNamed:@"samus_jumpb10.png"]];
        
        NSArray *travelthruportalarray=@[[samusregsuit textureNamed:@"samus_travel1.png"],[samusregsuit textureNamed:@"samus_travel2.png"],[samusregsuit textureNamed:@"samus_travel3.png"],[samusregsuit textureNamed:@"samus_travel4.png"],[samusregsuit textureNamed:@"samus_travel5.png"],[samusregsuit textureNamed:@"samus_travel6.png"],[samusregsuit textureNamed:@"samus_travel7.png"],[samusregsuit textureNamed:@"samus_travel8.png"],[samusregsuit textureNamed:@"samus_travel9.png"],[samusregsuit textureNamed:@"samus_travel10.png"]];
        
        
        self.runAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:runarray timePerFrame:0.07 resize:YES restore:NO]];
        self.runBackwardsAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:runbackwardsarray timePerFrame:0.07 resize:YES restore:NO]];
        self.jumpForewardsAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:jumpforewardsarray timePerFrame:0.04 resize:YES restore:NO]];
        self.jumpBackwardsAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:jumpbackwardsarray timePerFrame:0.04 resize:YES restore:NO]];
        self.enterfromportalAnimation=[SKAction sequence:@[[SKAction animateWithTextures:travelthruportalarray timePerFrame:0.2],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_turnr1.png"],[samusregsuit textureNamed:@"samus_turnr2.png"],[samusregsuit textureNamed:@"samus_turnr3.png"]] timePerFrame:0.1 resize:NO restore:NO]]];
        self.travelthruportalAnimation=[SKAction sequence:@[[SKAction animateWithTextures:travelthruportalarray timePerFrame:0.2 resize:YES restore:NO],[SKAction group:@[[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samusfade.png"]] timePerFrame:1.5 resize:YES restore:NO],[SKAction fadeOutWithDuration:1.4]]]]];
    
    }
    
    
    return self;
}


-(void)update:(NSTimeInterval)delta{
    CGPoint gravitymove=CGPointMultiplyScalar(_gravity, delta);
    
    self.playervelocity=CGPointAdd(self.playervelocity,gravitymove);
    
    CGPoint forewardStep=CGPointMultiplyScalar(_forewardMove, delta);
    CGPoint backwardStep=CGPointMultiplyScalar(_backwardMove, delta);
    
    if (self.shouldJump)
       self.playervelocity=CGPointMake(self.playervelocity.x*0.84, self.playervelocity.y); //decreases horizontal movement for jmp
    else if(self.goForeward || self.goBackward){
        self.playervelocity=CGPointMake(self.playervelocity.x*0.85, self.playervelocity.y);//same for fwd&bkwd
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
    
    if(!self.lockmovement)
        self.desiredPosition=CGPointAdd(self.position, velocitymove);
}



-(CGRect)collisionBoundingBox{
    CGRect boundingBox = self.frame;
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingBox, diff.x, diff.y);
}

-(CGRect)meleeBoundingBoxNormalized{
    return CGRectMake(self.meleeweapon.frame.origin.x+self.frame.origin.x, self.meleeweapon.frame.origin.y+self.frame.origin.y, self.meleeweapon.frame.size.width, self.meleeweapon.frame.size.height);
}

-(void)removeMovementAnims{
    [self removeActionForKey:@"jmpblk"]; //these actions are the only ones possibly needing to be removed
    [self removeActionForKey:@"runf"];
    [self removeActionForKey:@"runb"];
    [self removeActionForKey:@"jmpf"];
    [self removeActionForKey:@"jmpb"];
    [self removeActionForKey:@"chargeT"];
}

-(void)resetTex{
    if(self.forwardtrack)
        [self runAction:[SKAction setTexture:self.forewards resize:YES]];
    else if(self.backwardtrack)
        [self runAction:[SKAction setTexture:self.backwards resize:YES]];
}

-(void)switchbeamto:(NSString *)to{
    self.currentBulletType=to;
    
    if([to isEqualToString:@"chargereg"]){//dmg or range does not change for charge, that must be done dynamically and then reverted
        self.currentBulletRange=220;
        self.currentBulletDamage=2;
    }
    else if([to isEqualToString:@"charge"]){
        self.currentBulletRange=250;
        self.currentBulletDamage=20;
    }
    else if([to isEqualToString:@"plasma"]){
        self.currentBulletRange=235;
        self.currentBulletDamage=3;
    }
    //need to work out how to swich damage of charge on demand
}

-(void)removeChargeSpr{
    [self removeActionForKey:@"chargeT"];
    [self removeActionForKey:@"chgini"];
    [self.upper  removeAllActions];
    [self.upper removeFromParent];
    [self.lower removeAllActions];
    [self.lower removeFromParent];
    [self runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]];
    if(self.chargebeamrunning){
        self.chargebeamrunning=NO;
        [self removeActionForKey:@"chgflash"];
        self.flame.position=self.forwardtrack ? CGPointMake(12,2):CGPointMake(-12,2);
        self.flame.xScale=self.forwardtrack ? -1:1;
        [self addChild:self.flame];
        __weak SKSpriteNode*weakflame=self.flame;
        [self.flame runAction:fire_anim completion:^{[weakflame removeFromParent];[weakflame removeAllActions];}];
    }
}

/*-(void)dealloc{
 NSLog(@"player deallocation");
 }*/




@end
