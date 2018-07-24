//
//  arachnusboss.m
//  SuperKoalio
//
//  Created by nick vancise on 7/23/18.


#import "arachnusboss.h"

@implementation arachnusboss{
    SKAction *moveforeward;
    SKAction *movebackward;
    SKAction *fireattackleft;
    SKAction *fireattackright;
    SKAction *morphballattackright;
    SKAction *morphballattackleft;
    SKAction *slashattackleft;
    SKAction *slashattackright;
    SKAction *turnleft;
    SKAction *turnright;
    SKAction *recievedamage;
}

-(instancetype)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname;
    if(self == [super initWithImageNamed:weakname]){
        self.health=150;
        
        SKTextureAtlas *arachnustextures=[SKTextureAtlas atlasNamed:@"Arachnus"];
        
        //initialize movements
        
        
        
        //initialize projectiles
        
        
        
       
        //initialize animations
        NSArray *morphtoballrighttex=@[[arachnustextures textureNamed:@"toball_1.png"],[arachnustextures textureNamed:@"toball_2.png"],[arachnustextures textureNamed:@"toball_3.png"],[arachnustextures textureNamed:@"toball_4.png"]];
        SKAction *morphtoballright=[SKAction animateWithTextures:morphtoballtex timePerFrame:<#(NSTimeInterval)#>];
        
        NSArray *ballrighttex=@[[arachnustextures textureNamed:@"ball_1.png"],[arachnustextures textureNamed:@"ball_2.png"],[arachnustextures textureNamed:@"ball_3.png"],[arachnustextures textureNamed:@"ball_4.png"]];
        SKAction *ballattackright=[SKAction animateWithTextures:ballrighttex timePerFrame:<#(NSTimeInterval)#>];
        
        
        
        NSArray *moveforewardtex=@[[arachnustextures textureNamed:@"walk_1.png"],[arachnustextures textureNamed:@"walk_2.png"],[arachnustextures textureNamed:@"walk_3.png"],[arachnustextures textureNamed:@"walk_4.png"],[arachnustextures textureNamed:@"walk_5.png"],[arachnustextures textureNamed:@"walk_6.png"],[arachnustextures textureNamed:@"walk_7.png"],[arachnustextures textureNamed:@"walk_8.png"],[arachnustextures textureNamed:@"walk_9.png"],[arachnustextures textureNamed:@"walk_10.png"],[arachnustextures textureNamed:@"walk_11.png"],[arachnustextures textureNamed:@"walk_12.png"]];
        

        
        //initialize attacks
        
        
        
    }
    
    return self;
}

@end
