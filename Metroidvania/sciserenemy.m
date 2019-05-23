//
//  sciserenemy.m
//  Metroidvania
//
//  Created by nick vancise on 5/30/18.
//

#import "sciserenemy.h"

@implementation sciserenemy{
    SKAction *_moveaction;
    SKAction *_moveenemyforward;
    SKAction *_moveenemybackward;
    SKAction *_fireaction;
}

-(instancetype)initWithPos:(CGPoint)sciserpos{
    SKTextureAtlas  *sciseranimation=[SKTextureAtlas atlasNamed:@"Sciser"];
    SKTexture *stand=[sciseranimation textureNamed:@"scisser1.png"];
    __weak  SKTexture*weakstand=stand;
    self=[super initWithTexture:weakstand];
    if(self!=nil){
        self.health=10;
        self.dx=0;
        self.dy=0;
        //setup enemy pos/animations/etc here
        NSArray *moveanim=@[[sciseranimation textureNamed:@"scisser1.png"],[sciseranimation textureNamed:@"scisser2.png"],[sciseranimation textureNamed:@"scisser3.png"],[sciseranimation textureNamed:@"scisser4.png"]];
        NSArray *fireanim=@[[sciseranimation textureNamed:@"scisserfire1.png"],[sciseranimation textureNamed:@"scisserfire2.png"],[sciseranimation textureNamed:@"scisserfire3.png"],[sciseranimation textureNamed:@"scisserfire4.png"],[sciseranimation textureNamed:@"scisserfire5.png"],[sciseranimation textureNamed:@"scisserfire6.png"],[sciseranimation textureNamed:@"scisserfire7.png"],[sciseranimation textureNamed:@"scisserfire8.png"],[sciseranimation textureNamed:@"scisserfire9.png"]];
        
        CGVector forwardvec=CGVectorMake(150,0);
        CGVector backwardvec=CGVectorMake(-150,0);
        self.enemybullet1=[SKSpriteNode spriteNodeWithImageNamed:@"scisserprojectile2.png"];
        self.enemybullet2=[SKSpriteNode spriteNodeWithImageNamed:@"scisserprojectile2.png"];
        self.enemybullet1.position=CGPointMake(12,4);    //dependent on "self's" position
        self.enemybullet2.position=CGPointMake(-12,4);
        [self addChild:self.enemybullet1];
        [self addChild:self.enemybullet2];
        __weak sciserenemy*weakself=self;
        weakself.enemybullet1.hidden=YES;
        weakself.enemybullet2.hidden=YES;
        
        self.position=sciserpos;
        _moveaction=[SKAction animateWithTextures:moveanim timePerFrame:0.25];
        _fireaction=[SKAction animateWithTextures:fireanim timePerFrame:0.2];
        _moveenemyforward=[SKAction moveBy:forwardvec duration:3];
        _moveenemybackward=[SKAction moveBy:backwardvec duration:3];
        
        
        UIBezierPath *projpath1=[UIBezierPath bezierPath];
        [projpath1 moveToPoint:CGPointMake(0,0)];
        [projpath1 addQuadCurveToPoint:CGPointMake(42, -15) controlPoint:CGPointMake(40, 35)];
        UIBezierPath *projpath2=[UIBezierPath bezierPath];
        [projpath2 moveToPoint:CGPointMake(0,0)];
        [projpath2 addQuadCurveToPoint:CGPointMake(-42, -15) controlPoint:CGPointMake(-40, 35)];
      
        SKAction *letknowaction=[SKAction runBlock:^{
            /*weakenemybullet1.hidden=NO;
            weakenemybullet2.hidden=NO;*/
            weakself.enemybullet1.hidden=NO;
            weakself.enemybullet2.hidden=NO;
            [weakself.enemybullet1 runAction:[SKAction followPath:projpath1.CGPath duration:0.75] completion:^{weakself.enemybullet1.hidden=YES;weakself.enemybullet1.position=CGPointMake(12,4);}];
            [weakself.enemybullet2 runAction:[SKAction followPath:projpath2.CGPath duration:0.75] completion:^{weakself.enemybullet2.hidden=YES;weakself.enemybullet2.position=CGPointMake(-12,4);}];
        }];
        SKAction *waitac=[SKAction waitForDuration:1.0];
        NSArray  *waitletknow=@[waitac,letknowaction,waitac];
        SKAction *group=[SKAction group:[NSArray arrayWithObjects:_fireaction,waitletknow, nil]];//need to use arraywithobjects here
        
        NSArray *actionarr=@[_moveenemyforward,group,_moveenemybackward,group];
        
        
        [self runAction:[SKAction repeatActionForever:_moveaction]];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:actionarr]]];
    }
    
    
    
    return self;
}

-(void)enemytoplayerandmelee:(GameLevelScene *)scene{
    if(fabs(scene.player.position.x-self.position.x)<70){  //minimize comparisons
        //NSLog(@"in here");
        if(CGRectContainsPoint(scene.player.collisionBoundingBox, CGPointAdd(self.enemybullet1.position, self.position))){
            //NSLog(@"enemy hit player bullet#1");
            [self.enemybullet1 setHidden:YES];
            [scene enemyhitplayerdmgmsg:25];
        }
        else if(CGRectContainsPoint(scene.player.collisionBoundingBox,CGPointAdd(self.enemybullet2.position, self.position))){
            //NSLog(@"enemy hit player buller#2");
            [self.enemybullet2 setHidden:YES];
            [scene enemyhitplayerdmgmsg:25];
        }
        if(scene.player.meleeinaction && !scene.player.meleedelay && CGRectIntersectsRect([scene.player meleeBoundingBoxNormalized],self.frame)){
            //NSLog(@"meleehit");
            [scene.player runAction:scene.player.meleedelayac];
            [self hitByMeleeWithArrayToRemoveFrom:scene.enemies];
        }
    }
}

/*-(void)dealloc{
 NSLog(@"scisserenemy dealloc");
 }*/



@end
