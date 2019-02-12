//
//  arachnusboss.m
//  Metroidvania
//
//  Created by nick vancise on 7/23/18.


#import "arachnusboss.h"
#import "SKTUtils.h"

@implementation arachnusboss{
    SKAction *_moveforeward;
    SKAction *_movebackward;
    SKAction *_fireattackleft;
    SKAction *_fireattackright;
    SKAction *_morphballattackright;
    SKAction *_morphballattackleft;
    SKAction *_slashattackleft;
    SKAction *_slashattackright;
    SKAction *_turnright;
    SKAction *_turnleft;
    SKAction *_recievedamageright;
    SKAction *_recievedamageleft;
    SKAction *_death;
    
    SKAction *_addfiretoparentmap;
    SKSpriteNode *_firesprite;
    SKSpriteNode *_firespritel;
    //CGPoint _prevcoorddist;
    GKRuleSystem*_arachnusrs;
    NSArray *_rightattacks;
    NSArray *_leftattacks;
    GKLinearCongruentialRandomSource*_rndsrc;
    SKAction*_prevac;
}

-(instancetype)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname=name;
    self=[super initWithImageNamed:weakname];
    if(self!=nil){
        self.health=140;//5;//for testing
        self.active=NO;
        
        SKTextureAtlas *arachnustextures=[SKTextureAtlas atlasNamed:@"Arachnus"];
        __weak arachnusboss*weakself=self;
        self.projectilesinaction=[[NSMutableArray alloc]init];
        
        //position constraints
        SKConstraint*xconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:3488 upperLimit:4208]];
        xconst.referenceNode=self.parent;
        self.constraints=@[xconst];
        
        //morphball animations
        NSArray *morphtoballrighttex=@[[arachnustextures textureNamed:@"toball_1.png"],[arachnustextures textureNamed:@"toball_2.png"],[arachnustextures textureNamed:@"toball_3.png"],[arachnustextures textureNamed:@"toball_4.png"]];
        SKAction *morphtoballrightanim=[SKAction animateWithTextures:morphtoballrighttex timePerFrame:0.1 resize:YES restore:NO];
        NSArray *morphtoballlefttex=@[[arachnustextures textureNamed:@"ltoball_1.png"],[arachnustextures textureNamed:@"ltoball_2.png"],[arachnustextures textureNamed:@"ltoball_3.png"],[arachnustextures textureNamed:@"ltoball_4.png"]];
        SKAction *morphtoballleftanim=[SKAction animateWithTextures:morphtoballlefttex timePerFrame:0.1 resize:YES restore:NO];
        
        NSArray *ballrighttex=@[[arachnustextures textureNamed:@"ball_1.png"],[arachnustextures textureNamed:@"ball_2.png"],[arachnustextures textureNamed:@"ball_3.png"],[arachnustextures textureNamed:@"ball_4.png"]];
        SKAction *ballattackrightanim=[SKAction animateWithTextures:ballrighttex timePerFrame:0.04 resize:YES restore:NO];
        NSArray *balllefttex=@[[arachnustextures textureNamed:@"lball_1.png"],[arachnustextures textureNamed:@"lball_2.png"],[arachnustextures textureNamed:@"lball_3.png"],[arachnustextures textureNamed:@"lball_4.png"]];
        SKAction *ballattackleftanim=[SKAction animateWithTextures:balllefttex timePerFrame:0.04 resize:YES restore:NO];
        
        SKSpriteNode *dustball=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Dust1.png"]];
        SKAction *dustac=[SKAction repeatAction:[SKAction animateWithTextures:@[[arachnustextures textureNamed:@"Dust1.png"],[arachnustextures textureNamed:@"Dust2.png"],[arachnustextures textureNamed:@"Dust3.png"],[arachnustextures textureNamed:@"Dust4.png"]] timePerFrame:0.1 resize:NO restore:YES] count:6];
        dustball.position=CGPointMake(-10,-11);
        dustball.alpha=0.85;
        SKAction *dustactionright=[SKAction runBlock:^{dustball.position=CGPointMake(-10,-11);[weakself addChild:dustball];[dustball runAction:dustac completion:^{[dustball removeFromParent];}];}];
        SKAction *dustactionleft=[SKAction runBlock:^{dustball.position=CGPointMake(10,-11);[weakself addChild:dustball];[dustball runAction:dustac completion:^{[dustball removeFromParent];}];}];
      
        _morphballattackright=[SKAction sequence:@[morphtoballrightanim,[SKAction moveByX:0 y:-8 duration:0],[SKAction group:@[[SKAction repeatAction:ballattackrightanim count:15],dustactionright,[SKAction moveByX:360 y:0 duration:2.4]]],[SKAction moveByX:0 y:8 duration:0],[morphtoballrightanim reversedAction]]];
        _morphballattackleft=[SKAction sequence:@[morphtoballleftanim,[SKAction moveByX:0 y:-8 duration:0],[SKAction group:@[[SKAction repeatAction:ballattackleftanim count:15],dustactionleft,[SKAction moveByX:-360 y:0 duration:2.4]]],[SKAction moveByX:0 y:8 duration:0],[morphtoballleftanim reversedAction]]];
        
        //move f/b animations
        NSArray *moveforewardtex=@[[arachnustextures textureNamed:@"walk_1.png"],[arachnustextures textureNamed:@"walk_2.png"],[arachnustextures textureNamed:@"walk_3.png"],[arachnustextures textureNamed:@"walk_4.png"],[arachnustextures textureNamed:@"walk_5.png"],[arachnustextures textureNamed:@"walk_6.png"],[arachnustextures textureNamed:@"walk_7.png"],[arachnustextures textureNamed:@"walk_8.png"],[arachnustextures textureNamed:@"walk_9.png"],[arachnustextures textureNamed:@"walk_10.png"],[arachnustextures textureNamed:@"walk_11.png"],[arachnustextures textureNamed:@"walk_12.png"]];
        SKAction *moveforewardanim=[SKAction animateWithTextures:moveforewardtex timePerFrame:0.08 resize:YES restore:NO];
        NSArray *movebackwardtex=@[[arachnustextures textureNamed:@"lwalk_1.png"],[arachnustextures textureNamed:@"lwalk_2.png"],[arachnustextures textureNamed:@"lwalk_3.png"],[arachnustextures textureNamed:@"lwalk_4.png"],[arachnustextures textureNamed:@"lwalk_5.png"],[arachnustextures textureNamed:@"lwalk_6.png"],[arachnustextures textureNamed:@"lwalk_7.png"],[arachnustextures textureNamed:@"lwalk_8.png"],[arachnustextures textureNamed:@"lwalk_9.png"],[arachnustextures textureNamed:@"lwalk_10.png"],[arachnustextures textureNamed:@"lwalk_11.png"],[arachnustextures textureNamed:@"lwalk_12.png"]];
        SKAction *movebackwardanim=[SKAction animateWithTextures:movebackwardtex timePerFrame:0.08 resize:YES restore:NO];
        
        _moveforeward=[SKAction sequence:@[[SKAction group:@[[SKAction repeatAction:moveforewardanim count:3],[SKAction moveByX:150 y:0 duration:2.88]]]]];
        _movebackward=[SKAction sequence:@[[SKAction group:@[[SKAction repeatAction:movebackwardanim count:3],[SKAction moveByX:-150 y:0 duration:2.88]]]]];
        
        //fireattack animations
        NSArray *fireattackrighttex=@[[arachnustextures textureNamed:@"spitfire_1.png"],[arachnustextures textureNamed:@"spitfire_2.png"],[arachnustextures textureNamed:@"spitfire_3.png"],[arachnustextures textureNamed:@"spitfire_4.png"],[arachnustextures textureNamed:@"spitfire_5.png"]];
        SKAction *fireattackrightanim=[SKAction animateWithTextures:fireattackrighttex timePerFrame:0.14 resize:YES restore:NO];
        NSArray *fireattacklefttex=@[[arachnustextures textureNamed:@"lspitfire_1.png"],[arachnustextures textureNamed:@"lspitfire_2.png"],[arachnustextures textureNamed:@"lspitfire_3.png"],[arachnustextures textureNamed:@"lspitfire_4.png"],[arachnustextures textureNamed:@"lspitfire_5.png"]];
        SKAction *fireattackleftanim=[SKAction animateWithTextures:fireattacklefttex timePerFrame:0.14 resize:YES restore:NO];
        
        NSArray *fireburntex=@[[arachnustextures textureNamed:@"Fire1.png"],[arachnustextures textureNamed:@"Fire2.png"]];
        NSArray *fireendtex=@[[arachnustextures textureNamed:@"Fire3.png"],[arachnustextures textureNamed:@"Fire4.png"]];
        
        SKAction *fireburnanim=[SKAction animateWithTextures:fireburntex timePerFrame:0.1 resize:NO restore:YES];
        _firesprite=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
        _firesprite.position=CGPointMake(16,2);
        _firespritel=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
        _firespritel.position=CGPointMake(-16,2);
        SKAction *fireendanim=[SKAction animateWithTextures:fireendtex timePerFrame:0.1 resize:NO restore:NO];
        
        SKAction *addfiretoparentblk=[SKAction runBlock:^{
            __block CGPoint pointinlevel=[weakself convertPoint:CGPointMake(49,-24) toNode:weakself.parent];
            SKAction *blkac=[SKAction runBlock:^{
                SKSpriteNode*firecpy=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
                firecpy.position=pointinlevel;
                [weakself.projectilesinaction addObject:firecpy];
                [firecpy runAction:[SKAction repeatActionForever:fireburnanim]];
                pointinlevel=CGPointAdd(pointinlevel,CGPointMake(13,0));
                [weakself.parent addChild:firecpy];
                [firecpy runAction:[SKAction sequence:@[[SKAction waitForDuration:4.0],fireendanim,[SKAction runBlock:^{[firecpy removeFromParent];[weakself.projectilesinaction removeObject:firecpy];[firecpy removeAllActions];}]]]];
            }];
            [weakself runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:0.07],blkac]] count:13]];
        }];
        
        UIBezierPath *firepathright=[UIBezierPath bezierPath];
        [firepathright moveToPoint:CGPointZero];
        [firepathright addQuadCurveToPoint:CGPointMake(37,-26) controlPoint:CGPointMake(40,0)];
        __weak SKSpriteNode*weakfiresprite=_firesprite;
        SKAction *fireblk=[SKAction runBlock:^{[weakself addChild:weakfiresprite];[weakfiresprite runAction:[SKAction repeatActionForever:fireburnanim]];[weakfiresprite runAction:[SKAction followPath:firepathright.CGPath duration:0.4] completion:^{[weakself runAction:addfiretoparentblk];[weakfiresprite removeFromParent];weakfiresprite.position=CGPointMake(16,2);[weakfiresprite removeAllActions];}];}];
        SKAction *firespriteac=[SKAction sequence:@[[SKAction waitForDuration:0.52],fireblk]];
       
        _fireattackright=[SKAction sequence:@[[SKAction group:@[[SKAction moveByX:0 y:3 duration:0],fireattackrightanim,firespriteac]],[SKAction moveByX:0 y:-3 duration:0],[SKAction waitForDuration:0.15]]];
        
        //below is redifinition of addfiretoparentblk,fireblk,firespriteac so as to flip for left fireattack
        addfiretoparentblk=[SKAction runBlock:^{
            __block CGPoint pointinlevel=[weakself convertPoint:CGPointMake(-49,-24) toNode:weakself.parent];
            SKAction *blkac=[SKAction runBlock:^{
                SKSpriteNode*firecpy=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
                firecpy.position=pointinlevel;
                [weakself.projectilesinaction addObject:firecpy];
                [firecpy runAction:[SKAction repeatActionForever:fireburnanim]];
                pointinlevel=CGPointSubtract(pointinlevel,CGPointMake(13,0));
                [weakself.parent addChild:firecpy];
                [firecpy runAction:[SKAction sequence:@[[SKAction waitForDuration:4.0],fireendanim,[SKAction runBlock:^{[firecpy removeFromParent];[weakself.projectilesinaction removeObject:firecpy];[firecpy removeAllActions];}]]]];
            }];
            [weakself runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:0.07],blkac]] count:13]];
        }];
        UIBezierPath *firepathleft=[UIBezierPath bezierPath];
        [firepathleft moveToPoint:CGPointZero];
        [firepathleft addQuadCurveToPoint:CGPointMake(-37,-26) controlPoint:CGPointMake(-40,0)];
        __weak SKSpriteNode*weakfirespritel=_firespritel;
        weakfirespritel.position=CGPointMake(-16,2);
        fireblk=[SKAction runBlock:^{[weakself addChild:weakfirespritel];[weakfirespritel runAction:[SKAction repeatActionForever:fireburnanim]];[weakfirespritel runAction:[SKAction followPath:firepathleft.CGPath duration:0.4] completion:^{[weakself runAction:addfiretoparentblk];[weakfirespritel removeFromParent];weakfirespritel.position=CGPointMake(-16,2);[weakfirespritel removeAllActions];}];}];
        firespriteac=[SKAction sequence:@[[SKAction waitForDuration:0.52],fireblk]];
        
        _fireattackleft=[SKAction sequence:@[[SKAction group:@[[SKAction moveByX:0 y:3 duration:0],fireattackleftanim,firespriteac]],[SKAction moveByX:0 y:-3 duration:0],[SKAction waitForDuration:0.15]]];
        
        
        //slash animations
        NSArray *slashrightex=@[[arachnustextures textureNamed:@"slash_1.png"],[arachnustextures textureNamed:@"slash_2.png"],[arachnustextures textureNamed:@"slash_3.png"],[arachnustextures textureNamed:@"slash_4.png"],[arachnustextures textureNamed:@"slash_5.png"],[arachnustextures textureNamed:@"slash_6.png"],[arachnustextures textureNamed:@"slash_7.png"],[arachnustextures textureNamed:@"slash_8.png"],[arachnustextures textureNamed:@"slash_9.png"],[arachnustextures textureNamed:@"slash_10.png"],[arachnustextures textureNamed:@"slash_11.png"],[arachnustextures textureNamed:@"slash_12.png"],[arachnustextures textureNamed:@"slash_13.png"],[arachnustextures textureNamed:@"slash_14.png"],[arachnustextures textureNamed:@"slash_15.png"]];
        SKAction *slashrightanim=[SKAction animateWithTextures:slashrightex timePerFrame:0.09 resize:YES restore:NO];
        NSArray *slashlefttex=@[[arachnustextures textureNamed:@"lslash_1.png"],[arachnustextures textureNamed:@"lslash_2.png"],[arachnustextures textureNamed:@"lslash_3.png"],[arachnustextures textureNamed:@"lslash_4.png"],[arachnustextures textureNamed:@"lslash_5.png"],[arachnustextures textureNamed:@"lslash_6.png"],[arachnustextures textureNamed:@"lslash_7.png"],[arachnustextures textureNamed:@"lslash_8.png"],[arachnustextures textureNamed:@"lslash_9.png"],[arachnustextures textureNamed:@"lslash_10.png"],[arachnustextures textureNamed:@"lslash_11.png"],[arachnustextures textureNamed:@"lslash_12.png"],[arachnustextures textureNamed:@"lslash_13.png"],[arachnustextures textureNamed:@"lslash_14.png"],[arachnustextures textureNamed:@"lslash_15.png"]];
        SKAction *slashleftanim=[SKAction animateWithTextures:slashlefttex timePerFrame:0.09 resize:YES restore:NO];
        
        //initialize slash projectiles
        self.slashprojectile=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"arachnus_slashsingle.png"]];
        self.slashprojectile.position=CGPointMake(27,0);
        SKSpriteNode *slashprojectiletrail=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"arachnus_slashsingle.png"]];
        slashprojectiletrail.position=CGPointMake(-25,0);
        slashprojectiletrail.alpha=0.6;
        [self.slashprojectile addChild:slashprojectiletrail];
        SKAction *slashprojmove=[SKAction moveBy:CGVectorMake(470,0) duration:1.8];
        
        _slashattackright=[SKAction sequence:@[[SKAction group:@[slashrightanim,[SKAction sequence:@[[SKAction waitForDuration:1.17],[SKAction runBlock:^{CGPoint pointinlevel=[weakself convertPoint:CGPointMake(27,0) toNode:weakself.parent];
            SKSpriteNode*slashcpy=weakself.slashprojectile.copy;
            slashcpy.position=pointinlevel;
            [weakself.projectilesinaction addObject:slashcpy];
            [weakself.parent addChild:slashcpy];
            [slashcpy runAction:slashprojmove completion:^{[slashcpy removeFromParent];
                [weakself.projectilesinaction removeObject:slashcpy];
                slashcpy.position=CGPointMake(27,0);}];}]]]]]]];
        
        slashprojmove=[SKAction moveBy:CGVectorMake(-470,0) duration:1.8];
        
        _slashattackleft=[SKAction sequence:@[[SKAction group:@[slashleftanim,[SKAction sequence:@[[SKAction waitForDuration:1.17],[SKAction runBlock:^{CGPoint pointinlevel=[weakself convertPoint:CGPointMake(-27,0) toNode:weakself.parent];
            SKSpriteNode*slashcpy=weakself.slashprojectile.copy;
            [slashcpy setXScale:-1];
            slashcpy.position=pointinlevel;
            [weakself.projectilesinaction addObject:slashcpy];
            [weakself.parent addChild:slashcpy];
            [slashcpy runAction:slashprojmove completion:^{[slashcpy removeFromParent];
                [weakself.projectilesinaction removeObject:slashcpy];
                slashcpy.position=CGPointMake(-27,0);}];}]]]]]]];
        
        //turn animations
        NSArray *turnrighttex=@[[arachnustextures textureNamed:@"turn_4.png"],[arachnustextures textureNamed:@"turn_3.png"],[arachnustextures textureNamed:@"turn_2.png"],[arachnustextures textureNamed:@"turn_1.png"]];
        _turnleft=[SKAction animateWithTextures:turnrighttex timePerFrame:0.12 resize:YES restore:NO];
        NSArray *turnlefttex=@[[arachnustextures textureNamed:@"lturn_4.png"],[arachnustextures textureNamed:@"lturn_3.png"],[arachnustextures textureNamed:@"lturn_2.png"],[arachnustextures textureNamed:@"lturn_1.png"]];
        _turnright=[SKAction animateWithTextures:turnlefttex timePerFrame:0.12 resize:YES restore:NO];
        
        //recieve damage animations
        NSArray *recievedamagertex=@[[arachnustextures textureNamed:@"damage_scream_1.png"],[arachnustextures textureNamed:@"damage_scream_2.png"],[arachnustextures textureNamed:@"damage_scream_3.png"],[arachnustextures textureNamed:@"damage_scream_4.png"],[arachnustextures textureNamed:@"damage_scream_5.png"]];
        SKAction *recievedamagerightanim=[SKAction animateWithTextures:recievedamagertex timePerFrame:0.14 resize:YES restore:NO];
        NSArray *recievedamageltex=@[[arachnustextures textureNamed:@"ldamage_scream_1.png"],[arachnustextures textureNamed:@"ldamage_scream_2.png"],[arachnustextures textureNamed:@"ldamage_scream_3.png"],[arachnustextures textureNamed:@"ldamage_scream_4.png"],[arachnustextures textureNamed:@"ldamage_scream_5.png"]];
        SKAction *recievedamageleftanim=[SKAction animateWithTextures:recievedamageltex timePerFrame:0.14 resize:YES restore:NO];
        
        //rect for random fire points to be inside (dmg)
        CGRect firerect=CGRectInset(self.frame, 6, 2);
        SKAction *adddmgfire=[SKAction runBlock:^{
            CGPoint p=firerect.origin;
            p.x += arc4random_uniform((u_int32_t) CGRectGetWidth(firerect));
            p.y += arc4random_uniform((u_int32_t) CGRectGetHeight(firerect));
            SKSpriteNode *firecpy=weakfiresprite.copy;
            [firecpy removeAllActions];
            firecpy.position=p;
            [firecpy runAction:[SKAction sequence:@[fireburnanim,fireendanim]] completion:^{[firecpy removeFromParent];}];
            [weakself addChild:firecpy];
        }];
        
        _recievedamageright=[SKAction sequence:@[[SKAction moveByX:0 y:5 duration:0],[SKAction group:@[recievedamagerightanim,[SKAction repeatAction:adddmgfire count:3]]],[SKAction moveByX:0 y:-5 duration:0]]];
        _recievedamageleft=[SKAction sequence:@[[SKAction moveByX:0 y:5 duration:0],[SKAction group:@[recievedamageleftanim,[SKAction repeatAction:adddmgfire count:3]]],[SKAction moveByX:0 y:-5 duration:0]]];
        
        //death animation
        _death=[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[_recievedamageleft,_recievedamageright]] count:5],[SKAction fadeOutWithDuration:0.4],[SKAction runBlock:^{weakself.active=NO;[weakself removeAllChildren];[weakself removeAllActions];[weakself removeFromParent];}]]];
        
        _rightattacks=@[_moveforeward,_morphballattackright,_fireattackright,_slashattackright];
        _leftattacks=@[_movebackward,_morphballattackleft,_fireattackleft,_slashattackleft];
        
        //GKRulresystem & rule initializations
        _arachnusrs=[[GKRuleSystem alloc] init];
        //__weak GKRuleSystem*weakarachnusrs=_arachnusrs;
        _arachnusrs.state[@"orighealth"]=@(self.health);
        
        NSPredicate*turnrightpred=[NSPredicate predicateWithFormat:@"($coorddist>0 && $prevcoorddist<0)"];
        GKRule *turnrightrule=[GKRule ruleWithPredicate:turnrightpred assertingFact:@"turnright" grade:1.0];
        [_arachnusrs addRule:turnrightrule];
        NSPredicate*turnleftpred=[NSPredicate predicateWithFormat:@"($coorddist<0 && $prevcoorddist>0)"];
        GKRule *turnleftrule=[GKRule ruleWithPredicate:turnleftpred assertingFact:@"turnleft" grade:1.0];
        [_arachnusrs addRule:turnleftrule];
        _arachnusrs.state[@"prevcoorddist"]=@(0);//initialized to something
        
        NSPredicate*morphballattackleftpred=[NSPredicate predicateWithFormat:@"$coorddist < -250"];
        GKRule *morphballattackleftrule=[GKRule ruleWithPredicate:morphballattackleftpred assertingFact:@"ballattackleft" grade:1.0];
        [_arachnusrs addRule:morphballattackleftrule];

        NSPredicate*morphballattackrightpred=[NSPredicate predicateWithFormat:@"$coorddist > 250"];
        GKRule *morphballattackrightrule=[GKRule ruleWithPredicate:morphballattackrightpred assertingFact:@"ballattackright" grade:1.0];
        [_arachnusrs addRule:morphballattackrightrule];
        
        NSPredicate*slashattackleftpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@-150,@-249]];
        GKRule *slashattackleftrule=[GKRule ruleWithPredicate:slashattackleftpred assertingFact:@"slashleft" grade:1.0];
        [_arachnusrs addRule:slashattackleftrule];
        
        NSPredicate*slashattackrightpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@", @[@150,@249]];
        GKRule *slashattackrightrule=[GKRule ruleWithPredicate:slashattackrightpred assertingFact:@"slashright" grade:1.0];
        [_arachnusrs addRule:slashattackrightrule];
        
        NSPredicate*fireattackleftpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@-100,@-149]];
        GKRule *fireattackleftrule=[GKRule ruleWithPredicate:fireattackleftpred assertingFact:@"fireleft" grade:1.0];
        [_arachnusrs addRule:fireattackleftrule];
        
        NSPredicate*fireattackrightpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@100,@149]];
        GKRule *fireattackrightrule=[GKRule ruleWithPredicate:fireattackrightpred assertingFact:@"fireright" grade:1.0];
        [_arachnusrs addRule:fireattackrightrule];
        
        NSPredicate*movebackwardspred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@0,@-99]];
        GKRule *movebackwardsrule=[GKRule ruleWithPredicate:movebackwardspred assertingFact:@"moveback" grade:1.0];
        [_arachnusrs addRule:movebackwardsrule];
        
        NSPredicate*moveforwardspred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@1,@99]];
        GKRule *moveforwardsrule=[GKRule ruleWithPredicate:moveforwardspred assertingFact:@"moveforward" grade:1.0];
        [_arachnusrs addRule:moveforwardsrule];
        
        NSPredicate*dmgfwdpred=[NSPredicate predicateWithFormat:@"$currenthealth+20<=$prevhealth && $coorddist>0"];
        GKRule *dmgfwdrule=[GKRule ruleWithPredicate:dmgfwdpred assertingFact:@"damageright" grade:1.0];
        [_arachnusrs addRule:dmgfwdrule];
        
        NSPredicate*dmgbkwdpred=[NSPredicate predicateWithFormat:@"$currenthealth+20<=$prevhealth && $coorddist<0"];
        GKRule *dmgbkwdrule=[GKRule ruleWithPredicate:dmgbkwdpred assertingFact:@"damageleft" grade:1.0];
        [_arachnusrs addRule:dmgbkwdrule];
        _arachnusrs.state[@"currenthealth"]=@(self.health);
        _arachnusrs.state[@"prevhealth"]=@(self.health);
        
        NSPredicate*deathpred=[NSPredicate predicateWithFormat:@"$currenthealth<=0"];
        GKRule *deathrule=[GKRule ruleWithPredicate:deathpred assertingFact:@"death" grade:1.0];
        [_arachnusrs addRule:deathrule];
        
       /* NSPredicate*fleepred=[NSPredicate predicateWithFormat:@"$prevacflee==0 && $currenthealth<($orighealth/3) && $coorddist between %@",@[@-100,@100]];
        GKRule *fleerule=[GKRule ruleWithPredicate:fleepred assertingFact:@"flee" grade:1.0];
        _arachnusrs.state[@"prevacflee"]=@(NO);
        [_arachnusrs addRule:fleerule];*/
        
        
        _rndsrc=[[GKLinearCongruentialRandomSource alloc] init];
        self.healthlbl=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        self.healthlbl.text=[NSString stringWithFormat:@"Boss Health:%d",self.health];
        self.healthlbl.fontSize=15;
        self.healthlbl.zPosition=15;
        //self.healthlbl.position=CGPointMake(-176.3, 90);
    }
    
    return self;
}


-(void)handleanimswithfocuspos:(CGFloat)focuspos{
  
    if(![self hasActions]){//potential approach to handling one action at a time
       
        SKAction *actoexecute;
        _arachnusrs.state[@"coorddist"]=@(focuspos-self.position.x);
        _arachnusrs.state[@"currenthealth"]=@(self.health);
        //NSLog(@"coorddist:%f",[_arachnusrs.state[@"coorddist"] floatValue]);
        
        [_arachnusrs reset];
        [_arachnusrs evaluate];
        
        if([_arachnusrs gradeForFact:@"death"]==1){
            actoexecute=_death;
        }
        else if([_arachnusrs gradeForFact:@"damageright"]==1){
            _arachnusrs.state[@"prevhealth"]=@(self.health);
            actoexecute=_recievedamageright;
        }
        else if([_arachnusrs gradeForFact:@"damageleft"]==1){
            _arachnusrs.state[@"prevhealth"]=@(self.health);
            actoexecute=_recievedamageleft;
        }
        else if([_arachnusrs gradeForFact:@"turnright"]==1)
            actoexecute=_turnright;
        else if([_arachnusrs gradeForFact:@"turnleft"]==1)
            actoexecute=_turnleft;
        else if([_arachnusrs gradeForFact:@"ballattackleft"]==1)
            actoexecute=_morphballattackleft;
        else if([_arachnusrs gradeForFact:@"slashleft"]==1)
            actoexecute=_slashattackleft;
        else if([_arachnusrs gradeForFact:@"fireleft"]==1)
            actoexecute=_fireattackleft;
        else if([_arachnusrs gradeForFact:@"moveback"]==1)
            actoexecute=_movebackward;
        else if([_arachnusrs gradeForFact:@"ballattackright"]==1)
            actoexecute=_morphballattackright;
        else if([_arachnusrs gradeForFact:@"slashright"]==1)
            actoexecute=_slashattackright;
        else if([_arachnusrs gradeForFact:@"fireright"]==1)
            actoexecute=_fireattackright;
        else if([_arachnusrs gradeForFact:@"moveforward"]==1)
            actoexecute=_moveforeward;
        /*if([_arachnusrs gradeForFact:@"flee"]==1){
            NSLog(@"fleeing");
            if(_arachnusrs.state[@"coorddist"]<0)
                actoexecute=_morphballattackright;
            else
                actoexecute=_morphballattackleft;
            _arachnusrs.state[@"prevacflee"]=@(YES);
        }
        else{
            _arachnusrs.state[@"prevacflee"]=@(NO);
        }*/
        if(_prevac==actoexecute){
            if([_arachnusrs.state[@"coorddist"] floatValue]<0)
                actoexecute=[_leftattacks objectAtIndex:[_rndsrc nextIntWithUpperBound:_leftattacks.count]];
            else
                actoexecute=[_rightattacks objectAtIndex:[_rndsrc nextIntWithUpperBound:_rightattacks.count]];
        }
        if(actoexecute!=_death){
            [actoexecute setSpeed:(CGFloat)1.0+(CGFloat)([_arachnusrs.state[@"orighealth"] floatValue]-self.health)/(3*[_arachnusrs.state[@"orighealth"] floatValue])];
        }
        else
            [actoexecute setSpeed:(CGFloat)1.0];
        
        //NSLog(@"%f",(CGFloat)1.0+(CGFloat)([_arachnusrs.state[@"orighealth"] floatValue]-self.health)/(2.5*[_arachnusrs.state[@"orighealth"] floatValue]));
        
        _arachnusrs.state[@"prevcoorddist"]=_arachnusrs.state[@"coorddist"];
        
        [self runAction:actoexecute];
        _prevac=actoexecute;
    }

}



/*- (void)dealloc {
 NSLog(@"ARACHNUS DEALLOCATED");
 }*/


@end
