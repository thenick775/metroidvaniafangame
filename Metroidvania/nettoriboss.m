//
//  nettoriboss.m
//  Metroidvania
//
//  Created by nick vancise on 12/31/18.
//

#import "nettoriboss.h"


@implementation nettoriboss{
    SKTextureAtlas*_nettoriAtlas;
    SKAction *dmgbaseac,*dmgbasemedac,*dmgbasehighac;
    SKAction *baseattack,*basemedattack,*basehighattack;
    GKComponentSystem*_agentSystem;
    SKAction*_petalidleanim,*_petalattackanim;
}

-(instancetype)initWithPosition:(CGPoint)pos{
    _nettoriAtlas=[SKTextureAtlas atlasNamed:@"Nettori"];
    self=[super initWithTexture:[_nettoriAtlas textureNamed:@"nettori_nodmg1.png"]];
    if(self!=nil){
        self.position=pos;
        self.health=300;
        [self setScale:1.2];
        self.anchorPoint=CGPointMake(1,0);
        self.health=200;
        self.dead=NO;
        self.projectilesInAction=[[NSMutableArray alloc] init];
        
        _agentSystem=[[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
        
        dmgbaseac=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbase1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase5.png"]] timePerFrame:0.2 resize:YES restore:NO];
        
        dmgbasemedac=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbasemed1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed5.png"]] timePerFrame:0.2 resize:YES restore:NO];
        
        dmgbasehighac=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh5.png"]] timePerFrame:0.2 resize:YES restore:NO];
        
        petal*petal1=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*9,16*6) andArr:self.projectilesInAction];
        [self addChild:petal1];
        
        petal*petal4=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*7,16*6) andArr:self.projectilesInAction];
        [petal4 setXScale:-1];
        [self addChild:petal4];
        
        petal*petal2=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*14,16*6) andArr:self.projectilesInAction];
        //[petal2 setXScale:-1];
        [self addChild:petal2];
        
        petal*petal3=[[petal alloc] initWithAtlas:_nettoriAtlas andCS:_agentSystem andPos:CGPointMake(-16*17,16*6) andArr:self.projectilesInAction];
        [petal3 setXScale:-1];
        [self addChild:petal3];
        
        SKAction*plantidle=[SKAction repeatActionForever:[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"plantidle1.png"],[_nettoriAtlas textureNamed:@"plantidle2.png"],[_nettoriAtlas textureNamed:@"plantidle3.png"],[_nettoriAtlas textureNamed:@"plantidle4.png"],[_nettoriAtlas textureNamed:@"plantidle5.png"],[_nettoriAtlas textureNamed:@"plantidle6.png"],[_nettoriAtlas textureNamed:@"plantidle7.png"],[_nettoriAtlas textureNamed:@"plantidle8.png"],[_nettoriAtlas textureNamed:@"plantidle9.png"],[_nettoriAtlas textureNamed:@"plantidle10.png"],[_nettoriAtlas textureNamed:@"plantidle11.png"],[_nettoriAtlas textureNamed:@"plantidle12.png"],[_nettoriAtlas textureNamed:@"plantidle13.png"],] timePerFrame:0.25 resize:YES restore:NO]];
        SKAction*plantattack=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"plantattack1.png"],[_nettoriAtlas textureNamed:@"plantattack2.png"],[_nettoriAtlas textureNamed:@"plantattack3.png"],[_nettoriAtlas textureNamed:@"plantattack4.png"],] timePerFrame:0.12 resize:YES restore:NO];
        
        SKSpriteNode*plant1=[SKSpriteNode spriteNodeWithTexture:[_nettoriAtlas textureNamed:@"plantidle1.png"]];
        plant1.anchorPoint=CGPointMake(0.5,0);
        [plant1 setScale:0.85];
        plant1.position=CGPointMake(-16*9, -16*3);
        [self addChild:plant1];
        [plant1 runAction:plantidle];
        
        SKSpriteNode*plant2=plant1.copy;
        plant2.position=CGPointMake(plant1.position.x-5*16, plant1.position.y);
        [self addChild:plant2];
        
        SKSpriteNode*plant3=plant1.copy;
        plant3.position=CGPointMake(plant2.position.x-5*16, plant1.position.y);
        [self addChild:plant3];
        
        SKSpriteNode*plant4=plant1.copy;
        plant4.position=CGPointMake(plant3.position.x-5*16, plant1.position.y);
        [self addChild:plant4];
        
    }
    return self;
}


-(void)updateWithDeltaTime:(NSTimeInterval)seconds{
    
    if(seconds<0.16)
        seconds=0.16;
    
    [_agentSystem updateWithDeltaTime:seconds];
}

/*-(void)dealloc{
    NSLog(@"nettori deallocated");
}*/

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


@implementation petalprojectile{
    SKAction*_petalprojidle;
    SKAction*_petalprojexplode;
}

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
        __weak petalprojectile*weakself=self;
        __weak GKComponentSystem*weaksystem=system;
        
        vector_float2 myVectors[8] = {
            {(float)self.position.x,(float)self.position.y-30},
            {(float)self.position.x+20/*+(350/2)*/,(float)self.position.y-100}
        };
        
        GKBehavior*wanderWithinBoundary=[GKBehavior behaviorWithGoals:@[[GKGoal goalToWander:1],[GKGoal goalToStayOnPath:[GKPath pathWithPoints:myVectors count:2 radius:25 cyclical:YES] maxPredictionTime:0.5]] andWeights:@[@10,@50]];
        self.agent.behavior=wanderWithinBoundary;
        
        _petalprojidle=[SKAction repeatAction:[SKAction animateWithTextures:@[[atlas textureNamed:@"petalprojidle1.png"],[atlas textureNamed:@"petalprojidle2.png"],[atlas textureNamed:@"petalprojidle3.png"],[atlas textureNamed:@"petalprojidle4.png"],] timePerFrame:0.3] count:8];
        _petalprojexplode=[SKAction animateWithTextures:@[[atlas textureNamed:@"petalprojexplode1.png"],[atlas textureNamed:@"petalprojexplode2.png"],[atlas textureNamed:@"petalprojexplode3.png"],] timePerFrame:0.1];
        
        SKAction*composedac=[SKAction sequence:@[_petalprojidle,_petalprojexplode]];
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
