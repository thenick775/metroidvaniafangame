//
//  arachnusboss.m
//  SuperKoalio
//
//  Created by nick vancise on 7/23/18.


#import "arachnusboss.h"

@implementation arachnusboss{
    SKAction *moveforeward;
    SKAction *movebackward;
    SKAction *fireleft;
    SKAction *fireright;
    SKAction *morphballattackleft;
    SKAction *morphballattackright;
    SKAction *slashattackleft;
    SKAction *slashattackright;
    SKAction *turnleft;
    SKAction *turnright;
    
}

-(instancetype)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname;
    if(self == [super initWithImageNamed:weakname]){
        self.health=150;
        
        SKTextureAtlas *arachnustextures=[SKTextureAtlas atlasNamed:@"Arachnus"];
        
        //initialize movements
        
        
        
        
        //initialize attacks
        
        
        
        //initialize projectiles
        
        
        
       
        //initialize animations
        
        
    }
    
    return self;
}

@end
