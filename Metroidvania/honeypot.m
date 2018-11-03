//
//  honeypot.m
//  Metroidvania
//
//  Created by nick vancise on 9/29/18.
//

#import "honeypot.h"



@implementation honeypotproj

-(instancetype)initWithPosition:(CGPoint)position andTex:(SKTexture*)tex{
    __weak SKTexture *weaktex=tex;
    if(self == [super initWithTexture:weaktex]){
        self.agent=[[GKAgent2D alloc] init];
        self.agent.radius=self.size.height;
        self.agent.position=(vector_float2){(float)position.x,(float)position.y};
        self.agent.delegate=self;
        self.agent.maxSpeed=18;
        self.agent.maxAcceleration=12;
        self.agent.mass=2;
    }
    return self;
}

- (void)agentWillUpdate:(nonnull GKAgent2D *)agent {
    agent.position=vector2((float)self.position.x,(float)self.position.y);
    agent.rotation=(float)self.zRotation;
}
- (void)agentDidUpdate:(nonnull GKAgent2D *)agent {
    self.position = CGPointMake((CGFloat)agent.position.x, (CGFloat)agent.position.y);
    //NSLog(@"%@",NSStringFromCGPoint(self.position));
    self.zRotation = (CGFloat)agent.rotation;
}

@end


@implementation honeypot{
    SKTextureAtlas *honeypotatlas;
    SKAction *walkf;
    SKAction *walkb;
    NSTimeInterval storetime;
    SKAction *projectileexplode;
}



-(instancetype)initcomplete{
    honeypotatlas=[SKTextureAtlas atlasNamed:@"honeypot"];
    if(self == [super initWithTexture:[honeypotatlas textureNamed:@"honeypot1.png"]]){
    SKTextureAtlas *arachnusatlas=[SKTextureAtlas atlasNamed:@"Arachnus"];
    self.health=20;
    self.dead=NO;
    __weak honeypot*weakself=self;
    self.agentSystem=[[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
    self.target=[[GKAgent2D alloc]init];
    self.target.radius=7;
    self.target.delegate=nil;
   
        
    SKAction *walkanim=[SKAction animateWithTextures:@[[honeypotatlas textureNamed:@"honeypot1.png"],[honeypotatlas textureNamed:@"honeypot2.png"],[honeypotatlas textureNamed:@"honeypot3.png"],[honeypotatlas textureNamed:@"honeypot4.png"],[honeypotatlas textureNamed:@"honeypot5.png"],[honeypotatlas textureNamed:@"honeypot6.png"],[honeypotatlas textureNamed:@"honeypot7.png"],[honeypotatlas textureNamed:@"honeypot8.png"]] timePerFrame:0.2 resize:YES restore:NO];
    
    SKAction *walkmove=[SKAction moveBy:CGVectorMake(150,0) duration:6.4];
    
    walkf=[SKAction group:@[[SKAction repeatAction:walkanim count:4],walkmove]];
    walkb=[SKAction group:@[[SKAction repeatAction:[walkanim reversedAction] count:4],[walkmove reversedAction]]];
    self.explode=[SKAction sequence:@[[SKAction animateWithTextures:@[[honeypotatlas textureNamed:@"honeypot9.png"],[honeypotatlas textureNamed:@"honeypot10.png"]] timePerFrame:0.1],[SKAction runBlock:^{[weakself projectileAttack];}]]];
    projectileexplode=[SKAction animateWithTextures:@[[arachnusatlas textureNamed:@"Fire3.png"],[arachnusatlas textureNamed:@"Fire4.png"]] timePerFrame:0.13 resize:YES restore:NO];
    
        
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[walkf,walkb]]] withKey:@"walk"];
        
    }
    return self;
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds{
    NSTimeInterval delta=seconds-storetime;
    
    if(delta<0.16)
        delta=0.16;
    
    storetime=seconds;
    
    [self.agentSystem updateWithDeltaTime:delta];
}

-(void)projectileAttack{
    NSLog(@"initiating projectile attack");
    for(int i=0;i<30;i++){
        __weak GKComponentSystem *weakagentSystem=self.agentSystem;
        honeypotproj *tmproj=[[honeypotproj alloc] initWithPosition:CGPointZero andTex:[honeypotatlas textureNamed:@"honeypotprojectiler.png"]];
        __weak honeypotproj*weaktmproj=tmproj;
        [tmproj runAction:[SKAction sequence:@[[SKAction waitForDuration:12.0],projectileexplode,[SKAction runBlock:^{[weakagentSystem removeComponent:tmproj.agent];[weaktmproj removeFromParent];}]]]];
        
        tmproj.position=CGPointMake(0,i+2);
        [self addChild:tmproj];
        [self.agentSystem addComponent:tmproj.agent];
    }
    GKBehavior *flock=[GKBehavior behaviorWithGoals:@[[GKGoal goalToSeekAgent:(GKAgent*)self.target],[GKGoal goalToSeparateFromAgents:self.agentSystem.components maxDistance:1 maxAngle:M_PI_4]] andWeights:@[@14,@150]];
    
    for(GKAgent2D *thisagent in self.agentSystem.components){
            thisagent.behavior=flock;
    }
    
}




/*-(void)dealloc{
    NSLog(@"honeypot deallocated");
}*/

@end





