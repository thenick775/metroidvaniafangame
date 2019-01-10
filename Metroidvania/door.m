//
//  door.m
//  Metroidvania
//
//  Created by nick vancise on 12/1/18.
//

#import "door.h"


@implementation door{
    SKAction*_open;
    SKAction*_close;
    SKSpriteNode*_meniscus;
}

-(instancetype)initWithTextureAtlas:(SKTextureAtlas *)texatlas hasMarker:(BOOL)hasMarker andNames:(NSArray*)names{//marker used to distinguish between doors with/without a meniscus on the westward side
    self=[super initWithTexture:[texatlas textureNamed:names[0]]];
    if(self!=nil){
        self.passable=NO;
        self.anchorPoint=CGPointMake(1,0);
        self.zPosition=17;
        self.openAlready=NO;
        
        NSMutableArray*animationNames=[[NSMutableArray alloc] init];
        NSMutableArray*meniscusAnimationNames=[[NSMutableArray alloc] init];
        
        
        BOOL markerfound=NO;
        for(NSString*thename in names){
            SKTexture*temptex=[texatlas textureNamed:thename];
            if([thename isEqualToString:@"marker"]){
                markerfound=YES;
                continue;
            }
            if(!markerfound){
            [animationNames addObject:temptex];
            }
            else{
            [meniscusAnimationNames addObject:temptex];
            }
        }
        
        if(hasMarker){
            _meniscus=[SKSpriteNode spriteNodeWithTexture:meniscusAnimationNames[0]];
            _meniscus.position=CGPointMake(-(self.size.width+3),32);
            [self addChild:_meniscus];
            SKAction*openac=[SKAction animateWithTextures:[animationNames copy] timePerFrame:0.08];
            SKAction*meniscusac=[SKAction animateWithTextures:meniscusAnimationNames timePerFrame:0.08];
            __weak SKSpriteNode*weakmeniscus=_meniscus;
            _open=[SKAction group:@[openac,[SKAction runBlock:^{[weakmeniscus runAction:meniscusac];}]]];
            _close=[SKAction group:@[[openac reversedAction],[SKAction runBlock:^{[weakmeniscus runAction:[meniscusac reversedAction]];}]]];
        }
        else{
        _open=[SKAction animateWithTextures:[animationNames copy] timePerFrame:0.1];
        _close=_open.reversedAction;
        }
      
    }
    return self;
}

-(void)opendoor{
    __weak door*weakdoor=self;
    __weak SKAction*weakdoorclose=_close;
    self.openAlready=YES;
    [self runAction:_open completion:^{weakdoor.passable=YES;[weakdoor runAction:[SKAction sequence:@[[SKAction waitForDuration:2.3],weakdoorclose]] completion:^{weakdoor.passable=NO;weakdoor.openAlready=NO;}];}];
}

-(void)handleCollisionsWithPlayer:(Player*)player{
    if(fabs((player.position.x-self.position.x)<180) && CGRectIntersectsRect(self.frame, player.frame) && !self.passable){
        //CGRect intersection=CGRectIntersection(self.frame, player.frame);
        
        if(player.position.x-self.position.x<0)
            player.desiredPosition=CGPointMake(player.desiredPosition.x-0.85/*intersection.size.width*/, player.desiredPosition.y);
        else
            player.desiredPosition=CGPointMake(player.desiredPosition.x+0.85/*intersection.size.width*/, player.desiredPosition.y);
        
    }
}

@end
