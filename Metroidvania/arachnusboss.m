//
//  arachnusboss.m
//  Metroidvania
//
//  Created by nick vancise on 7/23/18.


#import "arachnusboss.h"
#import "SKTUtils.h"

@implementation arachnusboss{
    SKAction *moveforeward;
    SKAction *movebackward;
    SKAction *fireattackleft;
    SKAction *fireattackright;
    SKAction *morphballattackright;
    SKAction *morphballattackleft;
    SKAction *slashattackleft;
    SKAction *slashattackright;
    SKAction *turnright;
    SKAction *turnleft;
    SKAction *recievedamageright;
    SKAction *recievedamageleft;
    SKAction *death;
    
    SKAction *addfiretoparentmap;
    SKSpriteNode *firesprite;
    SKSpriteNode *firespritel;
    CGPoint prevcoorddist;
    GKRuleSystem*arachnusrs;//
    NSArray *rightattacks;
    NSArray *leftattacks;
    GKLinearCongruentialRandomSource*rndsrc;//
    SKAction*prevac;
}

-(instancetype)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname=name;
    if(self == [super initWithImageNamed:weakname]){
        self.health=/*150;*/5;//for testing
        self.active=NO;
        
        SKTextureAtlas *arachnustextures=[SKTextureAtlas atlasNamed:@"Arachnus"];
        __weak arachnusboss*weakself=self;
        self.projectilesinaction=[[NSMutableArray alloc]init];
        
        //position constraints
        SKConstraint*xconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:3488 upperLimit:4208]];
        xconst.referenceNode=self.parent;
        self.constraints=[NSArray arrayWithObjects:xconst, nil];
        
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
        SKAction *dustac=[SKAction repeatAction:[SKAction animateWithTextures:[NSArray arrayWithObjects:[arachnustextures textureNamed:@"Dust1.png"],[arachnustextures textureNamed:@"Dust2.png"],[arachnustextures textureNamed:@"Dust3.png"],[arachnustextures textureNamed:@"Dust4.png"], nil] timePerFrame:0.1 resize:NO restore:YES] count:6];
        dustball.position=CGPointMake(-10,-11);
        dustball.alpha=0.85;
        SKAction *dustactionright=[SKAction runBlock:^{dustball.position=CGPointMake(-10,-11);[weakself addChild:dustball];[dustball runAction:dustac completion:^{[dustball removeFromParent];}];}];
        SKAction *dustactionleft=[SKAction runBlock:^{dustball.position=CGPointMake(10,-11);[weakself addChild:dustball];[dustball runAction:dustac completion:^{[dustball removeFromParent];}];}];
      
        morphballattackright=[SKAction sequence:[NSArray arrayWithObjects:morphtoballrightanim,[SKAction moveByX:0 y:-8 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:ballattackrightanim count:15],dustactionright,[SKAction moveByX:360 y:0 duration:2.4], nil]],[SKAction moveByX:0 y:8 duration:0],[morphtoballrightanim reversedAction], nil]];
        morphballattackleft=[SKAction sequence:[NSArray arrayWithObjects:morphtoballleftanim,[SKAction moveByX:0 y:-8 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:ballattackleftanim count:15],dustactionleft,[SKAction moveByX:-360 y:0 duration:2.4], nil]],[SKAction moveByX:0 y:8 duration:0],[morphtoballleftanim reversedAction], nil]];
        
        //move f/b animations
        NSArray *moveforewardtex=@[[arachnustextures textureNamed:@"walk_1.png"],[arachnustextures textureNamed:@"walk_2.png"],[arachnustextures textureNamed:@"walk_3.png"],[arachnustextures textureNamed:@"walk_4.png"],[arachnustextures textureNamed:@"walk_5.png"],[arachnustextures textureNamed:@"walk_6.png"],[arachnustextures textureNamed:@"walk_7.png"],[arachnustextures textureNamed:@"walk_8.png"],[arachnustextures textureNamed:@"walk_9.png"],[arachnustextures textureNamed:@"walk_10.png"],[arachnustextures textureNamed:@"walk_11.png"],[arachnustextures textureNamed:@"walk_12.png"]];
        SKAction *moveforewardanim=[SKAction animateWithTextures:moveforewardtex timePerFrame:0.08 resize:YES restore:NO];
        NSArray *movebackwardtex=@[[arachnustextures textureNamed:@"lwalk_1.png"],[arachnustextures textureNamed:@"lwalk_2.png"],[arachnustextures textureNamed:@"lwalk_3.png"],[arachnustextures textureNamed:@"lwalk_4.png"],[arachnustextures textureNamed:@"lwalk_5.png"],[arachnustextures textureNamed:@"lwalk_6.png"],[arachnustextures textureNamed:@"lwalk_7.png"],[arachnustextures textureNamed:@"lwalk_8.png"],[arachnustextures textureNamed:@"lwalk_9.png"],[arachnustextures textureNamed:@"lwalk_10.png"],[arachnustextures textureNamed:@"lwalk_11.png"],[arachnustextures textureNamed:@"lwalk_12.png"]];
        SKAction *movebackwardanim=[SKAction animateWithTextures:movebackwardtex timePerFrame:0.08 resize:YES restore:NO];
        
        moveforeward=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:moveforewardanim count:3],[SKAction moveByX:150 y:0 duration:2.88], nil]], nil]];
        movebackward=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:movebackwardanim count:3],[SKAction moveByX:-150 y:0 duration:2.88], nil]], nil]];
        
        //fireattack animations
        NSArray *fireattackrighttex=@[[arachnustextures textureNamed:@"spitfire_1.png"],[arachnustextures textureNamed:@"spitfire_2.png"],[arachnustextures textureNamed:@"spitfire_3.png"],[arachnustextures textureNamed:@"spitfire_4.png"],[arachnustextures textureNamed:@"spitfire_5.png"]];
        SKAction *fireattackrightanim=[SKAction animateWithTextures:fireattackrighttex timePerFrame:0.14 resize:YES restore:NO];
        NSArray *fireattacklefttex=@[[arachnustextures textureNamed:@"lspitfire_1.png"],[arachnustextures textureNamed:@"lspitfire_2.png"],[arachnustextures textureNamed:@"lspitfire_3.png"],[arachnustextures textureNamed:@"lspitfire_4.png"],[arachnustextures textureNamed:@"lspitfire_5.png"]];
        SKAction *fireattackleftanim=[SKAction animateWithTextures:fireattacklefttex timePerFrame:0.14 resize:YES restore:NO];
        
        NSArray *fireburntex=@[[arachnustextures textureNamed:@"Fire1.png"],[arachnustextures textureNamed:@"Fire2.png"]];
        NSArray *fireendtex=@[[arachnustextures textureNamed:@"Fire3.png"],[arachnustextures textureNamed:@"Fire4.png"]];
        
        SKAction *fireburnanim=[SKAction animateWithTextures:fireburntex timePerFrame:0.1 resize:NO restore:YES];
        firesprite=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
        firesprite.position=CGPointMake(16,2);
        firespritel=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
        firespritel.position=CGPointMake(-16,2);
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
                [firecpy runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:4.0],fireendanim,[SKAction runBlock:^{[firecpy removeFromParent];[weakself.projectilesinaction removeObject:firecpy];[firecpy removeAllActions];}], nil]]];
            }];
            [weakself runAction:[SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.07],blkac, nil]] count:13]];
        }];
        
        UIBezierPath *firepathright=[UIBezierPath bezierPath];
        [firepathright moveToPoint:CGPointZero];
        [firepathright addQuadCurveToPoint:CGPointMake(37,-26) controlPoint:CGPointMake(40,0)];
        __weak SKSpriteNode*weakfiresprite=firesprite;
        SKAction *fireblk=[SKAction runBlock:^{[weakself addChild:weakfiresprite];[weakfiresprite runAction:[SKAction repeatActionForever:fireburnanim]];[weakfiresprite runAction:[SKAction followPath:firepathright.CGPath duration:0.4] completion:^{[weakself runAction:addfiretoparentblk];[weakfiresprite removeFromParent];weakfiresprite.position=CGPointMake(16,2);[weakfiresprite removeAllActions];}];}];
        SKAction *firespriteac=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.52],fireblk, nil]];
       
        fireattackright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:[SKAction moveByX:0 y:3 duration:0],fireattackrightanim,firespriteac, nil]],[SKAction moveByX:0 y:-3 duration:0],[SKAction waitForDuration:0.15],nil]];
        
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
                [firecpy runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:4.0],fireendanim,[SKAction runBlock:^{[firecpy removeFromParent];[weakself.projectilesinaction removeObject:firecpy];[firecpy removeAllActions];}], nil]]];
            }];
            [weakself runAction:[SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.07],blkac, nil]] count:13]];
        }];
        UIBezierPath *firepathleft=[UIBezierPath bezierPath];
        [firepathleft moveToPoint:CGPointZero];
        [firepathleft addQuadCurveToPoint:CGPointMake(-37,-26) controlPoint:CGPointMake(-40,0)];
        __weak SKSpriteNode*weakfirespritel=firespritel;
        weakfirespritel.position=CGPointMake(-16,2);
        fireblk=[SKAction runBlock:^{[weakself addChild:weakfirespritel];[weakfirespritel runAction:[SKAction repeatActionForever:fireburnanim]];[weakfirespritel runAction:[SKAction followPath:firepathleft.CGPath duration:0.4] completion:^{[weakself runAction:addfiretoparentblk];[weakfirespritel removeFromParent];weakfirespritel.position=CGPointMake(-16,2);[weakfirespritel removeAllActions];}];}];
        firespriteac=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.52],fireblk, nil]];
        
        fireattackleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:[SKAction moveByX:0 y:3 duration:0],fireattackleftanim,firespriteac, nil]],[SKAction moveByX:0 y:-3 duration:0],[SKAction waitForDuration:0.15],nil]];
        
        
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
        SKAction *slashprojmove=[SKAction moveBy:CGVectorMake(460,0) duration:1.8];
        
        slashattackright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:slashrightanim,[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.17],[SKAction runBlock:^{CGPoint pointinlevel=[weakself convertPoint:CGPointMake(27,0) toNode:weakself.parent];
            SKSpriteNode*slashcpy=weakself.slashprojectile.copy;
            slashcpy.position=pointinlevel;
            [weakself.projectilesinaction addObject:slashcpy];
            [weakself.parent addChild:slashcpy];
            [slashcpy runAction:slashprojmove completion:^{[slashcpy removeFromParent];
                [weakself.projectilesinaction removeObject:slashcpy];
                slashcpy.position=CGPointMake(27,0);}];}], nil]],nil]], nil]];
        
        slashprojmove=[SKAction moveBy:CGVectorMake(-460,0) duration:1.8];
        
        slashattackleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:slashleftanim,[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.17],[SKAction runBlock:^{CGPoint pointinlevel=[weakself convertPoint:CGPointMake(-27,0) toNode:weakself.parent];
            SKSpriteNode*slashcpy=weakself.slashprojectile.copy;
            [slashcpy setXScale:-1];
            slashcpy.position=pointinlevel;
            [weakself.projectilesinaction addObject:slashcpy];
            [weakself.parent addChild:slashcpy];
            [slashcpy runAction:slashprojmove completion:^{[slashcpy removeFromParent];
                [weakself.projectilesinaction removeObject:slashcpy];
                slashcpy.position=CGPointMake(-27,0);}];}], nil]],nil]], nil]];
        
        //turn animations
        NSArray *turnrighttex=@[[arachnustextures textureNamed:@"turn_4.png"],[arachnustextures textureNamed:@"turn_3.png"],[arachnustextures textureNamed:@"turn_2.png"],[arachnustextures textureNamed:@"turn_1.png"]];
        turnleft=[SKAction animateWithTextures:turnrighttex timePerFrame:0.12 resize:YES restore:NO];
        NSArray *turnlefttex=@[[arachnustextures textureNamed:@"lturn_4.png"],[arachnustextures textureNamed:@"lturn_3.png"],[arachnustextures textureNamed:@"lturn_2.png"],[arachnustextures textureNamed:@"lturn_1.png"]];
        turnright=[SKAction animateWithTextures:turnlefttex timePerFrame:0.12 resize:YES restore:NO];
        
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
            [firecpy runAction:[SKAction sequence:[NSArray arrayWithObjects:fireburnanim,fireendanim, nil]] completion:^{[firecpy removeFromParent];}];
            [weakself addChild:firecpy];
        }];
        
        recievedamageright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction moveByX:0 y:5 duration:0],[SKAction group:[NSArray arrayWithObjects:recievedamagerightanim,[SKAction repeatAction:adddmgfire count:3], nil]],[SKAction moveByX:0 y:-5 duration:0], nil]];
        recievedamageleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction moveByX:0 y:5 duration:0],[SKAction group:[NSArray arrayWithObjects:recievedamageleftanim,[SKAction repeatAction:adddmgfire count:3], nil]],[SKAction moveByX:0 y:-5 duration:0], nil]];
        
        //death animation
        death=[SKAction sequence:[NSArray arrayWithObjects:[SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:recievedamageleft,recievedamageright, nil]] count:5],[SKAction fadeOutWithDuration:0.4],[SKAction runBlock:^{weakself.active=NO;[weakself removeAllChildren];[weakself removeAllActions];[weakself removeFromParent];}], nil]];
        
        rightattacks=[NSArray arrayWithObjects:moveforeward,morphballattackright,fireattackright,slashattackright, nil];
        leftattacks=[NSArray arrayWithObjects:movebackward,morphballattackleft,fireattackleft,slashattackleft, nil];
        
        //GKRulresystem & rule initializations
        arachnusrs=[[GKRuleSystem alloc] init];
        arachnusrs.state[@"orighealth"]=@(self.health);
        
        NSPredicate*turnrightpred=[NSPredicate predicateWithFormat:@"($coorddist>0 && $prevcoorddist<0)"];
        GKRule *turnrightrule=[GKRule ruleWithPredicate:turnrightpred assertingFact:@"turnright" grade:1.0];
        [arachnusrs addRule:turnrightrule];
        NSPredicate*turnleftpred=[NSPredicate predicateWithFormat:@"($coorddist<0 && $prevcoorddist>0)"];
        GKRule *turnleftrule=[GKRule ruleWithPredicate:turnleftpred assertingFact:@"turnleft" grade:1.0];
        [arachnusrs addRule:turnleftrule];
        arachnusrs.state[@"prevcoorddist"]=@(0);//initialized to something
        
        NSPredicate*morphballattackleftpred=[NSPredicate predicateWithFormat:@"$coorddist < -180"];
        GKRule *morphballattackleftrule=[GKRule ruleWithPredicate:morphballattackleftpred assertingFact:@"ballattackleft" grade:1.0];
        [arachnusrs addRule:morphballattackleftrule];
        
        NSPredicate*morphballattackrightpred=[NSPredicate predicateWithFormat:@"$coorddist > 180"];
        GKRule *morphballattackrightrule=[GKRule ruleWithPredicate:morphballattackrightpred assertingFact:@"ballattackright" grade:1.0];
        [arachnusrs addRule:morphballattackrightrule];
        
        NSPredicate*slashattackleftpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@-150,@-197]];
        GKRule *slashattackleftrule=[GKRule ruleWithPredicate:slashattackleftpred assertingFact:@"slashleft" grade:1.0];
        [arachnusrs addRule:slashattackleftrule];
        
        NSPredicate*slashattackrightpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@", @[@150,@179]];
        GKRule *slashattackrightrule=[GKRule ruleWithPredicate:slashattackrightpred assertingFact:@"slashright" grade:1.0];
        [arachnusrs addRule:slashattackrightrule];
        
        NSPredicate*fireattackleftpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@-100,@-149]];
        GKRule *fireattackleftrule=[GKRule ruleWithPredicate:fireattackleftpred assertingFact:@"fireleft" grade:1.0];
        [arachnusrs addRule:fireattackleftrule];
        
        NSPredicate*fireattackrightpred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@100,@149]];
        GKRule *fireattackrightrule=[GKRule ruleWithPredicate:fireattackrightpred assertingFact:@"fireright" grade:1.0];
        [arachnusrs addRule:fireattackrightrule];
        
        NSPredicate*movebackwardspred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@0,@-99]];
        GKRule *movebackwardsrule=[GKRule ruleWithPredicate:movebackwardspred assertingFact:@"moveback" grade:1.0];
        [arachnusrs addRule:movebackwardsrule];
        
        NSPredicate*moveforwardspred=[NSPredicate predicateWithFormat:@"$coorddist BETWEEN %@",@[@1,@99]];
        GKRule *moveforwardsrule=[GKRule ruleWithPredicate:moveforwardspred assertingFact:@"moveforward" grade:1.0];
        [arachnusrs addRule:moveforwardsrule];
        
        NSPredicate*dmgfwdpred=[NSPredicate predicateWithFormat:@"$currenthealth+20<=$prevhealth && $coorddist>0"];
        GKRule *dmgfwdrule=[GKRule ruleWithPredicate:dmgfwdpred assertingFact:@"damageright" grade:1.0];
        [arachnusrs addRule:dmgfwdrule];
        
        NSPredicate*dmgbkwdpred=[NSPredicate predicateWithFormat:@"$currenthealth+20<=$prevhealth && $coorddist<0"];
        GKRule *dmgbkwdrule=[GKRule ruleWithPredicate:dmgbkwdpred assertingFact:@"damageleft" grade:1.0];
        [arachnusrs addRule:dmgbkwdrule];
        arachnusrs.state[@"currenthealth"]=@(self.health);
        arachnusrs.state[@"prevhealth"]=@(self.health);
        
        NSPredicate*deathpred=[NSPredicate predicateWithFormat:@"$currenthealth<=0"];
        GKRule *deathrule=[GKRule ruleWithPredicate:deathpred assertingFact:@"death" grade:1.0];
        [arachnusrs addRule:deathrule];
        
        rndsrc=[[GKLinearCongruentialRandomSource alloc] init];;
    }
    
    return self;
}


-(void)handleanimswithfocuspos:(CGFloat)focuspos{
  
    if(![self hasActions]){//potential approach to handling one action at a time
       
        SKAction *actoexecute;
        arachnusrs.state[@"coorddist"]=@(focuspos-self.position.x);
        arachnusrs.state[@"currenthealth"]=@(self.health);
        //NSLog(@"coorddist:%f",[arachnusrs.state[@"coorddist"] floatValue]);
        
        [arachnusrs reset];
        [arachnusrs evaluate];
        
        if([arachnusrs gradeForFact:@"death"]==1){
            actoexecute=death;
        }
        else if([arachnusrs gradeForFact:@"damageright"]==1){
            arachnusrs.state[@"prevhealth"]=@(self.health);
            actoexecute=recievedamageright;
        }
        else if([arachnusrs gradeForFact:@"damageleft"]==1){
            arachnusrs.state[@"prevhealth"]=@(self.health);
            actoexecute=recievedamageleft;
        }
        else if([arachnusrs gradeForFact:@"turnright"]==1)
            actoexecute=turnright;
        else if([arachnusrs gradeForFact:@"turnleft"]==1)
            actoexecute=turnleft;
        else if([arachnusrs gradeForFact:@"ballattackleft"]==1)
            actoexecute=morphballattackleft;
        else if([arachnusrs gradeForFact:@"slashleft"]==1)
            actoexecute=slashattackleft;
        else if([arachnusrs gradeForFact:@"fireleft"]==1)
            actoexecute=fireattackleft;
        else if([arachnusrs gradeForFact:@"moveback"]==1)
            actoexecute=movebackward;
        else if([arachnusrs gradeForFact:@"ballattackright"]==1)
            actoexecute=morphballattackright;
        else if([arachnusrs gradeForFact:@"slashright"]==1)
            actoexecute=slashattackright;
        else if([arachnusrs gradeForFact:@"fireright"]==1)
            actoexecute=fireattackright;
        else if([arachnusrs gradeForFact:@"moveforward"]==1)
            actoexecute=moveforeward;
        if(prevac==actoexecute){
            if([arachnusrs.state[@"coorddist"] floatValue]<0)
                actoexecute=[leftattacks objectAtIndex:[rndsrc nextIntWithUpperBound:leftattacks.count]];
            else
                actoexecute=[rightattacks objectAtIndex:[rndsrc nextIntWithUpperBound:rightattacks.count]];
        }
        if(actoexecute!=death){
            [actoexecute setSpeed:(CGFloat)1.0+(CGFloat)([arachnusrs.state[@"orighealth"] floatValue]-self.health)/(3*[arachnusrs.state[@"orighealth"] floatValue])];
        }
        else
            [actoexecute setSpeed:(CGFloat)1.0];
        
        NSLog(@"%f",(CGFloat)1.0+(CGFloat)([arachnusrs.state[@"orighealth"] floatValue]-self.health)/(2.5*[arachnusrs.state[@"orighealth"] floatValue]));
        
        arachnusrs.state[@"prevcoorddist"]=arachnusrs.state[@"coorddist"];
        
        [self runAction:actoexecute];
        prevac=actoexecute;
    }

}



/*- (void)dealloc {
 NSLog(@"ARACHNUS DEALLOCATED");
 }*/


@end
