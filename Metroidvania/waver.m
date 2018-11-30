//
//  waver.m
//  Metroidvania
//
//  Created by nick vancise on 10/10/18.
//

#import "waver.h"

@implementation waver{
    SKAction* weave;
    GKAgent2D *agent;
    GKAgent2D *target;
    NSTimeInterval storetime;
    GKGoal *wander;
    GKGoal *stayonpath;
    GKGoal *seektarget;
    CGPoint targetpos;
}

-(instancetype)initWithPosition:(CGPoint)position{
    //__weak NSString *weakname=name;
    if(self == [super initWithImageNamed:@"waver_r3.png"]){
        self.health=20;
        self.attacking=NO;
        self.position=position;
        SKTextureAtlas*waveratlas=[SKTextureAtlas atlasNamed:@"Waver"];
        
       SKAction *weaveanim=[SKAction animateWithTextures:@[[waveratlas textureNamed:@"waver_r1.png"],[waveratlas textureNamed:@"waver_r2.png"],[waveratlas textureNamed:@"waver_r3.png"],[waveratlas textureNamed:@"waver_r4.png"],[waveratlas textureNamed:@"waver_r5.png"]/*,[waveratlas textureNamed:@"waver_r6.png"]*/] timePerFrame:0.27 resize:YES restore:NO];
        SKAction *weave=[SKAction repeatActionForever:[SKAction sequence:@[weaveanim,[weaveanim reversedAction]]]];
        
        agent=[[GKAgent2D alloc] init];
        agent.radius=self.size.width-4;
        agent.position=(vector_float2){(float)self.position.x,(float)self.position.y};
        agent.delegate=self;
        agent.maxSpeed=11;
        agent.maxAcceleration=10;
        agent.mass=5;
        
        target=[[GKAgent2D alloc]init];
        target.position=vector2((float)100,(float)50);
        target.radius=2;
        target.delegate=nil;
        
        vector_float2 myVectors[8] = {
            {(float)self.position.x,(float)self.position.y},
            {(float)self.position.x+(350/2),(float)self.position.y+20},
            {(float)self.position.x+350,(float)self.position.y}
        };
        
        wander=[GKGoal goalToWander:1];
        stayonpath=[GKGoal goalToStayOnPath:[GKPath pathWithPoints:myVectors count:2 radius:50 cyclical:YES] maxPredictionTime:0.5];
        seektarget=[GKGoal goalToInterceptAgent:(GKAgent2D*)target maxPredictionTime:2];
        GKBehavior *wanderbeh=[GKBehavior behaviorWithGoals:@[stayonpath,wander,seektarget] andWeights:@[@10,@15,@0]];
        
        agent.behavior=wanderbeh;
        
        [self runAction:weave];
    }
    return self;
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds andPlayerpos:(CGPoint)playerpos{
    NSTimeInterval delta=seconds-storetime;
    
    if([agent.behavior weightForGoal:seektarget]!=0){
        target.position=vector2((float)playerpos.x,(float)playerpos.y);
    }
    
    if(delta<0.16)
        delta=0.16;
    
    [agent updateWithDeltaTime:delta];
}

-(void)agentWillUpdate:(GKAgent2D *)agent{
    agent.position=vector2((float)self.position.x,(float)self.position.y);
    agent.rotation=(float)self.zRotation;
}
-(void)agentDidUpdate:(GKAgent2D *)agent{
    self.position = CGPointMake((CGFloat)agent.position.x, (CGFloat)agent.position.y);
    self.zRotation = (CGFloat)agent.rotation;
}

-(void)attack{
    //NSLog(@"attack");
    self.attacking=YES;
    [agent.behavior setWeight:20.0 forGoal:seektarget];
    [agent.behavior setWeight:0.0 forGoal:stayonpath];
    [agent.behavior setWeight:0.0 forGoal:wander];
    agent.maxSpeed=15;
    agent.mass=2;
    __weak GKAgent2D*weakagent=agent;
    __weak GKGoal*weakseektarget=seektarget;
    __weak GKGoal*weakstayonpath=stayonpath;
    __weak GKGoal*weakwander=wander;
    __weak waver*weakself=self;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:10.0],[SKAction runBlock:^{[weakagent.behavior setWeight:0.0 forGoal:weakseektarget];[weakagent.behavior setWeight:10.0 forGoal:weakstayonpath];[weakagent.behavior setWeight:15.0 forGoal:weakwander];weakagent.maxSpeed=12;weakagent.mass=5;}],[SKAction waitForDuration:7.0],[SKAction runBlock:^{weakself.attacking=NO;}]]]];
}


/*-(void)dealloc{
    NSLog(@"waver deallocated");
}*/

@end
