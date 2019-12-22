//
//  PlayerProjectile.m
//  Metroidvania
//
//  Created by nick vancise on 5/25/18.


#import "PlayerProjectile.h"


@implementation PlayerProjectile{
    SKAction *_fireaction;
    SKAction *_bulletanim;
    NSArray *_bulletframes;
    NSArray  *_bullettexswitch;
    SKAction *_fixsize;
    SKSpriteNode *_temp;
    SKAction *_tempaction;
}

-(instancetype)initWithPos:(CGPoint)pos andMag_Range:(int)mag_range andType:(NSString*)type andDirection:(BOOL) direction hit:(int)hit{ //direction:true==forewards false==backwards
    self=[super initWithImageNamed:@"samus_projectile1.png"];
    if(self != nil){
        self.size=CGSizeMake(9,9);
        SKTextureAtlas *bullet=[SKTextureAtlas atlasNamed:@"projectiles"];
        CGVector projvector= direction ? CGVectorMake(mag_range,0) : CGVectorMake(-mag_range,0);
        self.position= direction ? CGPointMake(pos.x+12, pos.y+4) : CGPointMake(pos.x-12, pos.y+4);
        self.xScale=direction ? -1 : 1;
        self.cleanup=NO;
        self.hit=hit;
        
        if([type isEqualToString:@"default"]){
            _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
            _bullettexswitch=@[[bullet textureNamed:@"samus_projectileoddsleft.png"],[bullet textureNamed:@"samus_projectileevensleft.png"]];
            _fixsize=[SKAction setTexture:[bullet textureNamed:@"samus_projectileoddsleft.png"] resize:YES];
        }
        else if([type isEqualToString:@"plasma"]){
            _bulletframes=@[[bullet textureNamed:@"samus_plasma1.png"],[bullet textureNamed:@"samus_plasma2.png"]];
            _bullettexswitch=@[[bullet textureNamed:@"plasmabeamodd.png"],[bullet textureNamed:@"plasmabeameven.png"]];
            _fixsize=[SKAction sequence:@[[SKAction setTexture:[bullet textureNamed:@"plasmabeamodd.png"] resize:YES],[SKAction scaleTo:0.6 duration:0]]];
        }
        else if([type isEqualToString:@"chargereg"]){
            _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
            _bullettexswitch=@[[bullet textureNamed:@"charge_odd1.png"],[bullet textureNamed:@"charge_even1.png"]];
            _fixsize=[SKAction sequence:@[[SKAction setTexture:[bullet textureNamed:@"charge_odd1.png"] resize:YES]]];
        }
        else if([type isEqualToString:@"charge"]){
            _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
            _bullettexswitch=@[[bullet textureNamed:@"charge_ch1.png"],[bullet textureNamed:@"charge_ch2.png"]];
            _fixsize=[SKAction sequence:@[[SKAction setTexture:[bullet textureNamed:@"charge_ch1.png"] resize:YES]]];
            
            _temp=[SKSpriteNode spriteNodeWithTexture:[bullet textureNamed:@"charge_follower1.png"]];
            _temp.position=CGPointMake(15,0);
            _tempaction=[SKAction animateWithTextures:@[[bullet textureNamed:@"charge_follower1.png"],[bullet textureNamed:@"charge_follower2.png"],[bullet textureNamed:@"charge_follower3.png"],[bullet textureNamed:@"charged_follower4.png"],[bullet textureNamed:@"charged_follower5.png"],] timePerFrame:0.06 resize:YES restore:NO];
            __weak SKSpriteNode*weaktemp=_temp;
            __weak PlayerProjectile*weakself=self;
            __weak SKAction*weaktempaction=_tempaction;
            SKAction*projblk=[SKAction runBlock:^{
                SKSpriteNode*tmpcpy=weaktemp.copy;
                __weak SKSpriteNode*weaktmpcpy=tmpcpy;
                [tmpcpy runAction:[SKAction moveBy:CGVectorMake(75,0) duration:0.3] completion:^{[weaktmpcpy removeAllActions];[weaktmpcpy removeFromParent];}];
                [tmpcpy runAction:weaktempaction completion:^{[weaktmpcpy removeAllActions];[weaktmpcpy removeFromParent];}];
                [weakself addChild:tmpcpy];
            }];
            [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],[SKAction repeatAction:[SKAction sequence:@[projblk,[SKAction waitForDuration:0.2]]] count:10]]]];
        }
        
        _bulletanim=[SKAction animateWithTextures:_bulletframes timePerFrame:0.03];
        _fireaction=[SKAction moveBy:projvector duration:1];
        
        SKAction *bulletswitch=[SKAction repeatAction:[SKAction animateWithTextures:_bullettexswitch timePerFrame:0.1] count:5];
        NSArray *firegroup=@[bulletswitch,_fireaction];
        SKAction *fireaction=[SKAction group:firegroup];
        NSArray *actionseq=@[_bulletanim,_fixsize,fireaction];
        SKAction *bulletseq=[SKAction sequence:actionseq];
        
        [self runAction:bulletseq completion:^{self.cleanup=YES;}];
    }
    return self;
}


/*-(void)dealloc{
    NSLog(@"deallocating bullet");
}*/


@end
