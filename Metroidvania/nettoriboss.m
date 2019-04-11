//
//  nettoriboss.m
//  Metroidvania
//
//  Created by nick vancise on 12/31/18.
//

#import "nettoriboss.h"


@implementation nettoriboss{
    SKTextureAtlas*_nettoriAtlas;
    SKAction *dmgbaseac,*dmgbasemedac,*dmgbasehighac,*attack1,*attack2,*attack3,*attack4;
    GKComponentSystem*_agentSystem;
    SKAction*_petalidleanim,*_petalattackanim;
    SKSpriteNode*beam;
}

-(instancetype)initWithPosition:(CGPoint)pos{
    _nettoriAtlas=[SKTextureAtlas atlasNamed:@"Nettori"];
    self=[super initWithTexture:[_nettoriAtlas textureNamed:@"nettori_nodmg1.png"]];
    if(self!=nil){
        self.position=pos;
        [self setScale:1.2];
        self.anchorPoint=CGPointMake(1,0);
        self.health=300;
        self.dead=NO;
        self.projectilesInAction=[[NSMutableArray alloc] init];
        
        _agentSystem=[[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
        
        dmgbaseac=[SKAction repeatActionForever:[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbase1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase5.png"]] timePerFrame:0.2 resize:YES restore:NO]];
        
        dmgbasemedac=[SKAction repeatActionForever:[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbasemed1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed5.png"]] timePerFrame:0.2 resize:YES restore:NO]];
        
        dmgbasehighac=[SKAction repeatActionForever:[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh5.png"]] timePerFrame:0.2 resize:YES restore:NO]];
        
        __weak nettoriboss*weakself=self;
        attack1=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:5],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}]]]];
        attack2=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:3.3],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}]]]];
        attack3=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:3],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}],[SKAction waitForDuration:2],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}]]]];
        attack4=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:1.78],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}],[SKAction waitForDuration:0.5],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}],[SKAction waitForDuration:2.5],[SKAction runBlock:^{NSLog(@"fire netplas");[weakself fireNetPlas];}]]]];
       
        [self runAction:attack3];
        
        petal*petal1=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*9,16*6) andArr:self.projectilesInAction];
        [self addChild:petal1];
        
        petal*petal4=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*7,16*6) andArr:self.projectilesInAction];
        [petal4 setXScale:-1];
        [self addChild:petal4];
        
        petal*petal2=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*14,16*6) andArr:self.projectilesInAction];
        [self addChild:petal2];
        
        petal*petal3=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*17,16*6) andArr:self.projectilesInAction];
        [petal3 setXScale:-1];
        [self addChild:petal3];
        
        plant *plnt1=[[plant alloc] initWithPos:CGPointMake(-16*9, -16*3) andTextureAtlas:_nettoriAtlas];
        [self addChild:plnt1];
        [self.projectilesInAction addObject:plnt1];
        plant *plnt2=[[plant alloc] initWithPos:CGPointMake(plnt1.position.x-5*16, -16*3) andTextureAtlas:_nettoriAtlas];
        [self addChild:plnt2];
        [self.projectilesInAction addObject:plnt2];
        plant *plnt3=[[plant alloc] initWithPos:CGPointMake(plnt2.position.x-5*16, -16*3) andTextureAtlas:_nettoriAtlas];
        [self addChild:plnt3];
        [self.projectilesInAction addObject:plnt3];
        plant *plnt4=[[plant alloc] initWithPos:CGPointMake(plnt3.position.x-5*16, -16*3) andTextureAtlas:_nettoriAtlas];
        [self addChild:plnt4];
        [self.projectilesInAction addObject:plnt4];
        
    }
    return self;
}

-(void)fireNetPlas{
    netPlas*proj=[[netPlas alloc] initWithImageNamed:@"plasprojflash1.png" andAtlas:_nettoriAtlas andArrayToRemoveFrom:self.projectilesInAction];
    [self addChild:proj];
    [self.projectilesInAction addObject:proj];
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds{
    
    if(seconds<0.16)
        seconds=0.16;
    
    [_agentSystem updateWithDeltaTime:seconds];
}

-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray *)arr withHit:(int)hit{
    self.health=self.health-hit;
    if(self.health<250 && ![self actionForKey:@"base"]){
        [self removeActionForKey:@"1"];
        [self runAction:dmgbaseac withKey:@"base"];
        [self runAction:attack2 withKey:@"2"];
    }
    else if(self.health<200 && ![self actionForKey:@"med"]){
        [self removeActionForKey:@"2"];
        [self runAction:dmgbasemedac withKey:@"med"];
        [self runAction:attack3 withKey:@"3"];
    }
    else if(self.health<100 && ![self actionForKey:@"high"]){
        [self removeActionForKey:@"3"];
        [self runAction:dmgbasehighac withKey:@"high"];
        [self runAction:attack4 withKey:@"4"];
    }
    if(self.health<=0){
        //NSLog(@"healthisbelowzero");
        [self removeAllActions];
        [self removeAllChildren];
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
        //NSLog(@"%d",(int)arr.count);
    }
    
}

-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray *)arr{
    
    
}
-(void)startAttack{
    [self runAction:attack1 withKey:@"1"];
}

-(void)dealloc{
    NSLog(@"nettori deallocated");
}

@end

@implementation netprojbase
-(void)runDmgac{
    
}
@end

@implementation plant

-(instancetype)initWithPos:(CGPoint)pos andTextureAtlas:(SKTextureAtlas*)atlas{
    self=[super initWithTexture:[atlas textureNamed:@"plantidle1.png"]];
    if(self!=nil){
        self.anchorPoint=CGPointMake(0.5,0);
        [self setScale:0.85];
        self.position=pos;
        self.canGiveDmg=YES;
        self.dmgamt=15;
        
        self.plantidle=[SKAction repeatActionForever:[SKAction animateWithTextures:@[[atlas textureNamed:@"plantidle1.png"],[atlas textureNamed:@"plantidle2.png"],[atlas textureNamed:@"plantidle3.png"],[atlas textureNamed:@"plantidle4.png"],[atlas textureNamed:@"plantidle5.png"],[atlas textureNamed:@"plantidle6.png"],[atlas textureNamed:@"plantidle7.png"],[atlas textureNamed:@"plantidle8.png"],[atlas textureNamed:@"plantidle9.png"],[atlas textureNamed:@"plantidle10.png"],[atlas textureNamed:@"plantidle11.png"],[atlas textureNamed:@"plantidle12.png"],[atlas textureNamed:@"plantidle13.png"],] timePerFrame:0.25 resize:YES restore:NO]];
        self.plantattack=[SKAction animateWithTextures:@[[atlas textureNamed:@"plantattack1.png"],[atlas textureNamed:@"plantattack2.png"],[atlas textureNamed:@"plantattack3.png"],[atlas textureNamed:@"plantattack4.png"],] timePerFrame:0.12 resize:YES restore:NO];
    
        self.dmgaction=[SKAction sequence:@[[SKAction repeatAction:self.plantattack count:5]]];
        [self runAction:self.plantidle withKey:@"idle"];
    }
    return self;
}

-(void)runDmgac{
    if(self.dmgaction!=nil && [self actionForKey:@"idle"]){
        //NSLog(@"petal eat ac running");
        __weak plant*weakself=self;
        [self removeActionForKey:@"idle"];
        [self runAction:self.dmgaction completion:^{[weakself runAction:self.plantidle withKey:@"idle"];}];
    }
}

@end

@implementation petal{
    SKAction*_petalidleanim;
    SKAction*_petalattackanim;
    SKAction*_petalattack;
}

-(instancetype)initWithAtlas:(SKTextureAtlas*)atlas andCS:(GKComponentSystem*)system andPos:(CGPoint)pos andArr:(NSMutableArray*)arr{
    self=[super initWithTexture:[atlas textureNamed:@"petalidle1.png"]];
    if(self!=nil){
        self.position=pos;
        _petalidleanim=[SKAction repeatAction:[SKAction animateWithTextures:@[[atlas textureNamed:@"petalidle1.png"],[atlas textureNamed:@"petalidle2.png"],[atlas textureNamed:@"petalidle3.png"],[atlas textureNamed:@"petalidle4.png"],] timePerFrame:0.2] count:5];
        _petalattackanim=[SKAction animateWithTextures:@[[atlas textureNamed:@"petalattack1.png"],[atlas textureNamed:@"petalattack2.png"],[atlas textureNamed:@"petalattack3.png"],[atlas textureNamed:@"petalattack4.png"],[atlas textureNamed:@"petalattack5.png"],[atlas textureNamed:@"petalattack6.png"],[atlas textureNamed:@"petalattack7.png"],[atlas textureNamed:@"petalattack8.png"],] timePerFrame:0.2];
        
        __weak GKComponentSystem*weakagentSystem=system;
        __weak petal*weakself=self;
        __weak NSMutableArray*weakarr=arr;
        _petalattack=[SKAction sequence:@[[SKAction waitForDuration:(float)arc4random_uniform(300.0)/100],[SKAction repeatActionForever:[SKAction sequence:@[_petalidleanim,[SKAction group:@[_petalattackanim,[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{
            petalprojectile*tmp=[[petalprojectile alloc] initWithTextureAtlas:atlas andCS:weakagentSystem andPos:CGPointZero andArr:weakarr];
            //NSLog(@"adding petal proj");
            [weakarr addObject:tmp];
            //NSLog(@"weakarr count:%lu",(unsigned long)weakarr.count);
            [weakself addChild:tmp];
        }]]]]]]]]]];
        //NSLog(@"testing time:%f",(float)arc4random_uniform(100.0)/100);
        [self runAction:_petalattack];
    }
    return self;
}

/*-(void)dealloc{
    NSLog(@"petal deallocated");
}*/

@end


@implementation petalprojectile

-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)atlas andCS:(GKComponentSystem*)system andPos:(CGPoint)pos andArr:(NSMutableArray *)arr{
    self=[super initWithTexture:[atlas textureNamed:@"petalprojidle1.png"]];
    if(self!=nil){
        self.position=pos;
        self.agent=[[GKAgent2D alloc] init];
        self.agent.radius=self.size.height;
        self.agent.delegate=self;
        self.agent.maxSpeed=5;
        self.agent.maxAcceleration=7;
        self.agent.mass=5;
        self.canGiveDmg=NO;
        self.dmgaction=nil;
        self.dmgamt=10;
        __weak petalprojectile*weakself=self;
        __weak GKComponentSystem*weaksystem=system;
        
        vector_float2 myVectors[8] = {
            {(float)self.position.x,(float)self.position.y-50},
            {(float)self.position.x+20,(float)self.position.y-90}
        };
        
        GKBehavior*wanderWithinBoundary=[GKBehavior behaviorWithGoals:@[[GKGoal goalToWander:1],[GKGoal goalToStayOnPath:[GKPath pathWithPoints:myVectors count:2 radius:25 cyclical:YES] maxPredictionTime:0.5]] andWeights:@[@10,@50]];
        self.agent.behavior=wanderWithinBoundary;
        
        SKAction*petalprojidle=[SKAction repeatAction:[SKAction animateWithTextures:@[[atlas textureNamed:@"petalprojidle1.png"],[atlas textureNamed:@"petalprojidle2.png"],[atlas textureNamed:@"petalprojidle3.png"],[atlas textureNamed:@"petalprojidle4.png"],] timePerFrame:0.3] count:8];
        SKAction*petalprojexplode=[SKAction animateWithTextures:@[[atlas textureNamed:@"petalprojexplode1.png"],[atlas textureNamed:@"petalprojexplode2.png"],[atlas textureNamed:@"petalprojexplode3.png"],] timePerFrame:0.1];
        SKAction*setDmgAvailability=[SKAction runBlock:^{weakself.canGiveDmg=YES;}];
        
        
        SKAction*composedac=[SKAction sequence:@[petalprojidle,setDmgAvailability,petalprojexplode]];
        [system addComponent:self.agent];
        //[arr addObject:self];
        [self runAction:composedac completion:^{[weaksystem removeComponent:weakself.agent];[arr removeObject:weakself];[weakself removeAllActions];[weakself removeFromParent];}];
        
    }
    return self;
}

-(void)agentWillUpdate:(GKAgent2D *)agent{
    agent.position=vector2((float)self.position.x,(float)self.position.y);
    agent.rotation=(float)self.zRotation;
}
-(void)agentDidUpdate:(GKAgent2D *)agent{
    self.position = CGPointMake((CGFloat)agent.position.x, (CGFloat)agent.position.y);
    self.zRotation = (CGFloat)agent.rotation;
}

/*-(void)dealloc{
    NSLog(@"petal projectile deallocated");
}*/

@end


@implementation netPlas

-(instancetype)initWithImageNamed:(NSString *)name andAtlas:(SKTextureAtlas*)atlas andArrayToRemoveFrom:(NSMutableArray *)arr{
    self=[super initWithImageNamed:name];
    if(self!=nil){
        self.hidden=YES;
        self.dmgamt=20;
        self.canGiveDmg=YES;
        self.dmgaction=nil;
        SKAction*beamanimate=[SKAction repeatAction:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"plasmabeamodd.png"],[SKTexture textureWithImageNamed:@"plasmabeameven.png"]] timePerFrame:0.05 resize:YES restore:NO] count:10];
        SKAction*beamspawn=[SKAction animateWithTextures:@[[atlas textureNamed:@"plasprojflash1.png"],[atlas textureNamed:@"plasprojflash2.png"],[atlas textureNamed:@"projspawn1.png"],[atlas textureNamed:@"projspawn2.png"],[atlas textureNamed:@"projspawn3.png"],[atlas textureNamed:@"projspawn4.png"],[atlas textureNamed:@"projspawn5.png"],[atlas textureNamed:@"projspawn6.png"],[atlas textureNamed:@"projspawn7.png"],[atlas textureNamed:@"projspawn8.png"],[atlas textureNamed:@"projspawn9.png"],[atlas textureNamed:@"projspawn10.png"],[atlas textureNamed:@"projspawn11.png"],[atlas textureNamed:@"projspawn12.png"],[atlas textureNamed:@"projspawn13.png"],[atlas textureNamed:@"projspawn14.png"],[atlas textureNamed:@"projspawn15.png"],[atlas textureNamed:@"projspawn16.png"],[atlas textureNamed:@"projspawn17.png"],[atlas textureNamed:@"projspawn18.png"],[atlas textureNamed:@"projspawn19.png"],[atlas textureNamed:@"projspawn20.png"]] timePerFrame:0.08 resize:YES restore:YES];
        CGVector projvector=CGVectorMake(-360,0);
        SKAction*beammove=[SKAction moveBy:projvector duration:1];
        __weak SKSpriteNode*weakbeam=self;
        __weak NSMutableArray*weakarr=arr;
        SKAction*removeBeam=[SKAction runBlock:^{[weakbeam removeAllActions];[weakbeam removeFromParent];[weakarr removeObject:weakbeam];weakbeam.position=CGPointZero;}];
        SKAction*beamStart=[SKAction runBlock:^{
            weakbeam.position=CGPointMake(-25, arc4random_uniform((u_int32_t) 70)+10);
            weakbeam.hidden=NO;
        }];
        SKAction*beamattack=[SKAction sequence:@[beamStart,beamspawn,[SKAction group:@[beammove,beamanimate]],removeBeam]];
        [self runAction:beamattack];
     }
    return self;
}

-(void)dealloc{
    NSLog(@"netPlas dealloc");
}

@end
