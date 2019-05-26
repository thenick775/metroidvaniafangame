//
//  waver.m
//  Metroidvania
//
//  Created by nick vancise on 10/10/18.
//

#import "waver.h"

@implementation waver{
    SKAction* _weave;
    GKAgent2D *_agent;
    GKAgent2D *_target;
    NSTimeInterval _storetime;
    GKGoal *_wander;
    GKGoal *_stayonpath;
    GKGoal *_seektarget;
}

-(instancetype)initWithPosition:(CGPoint)position xRange:(int)xrange yRange:(int)yrange{
    //__weak NSString *weakname=name;
    self = [super initWithImageNamed:@"waver_r3.png"];
    if(self!=nil){
        self.health=20;
        self.dx=5;
        self.dy=0;
        self.attacking=NO;
        self.position=position;
        SKTextureAtlas*waveratlas=[SKTextureAtlas atlasNamed:@"Waver"];
        
       SKAction *weaveanim=[SKAction animateWithTextures:@[[waveratlas textureNamed:@"waver_r1.png"],[waveratlas textureNamed:@"waver_r2.png"],[waveratlas textureNamed:@"waver_r3.png"],[waveratlas textureNamed:@"waver_r4.png"],[waveratlas textureNamed:@"waver_r5.png"]/*,[waveratlas textureNamed:@"waver_r6.png"]*/] timePerFrame:0.27 resize:YES restore:NO];
        SKAction *_weave=[SKAction repeatActionForever:[SKAction sequence:@[weaveanim,[weaveanim reversedAction]]]];
        
        _agent=[[GKAgent2D alloc] init];
        _agent.radius=self.size.width-4;
        _agent.position=(vector_float2){(float)self.position.x,(float)self.position.y};
        _agent.delegate=self;
        _agent.maxSpeed=11;
        _agent.maxAcceleration=10;
        _agent.mass=5;
        
        _target=[[GKAgent2D alloc]init];
        _target.position=vector2((float)100,(float)50);
        _target.radius=2;
        _target.delegate=nil;
        
        __weak waver*weakself=self;
        vector_float2 myVectors[8] = {//accepts range that will generate a triangle with left vertex at
            {(float)weakself.position.x,(float)weakself.position.y},//its set position
            {(float)weakself.position.x+(xrange/2),(float)weakself.position.y+yrange},
            {(float)weakself.position.x+xrange,(float)weakself.position.y}
        };
        
        _wander=[GKGoal goalToWander:1];
        _stayonpath=[GKGoal goalToStayOnPath:[GKPath pathWithPoints:myVectors count:2 radius:50 cyclical:YES] maxPredictionTime:0.5];
        _seektarget=[GKGoal goalToInterceptAgent:(GKAgent2D*)_target maxPredictionTime:2];
        GKBehavior *wanderbeh=[GKBehavior behaviorWithGoals:@[_stayonpath,_wander,_seektarget] andWeights:@[@10,@15,@0]];
        
        _agent.behavior=wanderbeh;
        
        [self runAction:_weave];
    }
    return self;
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds andPlayerpos:(CGPoint)playerpos{
    //NSTimeInterval delta=seconds-_storetime;//might not be needed, need to test
    
    if([_agent.behavior weightForGoal:_seektarget]!=0){
        _target.position=vector2((float)playerpos.x,(float)playerpos.y);
    }
    
    if(seconds<0.16)
        seconds=0.16;
    else if(seconds>0.18)
        seconds=0.18;
    
    [_agent updateWithDeltaTime:seconds];
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
    [_agent.behavior setWeight:20.0 forGoal:_seektarget];
    [_agent.behavior setWeight:0.0 forGoal:_stayonpath];
    [_agent.behavior setWeight:0.0 forGoal:_wander];
    _agent.maxSpeed=17;
    _agent.mass=2;
    __weak GKAgent2D*weakagent=_agent;
    __weak GKGoal*weakseektarget=_seektarget;
    __weak GKGoal*weakstayonpath=_stayonpath;
    __weak GKGoal*weakwander=_wander;
    __weak waver*weakself=self;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:10.0],[SKAction runBlock:^{[weakagent.behavior setWeight:0.0 forGoal:weakseektarget];[weakagent.behavior setWeight:10.0 forGoal:weakstayonpath];[weakagent.behavior setWeight:15.0 forGoal:weakwander];weakagent.maxSpeed=12;weakagent.mass=5;}],[SKAction waitForDuration:7.0],[SKAction runBlock:^{weakself.attacking=NO;}]]]];
}

-(void)enemytoplayerandmelee:(GameLevelScene *)scene{
    [self updateWithDeltaTime:scene.delta andPlayerpos:scene.player.position];
    if(fabs(scene.player.position.x-self.position.x)<40 && fabs(scene.player.position.y-self.position.y)<60 && !self.attacking){
        [self attack];
    }
    if(CGRectIntersectsRect(scene.player.frame,CGRectInset(self.frame,2,0))){
        [scene enemyhitplayerdmgmsg:15];
    }
    if(scene.player.meleeinaction && !scene.player.meleedelay && CGRectIntersectsRect([scene.player meleeBoundingBoxNormalized],self.frame)){
        //NSLog(@"meleehit");
        [scene.player runAction:scene.player.meleedelayac];
        [self hitByMeleeWithArrayToRemoveFrom:scene.enemies];
    }
}

/*-(void)dealloc{
    NSLog(@"waver deallocated");
}*/

@end
