//
//  powerupBubble.m
//  Metroidvania
//
//  Created by nick vancise on 3/28/19.
//

#import "powerupBubble.h"

@implementation powerupBubble

-(instancetype)initWithPosition:(CGPoint)pos andCenter:(CGPoint)center andTexAtlas:(SKTextureAtlas*)atlas{
    self=[super initWithTexture:[atlas textureNamed:@"powerup_bubble1.png"]];
    if(self!=nil){
    
        self.position=CGPointMake(pos.x,pos.y);
        [self setScale:0.8];
        self.zPosition=0;
        self.served=NO;
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction animateWithTextures:@[[atlas textureNamed:@"powerup_bubble1.png"],[atlas textureNamed:@"powerup_bubble2.png"],[atlas textureNamed:@"powerup_bubble3.png"],[atlas textureNamed:@"powerup_bubble4.png"],[atlas textureNamed:@"powerup_bubble5.png"],[atlas textureNamed:@"powerup_bubble6.png"]] timePerFrame:0.2 resize:NO restore:YES],[SKAction waitForDuration:1.7]]]]];
    
        self.effectNode = [[SKEffectNode alloc] init];
        self.effectNode.shouldRasterize = true;
        CGFloat glowradius=self.size.width/2;
        self.effectNode.position=CGPointZero;
        self.effectNode.zPosition=self.zPosition+1;
        self.effectNode.blendMode=SKBlendModeAdd;
        id objects[] = {@(glowradius+15)};
        id keys[] = {@"inputRadius"};
        NSUInteger count = sizeof(objects) / sizeof(id);
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys
                                                                 count:count];
        self.effectNode.filter=[CIFilter filterWithName:@"CIGaussianBlur" withInputParameters:dictionary];
        //effectNode.filter[CIFilter filter];
        
        __weak powerupBubble*weakself=self;
        CGPoint origpos=self.position;
        SKSpriteNode*doublebub=[SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(self.size.width+10, self.size.height+10)];
        doublebub.zPosition=self.zPosition+1;
        doublebub.position=CGPointZero;
        [self.effectNode addChild:doublebub];
        self.gainPowerup=[SKAction sequence:@[[SKAction runBlock:^{weakself.served=YES;}],[SKAction moveTo:CGPointMake(origpos.x+30,origpos.y+45) duration:1.2],[SKAction runBlock:^{[weakself addChild:weakself.effectNode];}],[SKAction waitForDuration:0.8],[SKAction moveTo:origpos duration:0.05],[SKAction runBlock:^{[weakself removeAllChildren];}]]];
        
    }
    return self;
}


-(void)setgainac:(CGPoint)point{
    __weak powerupBubble*weakself=self;
        self.gainPowerup=[SKAction sequence:@[[SKAction runBlock:^{weakself.served=YES;}],[SKAction moveTo:CGPointMake(weakself.position.x+30,weakself.position.y+45) duration:1.2],[SKAction runBlock:^{[weakself addChild:weakself.effectNode];}],[SKAction waitForDuration:0.8],[SKAction moveTo:point duration:0.05],[SKAction runBlock:^{[weakself removeAllChildren];[weakself removeFromParent];}]]];

}

-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray *)arr withHit:(int)hit{}
-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray *)arr{
    [self removeAllActions];
    [self removeAllChildren];
    __weak enemyBase*weakself=self;
    [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
    [arr removeObject:self];
}


-(void)enemytoplayerandmelee:(GameLevelScene *)scene{
    if(CGRectIntersectsRect(self.frame,scene.player.frame) && self.served!=YES){
        //NSLog(@"player intersecting powerupbub");
        [scene.player removeMovementAnims];
        [scene.player resetTex];
        scene.player.lockmovement=YES;
        scene.player.goForeward=NO;
        scene.player.goBackward=NO;
        scene.player.shouldJump=NO;
        __weak GameLevelScene*weakself=scene;
        __weak powerupBubble*weakenemyconcop=self;
        [self setgainac:scene.player.position];
        [self runAction:self.gainPowerup completion:^{weakself.player.paused=NO;weakself.player.lockmovement=NO;[weakself enemyhitplayerdmgmsg:0];[weakself.player switchbeamto:@"chargereg"];[weakenemyconcop hitByMeleeWithArrayToRemoveFrom:weakself.enemies];}];
    }
}


/*-(void)dealloc{
    NSLog(@"powerupBubble deallocated");
}*/

@end
