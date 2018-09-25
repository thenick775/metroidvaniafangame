//
//  PlayerProjectile.m
//  Metroidvania
//
//  Created by nick vancise on 5/25/18.


#import "PlayerProjectile.h"


@implementation PlayerProjectile{
    SKAction *_fireAction;
    SKAction *_bulletanim;
    NSArray *_bulletframes;
    NSArray  *_bullettexswitch;
}

-(instancetype)initWithPos:(CGPoint)pos andDirection:(BOOL) direction{ //true==forewards false==backwards
    self=[super initWithImageNamed:@"samus_projectile1.png"];
    
    if(self != NULL){
        self.size=CGSizeMake(9,9);
        SKTextureAtlas *bullet=[SKTextureAtlas atlasNamed:@"projectiles"];
        CGVector projvector=CGVectorMake(180,0);
        self.cleanup=NO;
        
        if(direction){
            self.position=CGPointMake(pos.x+12, pos.y+4);
            _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"],[bullet textureNamed:@"samus_projectileoddsright.png"]];
            _bullettexswitch=@[[bullet textureNamed:@"samus_projectileoddsright.png"],[bullet textureNamed:@"samus_projectileevensright.png"]];
        }
        else if(!direction){
            projvector=CGVectorMake(-180,0);
            self.position=CGPointMake(pos.x-12, pos.y+4);
            _bulletframes=@[[bullet textureNamed:@"samus_projectile1.png"],[bullet textureNamed:@"samus_projectile2.png"]];
            _bullettexswitch=@[[bullet textureNamed:@"samus_projectileoddsleft.png"],[bullet textureNamed:@"samus_projectileevensleft.png"]];
        }
        
        SKAction*fixsize=[SKAction setTexture:[bullet textureNamed:@"samus_projectileoddsleft.png"] resize:YES];
        _bulletanim=[SKAction animateWithTextures:_bulletframes timePerFrame:0.03];
        _fireAction=[SKAction moveBy:projvector duration:1];
        
        SKAction *bulletswitch=[SKAction repeatAction:[SKAction animateWithTextures:_bullettexswitch timePerFrame:0.1] count:5];
        NSArray *firegroup=@[bulletswitch,_fireAction];
        SKAction *fireaction=[SKAction group:firegroup];
        NSArray *actionseq=@[_bulletanim,fixsize,fireaction];
        SKAction *bulletseq=[SKAction sequence:actionseq];
        
        [self runAction:bulletseq completion:^{self.cleanup=YES;}];
    }
    
    return self;
}


/*-(void)dealloc{
    NSLog(@"deallocatin bullet");
}*/


@end
