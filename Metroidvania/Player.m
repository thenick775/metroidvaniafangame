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
    self = [super initWithImageNamed:weakname];
    if (self != nil) {
        self.playervelocity = CGPointMake(0.0, 0.0);
        self.health=100;
        _gravity=CGPointMake(0.0, -450.0);
        _forewardMove=CGPointMake(800.0, 0.0);
        _backwardMove=CGPointMake(-800.0, 0.0);
        _jumpMove=CGPointMake(0.0, 253.0);
        _minmovement=CGPointMake(-150.0, -255.0);
        _maxmovement=CGPointMake(150.0, 250.0);
        
        __weak Player*weakself=self;
        SKTextureAtlas *samusregsuit=[SKTextureAtlas atlasNamed:@"Samusregsuit"];
        self.xScale=0.75;
        self.yScale=0.75;
        
        //damage related items
        self.plyrrecievingdmg=NO;
        self.plyrdmgwaitlock=[SKAction sequence:@[[SKAction waitForDuration:3.0],[SKAction runBlock:^{weakself.plyrrecievingdmg=NO;}]]];
        self.damageaction=[SKAction sequence:@[[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.7 duration:0.1],[SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]]];
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
        SKAction *meleeanimatemove=[SKAction group:@[[SKAction animateWithTextures:@[[projectiles textureNamed:@"samusmeleeright1.png"],[projectiles textureNamed:@"samusmeleeright2.png"],[projectiles textureNamed:@"samusmeleeright3.png"],[projectiles textureNamed:@"samusmeleeright4.png"]] timePerFrame:0.18 resize:YES restore:YES],[SKAction sequence:@[[SKAction waitForDuration:0.41],[SKAction moveBy:CGVectorMake(6,21) duration:0.2],[SKAction moveBy:CGVectorMake(-6,-21) duration:0.01]]]] ];
        
        SKAction *playermeleeanimate=[SKAction sequence:@[[SKAction waitForDuration:0.21],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_meleer1.png"],[samusregsuit textureNamed:@"samus_meleer2.png"]] timePerFrame:0.24 resize:YES restore:YES]]];
        __weak SKSpriteNode *weakmeleeweapon=self.meleeweapon;
        
        SKAction *meleeblk=[SKAction runBlock:^{[weakmeleeweapon runAction:meleeanimatemove];
            [weakself runAction:playermeleeanimate];}];
        SKAction *meleedelay=[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:0.03],meleeblk,[SKAction waitForDuration:0.9],[SKAction fadeAlphaTo:0 duration:0.1],[SKAction runBlock:^{[weakself removeAllChildren];weakself.meleeinaction=NO;}]]];
       
        
        SKAction *meleeanimatemovemirror=[SKAction group:@[[SKAction animateWithTextures:@[[projectiles textureNamed:@"samusmeleeright1.png"],[projectiles textureNamed:@"samusmeleeright2.png"],[projectiles textureNamed:@"samusmeleeright3.png"],[projectiles textureNamed:@"samusmeleeright4.png"]] timePerFrame:0.18 resize:YES restore:YES],[SKAction sequence:@[[SKAction waitForDuration:0.41],[SKAction moveBy:CGVectorMake(-6,21) duration:0.2],[SKAction moveBy:CGVectorMake(6,-21) duration:0.01]]]] ];
        
        SKAction *playermeleeanimatemirror=[SKAction sequence:@[[SKAction waitForDuration:0.21],[SKAction animateWithTextures:@[[samusregsuit textureNamed:@"samus_meleel1.png"],[samusregsuit textureNamed:@"samus_meleel2.png"]] timePerFrame:0.24 resize:YES restore:YES]]];
        
        SKAction *meleeblkmirror=[SKAction runBlock:^{[weakmeleeweapon runAction:meleeanimatemovemirror];
            [weakself runAction:playermeleeanimatemirror];}];
        SKAction *meleedelaymirror=[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:0.03],meleeblkmirror,[SKAction waitForDuration:0.9],[SKAction fadeAlphaTo:0 duration:0.1],[SKAction runBlock:^{[weakself removeAllChildren];weakself.meleeinaction=NO;[weakmeleeweapon setXScale:1];weakmeleeweapon.position=CGPointMake(16,4);}]]];
        
        
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
        
        
        self.runAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:runarray timePerFrame:0.075 resize:YES restore:NO]];
        self.runBackwardsAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:runbackwardsarray timePerFrame:0.075 resize:YES restore:NO]];
        self.jumpForewardsAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:jumpforewardsarray timePerFrame:0.045 resize:YES restore:NO]];
        self.jumpBackwardsAnimation=[SKAction repeatActionForever:[SKAction animateWithTextures:jumpbackwardsarray timePerFrame:0.045 resize:YES restore:NO]];
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
       self.playervelocity=CGPointMake(self.playervelocity.x*0.85, self.playervelocity.y); //makes horizontal movement last longer if jumping due to onle 2% decrease in x velocity
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



-(CGRect)collisionBoundingBox{
    CGRect boundingBox = self.frame;
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingBox, diff.x, diff.y);
}

-(CGRect)meleeBoundingBoxNormalized{
    return CGRectMake(self.meleeweapon.frame.origin.x+self.frame.origin.x, self.meleeweapon.frame.origin.y+self.frame.origin.y, self.meleeweapon.frame.size.width, self.meleeweapon.frame.size.height);
}

/*-(void)dealloc{
 NSLog(@"player deallocation");
 }*/




@end
