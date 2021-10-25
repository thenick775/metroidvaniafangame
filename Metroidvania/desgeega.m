//
//  desgeega.m
//  Metroidvania
//
//  Created by nick vancise on 8/23/19.
//

#import "desgeega.h"

@implementation desgeega{
    SKTextureAtlas*_destex;
    float _height;
    float _dist;
    CGPoint _origpos;
    NSTimeInterval _storetime;
    SKAction *_idle,*_attack,*_jmpright,*_jmpleft,*_idleac,*_hangs;
    int _attackcount;
    vector_float2 _constrs;
}

-(instancetype)initWithPosition:(CGPoint)pos andPosConst:(SKRange*)constr andJmpHeight:(float)height andJmpDist:(float)dist{
    _destex=[SKTextureAtlas atlasNamed:@"desgeega"];
    self = [super initWithTexture:[_destex textureNamed:@"desgeega1.png"]];
    if(self!=nil){
        self.health=50;
        self.dead=NO;
        self.dx=0;
        self.dy=0;
        self.position=pos;
        self.agentSystem=[[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
        self.target=[[GKAgent2D alloc]init];
        self.target.radius=7;
        self.target.delegate=nil;
        _origpos=pos;
        _height=height;
        _dist=dist;
        _attackcount=0;
        self.projectilesInAction=[[NSMutableArray alloc] init];
        _constrs[0]=constr.lowerLimit;
        _constrs[1]=constr.upperLimit;
        self.constraints=@[[SKConstraint positionX:constr]];
        
        _idle=[SKAction repeatAction:[SKAction animateWithTextures:@[[_destex textureNamed:@"desgeega5.png"],[_destex textureNamed:@"desgeega6.png"],[_destex textureNamed:@"desgeega7.png"],[_destex textureNamed:@"desgeega8.png"],[_destex textureNamed:@"desgeega9.png"],[_destex textureNamed:@"desgeega10.png"],[_destex textureNamed:@"desgeega11.png"],[_destex textureNamed:@"desgeega12.png"],[_destex textureNamed:@"desgeega13.png"],[_destex textureNamed:@"desgeega14.png"],[_destex textureNamed:@"desgeega15.png"],[_destex textureNamed:@"desgeega19.png"],[_destex textureNamed:@"desgeega20.png"],[_destex textureNamed:@"desgeega21.png"]] timePerFrame:0.2 resize:YES restore:NO] count:2];
        
        __weak desgeega*weakself=self;
        
        _attack=[SKAction group:@[[SKAction sequence:@[[SKAction waitForDuration:0.15],[SKAction runBlock:^{weakself.attacking=YES;[weakself projectileAttack];}]]],[SKAction animateWithTextures:@[[_destex textureNamed:@"desgeega1.png"],[_destex textureNamed:@"desgeega2.png"],[_destex textureNamed:@"desgeega3.png"],[_destex textureNamed:@"desgeega4.png"]] timePerFrame:0.13 resize:YES restore:NO]]];
        
        _jmpright=[SKAction group:@[[SKAction repeatAction:[SKAction animateWithTextures:@[[_destex textureNamed:@"desgeega16.png"],[_destex textureNamed:@"desgeega17.png"],[_destex textureNamed:@"desgeega18.png"]] timePerFrame:0.2 resize:YES restore:NO] count:2],[SKAction runBlock:^{[weakself runBezierRight];}]]];
        
        _jmpleft=[SKAction group:@[[SKAction repeatAction:[SKAction animateWithTextures:@[[_destex textureNamed:@"desgeega16.png"],[_destex textureNamed:@"desgeega17.png"],[_destex textureNamed:@"desgeega18.png"]] timePerFrame:0.2 resize:YES restore:NO] count:2],[SKAction runBlock:^{[weakself runBezierLeft];}]]];
        _hangs=[SKAction runBlock:^{[weakself setHanger];}];
        _idleac=[SKAction repeatActionForever:[SKAction sequence:@[_idle,_hangs,_jmpright,_hangs,_idle,_jmpright,_idle,_jmpleft,_idle,_jmpleft,_idle,_hangs,_jmpright,_hangs,_idle,_jmpleft,_hangs]]];
                 
                 
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:(float)arc4random_uniform(200)/100],_idleac]]];
        
    }
    return self;
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds{
    
    if(seconds<0.16)
        seconds=0.16;
    else if(seconds>0.18)
        seconds=0.18;
    
    _storetime=seconds;
    
    [self.agentSystem updateWithDeltaTime:seconds];
}

-(void)runBezierRight{
    UIBezierPath *projpathright=[UIBezierPath bezierPath];
    [projpathright moveToPoint:self.position];
    [projpathright addQuadCurveToPoint:CGPointMake(self.position.x+_dist, _origpos.y) controlPoint:CGPointMake(self.position.x+(_dist*0.75), self.position.y+_height)];
    
    [self runAction:[SKAction followPath:projpathright.CGPath asOffset:NO orientToPath:NO duration:1.2]];
}

-(void)runBezierLeft{
    UIBezierPath *projpathleft=[UIBezierPath bezierPath];
    [projpathleft moveToPoint:self.position];
    [projpathleft addQuadCurveToPoint:CGPointMake(self.position.x-_dist, _origpos.y) controlPoint:CGPointMake(self.position.x-(_dist*0.75), self.position.y+_height)];
    
    [self runAction:[SKAction followPath:projpathleft.CGPath asOffset:NO orientToPath:NO duration:1.2]];
}

-(void)setHanger{
    desgeegaproj*tmpproj=[[desgeegaproj alloc] initWithPosition:CGPointMake(self.position.x-15, self.position.y) andTex:_destex isHanger:YES];
    desgeegaproj*tmpproj2=[[desgeegaproj alloc] initWithPosition:CGPointMake(self.position.x+15, self.position.y) andTex:_destex isHanger:YES];
    SKAction*moveleft=[SKAction moveTo:CGPointMake(self.position.x-15, self.position.y+((float)arc4random_uniform(40)-20)+10) duration:0.5];
    SKAction*moveright=[SKAction moveTo:CGPointMake(self.position.x+15, self.position.y+((float)arc4random_uniform(40)-20)+10) duration:0.5];
    tmpproj.zPosition=self.zPosition+1;
    tmpproj2.zPosition=self.zPosition+1;
    [self.parent addChild:tmpproj];
    [tmpproj runAction:moveleft];
    [self.parent addChild:tmpproj2];
    [tmpproj2 runAction:moveright];
    [self.projectilesInAction addObject:tmpproj];
    [self.projectilesInAction addObject:tmpproj2];
}

-(void)projectileAttack{
    for(int i=0;i<5;i++){
        [self setHanger];
    }
    /*if(_attackcount++<1){
        __weak GKComponentSystem *weakagentSystem=self.agentSystem;
        __weak NSMutableArray*weakprojectilesinaction=self.projectilesInAction;
        for(int i=0;i<4;i++){
            desgeegaproj*tmpprojright=[[desgeegaproj alloc] initWithPosition:CGPointMake(self.position.x+15,self.position.y-i) andTex:_destex isHanger:NO];
            desgeegaproj*tmpprojleft=[[desgeegaproj alloc] initWithPosition:CGPointMake(self.position.x-15,self.position.y-i) andTex:_destex isHanger:NO];
        
            __weak desgeegaproj*weaktmpprojright=tmpprojright;
            __weak desgeegaproj*weaktmpprojleft=tmpprojleft;
        
            [tmpprojleft runAction:[SKAction sequence:@[[SKAction waitForDuration:5.0],tmpprojleft.projectileexplode]] completion:^{NSLog(@"removing");[weakagentSystem removeComponent:weaktmpprojleft.agent];[weaktmpprojleft removeFromParent];[weakprojectilesinaction removeObject:weaktmpprojleft];}];
            [tmpprojright runAction:[SKAction sequence:@[[SKAction waitForDuration:5.0],tmpprojright.projectileexplode]] completion:^{[weakagentSystem removeComponent:weaktmpprojright.agent];[weaktmpprojright removeFromParent];[weakprojectilesinaction removeObject:weaktmpprojright];}];
        
            [self.parent addChild:tmpprojleft];
            [self.agentSystem addComponent:tmpprojleft.agent];
            [self.projectilesInAction addObject:tmpprojleft];
            [self.parent addChild:tmpprojright];
            [self.agentSystem addComponent:tmpprojright.agent];
            [self.projectilesInAction addObject:tmpprojright];
        }
    
        GKBehavior*seek=[GKBehavior behaviorWithGoals:@[[GKGoal goalToInterceptAgent:self.target maxPredictionTime:1.5],[GKGoal goalToSeparateFromAgents:self.agentSystem.components maxDistance:35 maxAngle:2*M_PI]] andWeights:@[@10,@100]];
    
        for(GKAgent2D *thisagent in weakagentSystem.components){
            thisagent.behavior=seek;
        }
    }*/
}

-(SKAction*)flee:(CGPoint)playerpos{//the nested ternary operators here were done just for fun
    return [SKAction group:@[_attack,(self.position.x-playerpos.x>0) ? ((self.position.x>_constrs[1]-_dist)?_jmpleft:_jmpright):((self.position.x<_constrs[0]+_dist)?_jmpright:_jmpleft)]];
}

-(SKAction*)recenter{
    if(fabs(self.position.x-((_constrs[1]+_constrs[0])/2))<25)
        return _idleac;
    return (((_constrs[1]+_constrs[0])/2)>self.position.x)? [SKAction sequence:@[_idle,_jmpright]]:[SKAction sequence:@[_idle,_jmpleft]];
}

-(void)enemytoplayerandmelee:(GameLevelScene *)scene{
    if(self.attacking){//handle updates and projectiles
        [self updateWithDeltaTime:scene.delta];
        CGPoint realpos=scene.player.position;
        self.target.position=vector2((float)realpos.x,(float)realpos.y);
        
        if(self.agentSystem.components.count==0){
            _attackcount=0;
            self.attacking=NO;
        }
    }
    
    if(CGRectIntersectsRect(scene.player.frame,CGRectInset(self.frame,2,0))){//damage to player from self and projectiles
        [scene enemyhitplayerdmgmsg:20];
    }
    if(scene.player.meleeinaction && !scene.player.meleedelay && CGRectIntersectsRect([scene.player meleeBoundingBoxNormalized],self.frame)){
        [scene.player runAction:scene.player.meleedelayac];
        [self hitByMeleeWithArrayToRemoveFrom:scene.enemies];
    }
    for(desgeegaproj*tmp in self.projectilesInAction){
        if(CGRectContainsPoint(scene.player.frame,tmp.position)){
            [scene enemyhitplayerdmgmsg:10];
        }
        if(tmp.ishanger){
            if(tmp.constraints==nil){
                tmp.constraints=@[[SKConstraint orientToNode:scene.player offset:[SKRange rangeWithConstantValue:M_PI]]];
            }
            if(fabs(scene.player.position.x-tmp.position.x)<80 && !tmp.istracking){
                tmp.istracking=YES;
                __weak desgeegaproj*weakhanger=tmp;
                __weak NSMutableArray*weakprojectilesinaction=self.projectilesInAction;
                float dur=[tmp calcSpeed:115 otherPoint:scene.player.position];
                [tmp runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveTo:scene.player.position duration:dur],[SKAction sequence:@[[SKAction waitForDuration:0.08],[SKAction runBlock:^{[weakhanger addTrail];}]]]]],[SKAction runBlock:^{[weakhanger removeAllChildren];[weakhanger removeFromParent];[weakprojectilesinaction removeObject:weakhanger];}]]]];
            }
        }
    }
    
}

-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray*)arr withHit:(int)hit{//default implementation
    self.health=self.health-hit;
    if(self.health<=0){
        [self removeAllActions];
        [self removeAllChildren];
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
    }
    else{
        __weak desgeega*weakself=self;
        __weak SKAction*weakidle=_idleac;
        [self removeAllActions];
        [self runAction:[self flee:CGPointMake(self.target.position[0], self.target.position[1])] completion:^{[weakself runAction:[SKAction repeatActionForever: weakidle]];}];
    }
    
}

-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray*)arr{
    self.health=self.health-10;
    NSLog(@"in melee");
    if(self.health<=0){
        [self removeAllActions];
        [self removeAllChildren];
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
    }
    else{
        __weak desgeega*weakself=self;
        __weak SKAction*weakidle=_idleac;
        [self removeAllActions];
        [self runAction:[self flee:CGPointMake(self.target.position[0], self.target.position[1])] completion:^{[weakself runAction:[SKAction repeatActionForever: weakidle]];}];
    }
}

-(void)dealloc{
 //NSLog(@"desgeega deallocated");
 for(GKAgent2D*tmp in self.agentSystem.components.reverseObjectEnumerator){
    [self.agentSystem removeComponent:tmp];
 }
 for(desgeegaproj*tmp in self.projectilesInAction.reverseObjectEnumerator){
     [self.projectilesInAction removeObject:tmp];
     [tmp removeAllChildren];
     [tmp removeFromParent];
 }
}

@end

@implementation desgeegaproj{
    SKEmitterNode*projemit;
}

-(instancetype)initWithPosition:(CGPoint)position andTex:(SKTextureAtlas*)tex isHanger:(BOOL)ishanger{
    self=[super initWithTexture:[tex textureNamed:@"desproj1.png"]];
    if (self!=nil){
        self.position=position;
        self.istracking=NO;
        if(!ishanger){
            self.agent=[[GKAgent2D alloc] init];
            self.agent.radius=self.size.height;
            self.agent.position=(vector_float2){(float)position.x,(float)position.y};
            self.agent.delegate=self;
            self.agent.maxSpeed=40;
            self.health=10;
            self.agent.maxAcceleration=20;
            self.agent.mass=4;
            self.xScale=-1;
            self.ishanger=NO;
        }
        else{
            projemit=[SKEmitterNode nodeWithFileNamed:@"desgeegahang.sks"];
            self.texture=[tex textureNamed:@"desprojh.png"];
            self.ishanger=YES;
        }
        
        self.projectileexplode=[SKAction animateWithTextures:@[[tex textureNamed:@"desproj2.png"],[tex textureNamed:@"desproj3.png"]] timePerFrame:0.15 resize:YES restore:NO];
    }
    return self;
}

- (void)agentWillUpdate:(nonnull GKAgent2D *)agent {
    agent.position=vector2((float)self.position.x,(float)self.position.y);
    agent.rotation=(float)self.zRotation;
}
- (void)agentDidUpdate:(nonnull GKAgent2D *)agent {
    self.position = CGPointMake((CGFloat)agent.position.x, (CGFloat)agent.position.y);
    self.zRotation = (CGFloat)agent.rotation;
}

-(void)addTrail{
    self.constraints.firstObject.enabled=false;
    [self addChild:projemit];
}

-(float)calcSpeed:(int)pps otherPoint:(CGPoint)point{
    float c=sqrtf(powf((self.position.y-point.y),2)+powf((self.position.x-point.x),2));
    return (c/pps);
}

/*-(void)dealloc{
    NSLog(@"desgeegaproj deallocated");
}*/

@end
