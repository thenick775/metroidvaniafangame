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
    SKAction *fixsize;
}

-(instancetype)initWithPos:(CGPoint)pos andMag_Range:(int)mag_range andType:(NSString*)type andDirection:(BOOL) direction{ //true==forewards false==backwards
    self=[super initWithImageNamed:@"samus_projectile1.png"];
    if(self != nil){
        self.size=CGSizeMake(9,9);
        SKTextureAtlas *bullet=[SKTextureAtlas atlasNamed:@"projectiles"];
        CGVector projvector=CGVectorMake(/*180*/mag_range,0);
        self.cleanup=NO;
        
        if([type isEqualToString:@"default"]){
            if(direction){
                self.position=CGPointMake(pos.x+12, pos.y+4);
                _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"],[bullet textureNamed:@"samus_projectileoddsright.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"samus_projectileoddsright.png"],[bullet textureNamed:@"samus_projectileevensright.png"]];
            }
            else if(!direction){
                projvector=CGVectorMake(/*-180*/-mag_range,0);
                self.position=CGPointMake(pos.x-12, pos.y+4);
                _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"samus_projectileoddsleft.png"],[bullet textureNamed:@"samus_projectileevensleft.png"]];
            }
            fixsize=[SKAction setTexture:[bullet textureNamed:@"samus_projectileoddsleft.png"] resize:YES];
        }
        else if([type isEqualToString:@"plasma"]){
            //[self setScale:0.5];
            if(direction){
                self.position=CGPointMake(pos.x+12, pos.y+4);
                _bulletframes=@[[bullet textureNamed:@"samus_plasma1.png"],[bullet textureNamed:@"samus_plasma2.png"],[bullet textureNamed:@"plasmabeamodd.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"plasmabeamodd.png"],[bullet textureNamed:@"plasmabeameven.png"]];
            }
            else if(!direction){
                projvector=CGVectorMake(-mag_range,0);
                self.position=CGPointMake(pos.x-12, pos.y+4);
                _bulletframes=@[[bullet textureNamed:@"samus_plasma1.png"],[bullet textureNamed:@"samus_plasma2.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"plasmabeamodd.png"],[bullet textureNamed:@"plasmabeameven.png"]];
            }
            fixsize=[SKAction sequence:@[[SKAction setTexture:[bullet textureNamed:@"plasmabeamodd.png"] resize:YES],[SKAction scaleTo:0.6 duration:0]]];
        }
        else if([type isEqualToString:@"chargereg"]){
            if(direction){
                self.position=CGPointMake(pos.x+12, pos.y+4);
                self.xScale=-1;
                _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"],[bullet textureNamed:@"charge_odd1.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"charge_odd1.png"],[bullet textureNamed:@"charge_even1.png"]];
            }
            else if(!direction){
                projvector=CGVectorMake(-mag_range,0);
                self.position=CGPointMake(pos.x-12, pos.y+4);
                _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"charge_odd1.png"],[bullet textureNamed:@"charge_even1.png"]];
            }
            fixsize=[SKAction sequence:@[[SKAction setTexture:[bullet textureNamed:@"charge_odd1.png"] resize:YES]]];
        }
        else if([type isEqualToString:@"charge"]){
            if(direction){
                self.position=CGPointMake(pos.x+12, pos.y+4);
                self.xScale=-1;
                _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"],[bullet textureNamed:@"charge_ch1.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"charge_ch1.png"],[bullet textureNamed:@"charge_ch2.png"]];
            }
            else if(!direction){
                projvector=CGVectorMake(-mag_range,0);
                self.position=CGPointMake(pos.x-12, pos.y+4);
                _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
                _bullettexswitch=@[[bullet textureNamed:@"charge_ch1.png"],[bullet textureNamed:@"charge_ch2.png"]];
            }
            fixsize=[SKAction sequence:@[[SKAction setTexture:[bullet textureNamed:@"charge_ch1.png"] resize:YES]]];
        }
        
        
        _bulletanim=[SKAction animateWithTextures:_bulletframes timePerFrame:0.03];
        _fireaction=[SKAction moveBy:projvector duration:1];
        
        SKAction *bulletswitch=[SKAction repeatAction:[SKAction animateWithTextures:_bullettexswitch timePerFrame:0.1] count:5];
        NSArray *firegroup=@[bulletswitch,_fireaction];
        SKAction *fireaction=[SKAction group:firegroup];
        NSArray *actionseq=@[_bulletanim,fixsize,fireaction];
        SKAction *bulletseq=[SKAction sequence:actionseq];
        
        [self runAction:bulletseq completion:^{self.cleanup=YES;}];
    }
    return self;
}


/*-(void)dealloc{
    NSLog(@"deallocating bullet");
}*/


@end
