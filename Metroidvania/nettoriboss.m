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
    NSMutableArray *ceilingpetals;
    NSMutableArray *groundplants;
    GKComponentSystem*_agentSystem;
    SKAction*_petalidleanim,*_petalattackanim;
}

-(instancetype)initWithPosition:(CGPoint)pos{
    _nettoriAtlas=[SKTextureAtlas atlasNamed:@"Nettori"];
    self=[super initWithTexture:[_nettoriAtlas textureNamed:@"nettori_nodmg1.png"]];
    if(self!=nil){
        self.position=pos;
        [self setScale:1.2];
        self.anchorPoint=CGPointMake(1,0);
        self.health=200;
        _agentSystem=[[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
        
        dmgbaseac=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbase1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbase5.png"]] timePerFrame:0.2 resize:YES restore:NO];
        
        dmgbasemedac=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbasemed1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasemed5.png"]] timePerFrame:0.2 resize:YES restore:NO];
        
        dmgbasehighac=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh1.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh2.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh3.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh4.png"],[_nettoriAtlas textureNamed:@"nettori_dmgbasehigh5.png"]] timePerFrame:0.2 resize:YES restore:NO];
        
        
       /* _petalidleanim=[SKAction repeatAction:[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"petalidle1.png"],[_nettoriAtlas textureNamed:@"petalidle2.png"],[_nettoriAtlas textureNamed:@"petalidle3.png"],[_nettoriAtlas textureNamed:@"petalidle4.png"],] timePerFrame:0.2] count:5];
        _petalattackanim=[SKAction animateWithTextures:@[[_nettoriAtlas textureNamed:@"petalattack1.png"],[_nettoriAtlas textureNamed:@"petalattack2.png"],[_nettoriAtlas textureNamed:@"petalattack3.png"],[_nettoriAtlas textureNamed:@"petalattack4.png"],[_nettoriAtlas textureNamed:@"petalattack5.png"],[_nettoriAtlas textureNamed:@"petalattack6.png"],[_nettoriAtlas textureNamed:@"petalattack7.png"],[_nettoriAtlas textureNamed:@"petalattack8.png"],] timePerFrame:0.2];
        
        SKSpriteNode*testpetal=[SKSpriteNode spriteNodeWithTexture:[_nettoriAtlas textureNamed:@"petalidle1.png"]];
        __weak GKComponentSystem*weakagentSystem=_agentSystem;
        __weak SKTextureAtlas*weaktex=_nettoriAtlas;
        __weak nettoriboss*weakself=self;
        SKAction*petalattack=[SKAction repeatActionForever:[SKAction sequence:@[_petalidleanim,[SKAction group:@[_petalattackanim,[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{
            petalprojectile*tmp=[[petalprojectile alloc] initWithTextureAtlas:weaktex andComponentSystem:weakagentSystem andPosition:testpetal.position];
            [weakself addChild:tmp];
        }]]]]]]]];
        testpetal.position=CGPointMake(-16*9,16*6);
        [testpetal runAction: petalattack];
        [self addChild:testpetal];
        
        SKSpriteNode*testpetal1=testpetal.copy;
        testpetal1.position=CGPointMake(-16*14,16*6);
        [testpetal1 removeAllActions];
        [testpetal1 runAction:[SKAction sequence:@[[SKAction waitForDuration:0.67],petalattack]]];
        [self addChild:testpetal1];
        
        SKSpriteNode*testpetal2=testpetal.copy;
        [testpetal2 setXScale:-1];
        testpetal2.position=CGPointMake(-16*17,16*6);
        [testpetal2 removeAllActions];
        [testpetal2 runAction:[SKAction sequence:@[[SKAction waitForDuration:1.11],petalattack]]];
        [self addChild:testpetal2];
        */
        petal*petal1=[[petal alloc] initWithAtlas:_nettoriAtlas andComponentSystem:_agentSystem andPosition:CGPointMake(-16*9,16*6)];
        [self addChild:petal1];
        
        petal*petal2=[[petal alloc] initWithAtlas:_nettoriAtlas andComponentSystem:_agentSystem andPosition:CGPointMake(-16*14,16*6)];
        [self addChild:petal2];
        
        petal*petal3=[[petal alloc] initWithAtlas:_nettoriAtlas andComponentSystem:_agentSystem andPosition:CGPointMake(-16*17,16*6)];
        [petal3 setXScale:-1];
        [self addChild:petal3];
        
    }
    return self;
}


-(void)updateWithDeltaTime:(NSTimeInterval)seconds{
    
    if(seconds<0.16)
        seconds=0.16;
    
    [_agentSystem updateWithDeltaTime:seconds];
}


@end


@implementation petal{
    SKAction*_petalidleanim;
    SKAction*_petalattackanim;
    SKAction*_petalattack;
}

-(instancetype)initWithAtlas:(SKTextureAtlas*)atlas andComponentSystem:(GKComponentSystem*)system andPosition:(CGPoint)pos{
    self=[super initWithTexture:[atlas textureNamed:@"petalidle1.png"]];
    if(self!=nil){
        self.position=pos;
        _petalidleanim=[SKAction repeatAction:[SKAction animateWithTextures:@[[atlas textureNamed:@"petalidle1.png"],[atlas textureNamed:@"petalidle2.png"],[atlas textureNamed:@"petalidle3.png"],[atlas textureNamed:@"petalidle4.png"],] timePerFrame:0.2] count:5];
        _petalattackanim=[SKAction animateWithTextures:@[[atlas textureNamed:@"petalattack1.png"],[atlas textureNamed:@"petalattack2.png"],[atlas textureNamed:@"petalattack3.png"],[atlas textureNamed:@"petalattack4.png"],[atlas textureNamed:@"petalattack5.png"],[atlas textureNamed:@"petalattack6.png"],[atlas textureNamed:@"petalattack7.png"],[atlas textureNamed:@"petalattack8.png"],] timePerFrame:0.2];
        
        __weak GKComponentSystem*weakagentSystem=system;
        __weak petal*weakself=self;
        _petalattack=[SKAction sequence:@[[SKAction waitForDuration:(float)arc4random_uniform(200.0)/100],[SKAction repeatActionForever:[SKAction sequence:@[_petalidleanim,[SKAction group:@[_petalattackanim,[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{
            petalprojectile*tmp=[[petalprojectile alloc] initWithTextureAtlas:atlas andComponentSystem:weakagentSystem andPosition:CGPointZero];
            [weakself addChild:tmp];
        }]]]]]]]]]];
        //NSLog(@"testing time:%f",(float)arc4random_uniform(100.0)/100);
        [self runAction:_petalattack];
    }
    return self;
}

@end


@implementation petalprojectile{
    SKAction*_petalprojidle;
    SKAction*_petalprojexplode;
}

-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)atlas andComponentSystem:(GKComponentSystem*)system andPosition:(CGPoint)pos{
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
        GKBehavior*wanderAround=[GKBehavior behaviorWithGoal:[GKGoal goalToWander:1] weight:10];
        self.agent.behavior=wanderAround;
        
        _petalprojidle=[SKAction repeatAction:[SKAction animateWithTextures:@[[atlas textureNamed:@"petalprojidle1.png"],[atlas textureNamed:@"petalprojidle2.png"],[atlas textureNamed:@"petalprojidle3.png"],[atlas textureNamed:@"petalprojidle4.png"],] timePerFrame:0.3] count:8];
        _petalprojexplode=[SKAction animateWithTextures:@[[atlas textureNamed:@"petalprojexplode1.png"],[atlas textureNamed:@"petalprojexplode2.png"],[atlas textureNamed:@"petalprojexplode3.png"],] timePerFrame:0.1];
        
        SKAction*composedac=[SKAction sequence:@[_petalprojidle,_petalprojexplode]];
        [system addComponent:self.agent];
        [self runAction:composedac completion:^{[weaksystem removeComponent:weakself.agent];[weakself removeAllActions];[weakself removeFromParent];}];
        
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

@end
