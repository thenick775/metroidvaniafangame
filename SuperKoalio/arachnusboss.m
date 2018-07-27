//
//  arachnusboss.m
//  Metroidvania
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
    
    SKAction *slashprojmoveanim;
}

-(instancetype)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname=name;
    if(self == [super initWithImageNamed:weakname]){
        self.health=150;
        
        SKTextureAtlas *arachnustextures=[SKTextureAtlas atlasNamed:@"Arachnus"];
        
        //initialize movements
        
        
        
        //initialize projectiles
        self.slashprojectile=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"arachnus_slash_1.png"]];
        NSArray*projtextures=@[[arachnustextures textureNamed:@"arachnus_slash_1.png"],[arachnustextures textureNamed:@"arachnus_slash_2.png"],[arachnustextures textureNamed:@"arachnus_slash_3.png"],[arachnustextures textureNamed:@"arachnus_slash_4.png"]];
        slashprojmoveanim=[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:[SKAction animateWithTextures:projtextures timePerFrame:0.05 resize:YES restore:YES] count:10],[SKAction moveBy:CGVectorMake(300,0) duration:2.0], nil]];
        
       
        //initialize animations
        NSArray *morphtoballrighttex=@[[arachnustextures textureNamed:@"toball_1.png"],[arachnustextures textureNamed:@"toball_2.png"],[arachnustextures textureNamed:@"toball_3.png"],[arachnustextures textureNamed:@"toball_4.png"]];
        SKAction *morphtoballrightanim=[SKAction animateWithTextures:morphtoballrighttex timePerFrame:0.15 resize:YES restore:YES];
        
        NSArray *ballrighttex=@[[arachnustextures textureNamed:@"ball_1.png"],[arachnustextures textureNamed:@"ball_2.png"],[arachnustextures textureNamed:@"ball_3.png"],[arachnustextures textureNamed:@"ball_4.png"]];
        SKAction *ballattackrightanim=[SKAction animateWithTextures:ballrighttex timePerFrame:0.06 resize:YES restore:YES];
        
        
        
        NSArray *moveforewardtex=@[[arachnustextures textureNamed:@"walk_1.png"],[arachnustextures textureNamed:@"walk_2.png"],[arachnustextures textureNamed:@"walk_3.png"],[arachnustextures textureNamed:@"walk_4.png"],[arachnustextures textureNamed:@"walk_5.png"],[arachnustextures textureNamed:@"walk_6.png"],[arachnustextures textureNamed:@"walk_7.png"],[arachnustextures textureNamed:@"walk_8.png"],[arachnustextures textureNamed:@"walk_9.png"],[arachnustextures textureNamed:@"walk_10.png"],[arachnustextures textureNamed:@"walk_11.png"],[arachnustextures textureNamed:@"walk_12.png"]];
        SKAction *moveforewardanim=[SKAction animateWithTextures:moveforewardtex timePerFrame:0.08 resize:YES restore:YES];
        
        
        NSArray *fireattackrighttex=@[[arachnustextures textureNamed:@"spitfire_1.png"],[arachnustextures textureNamed:@"spitfire_2.png"],[arachnustextures textureNamed:@"spitfire_3.png"],[arachnustextures textureNamed:@"spitfire_4.png"],[arachnustextures textureNamed:@"spitfire_5.png"]];
        SKAction *fireattackrightanim=[SKAction animateWithTextures:fireattackrighttex timePerFrame:0.17 resize:YES restore:YES];
        
        
        NSArray *slashrightex=@[[arachnustextures textureNamed:@"slash_1.png"],[arachnustextures textureNamed:@"slash_2.png"],[arachnustextures textureNamed:@"slash_3.png"],[arachnustextures textureNamed:@"slash_4.png"],[arachnustextures textureNamed:@"slash_5.png"],[arachnustextures textureNamed:@"slash_6.png"],[arachnustextures textureNamed:@"slash_7.png"],[arachnustextures textureNamed:@"slash_8.png"],[arachnustextures textureNamed:@"slash_9.png"],[arachnustextures textureNamed:@"slash_10.png"],[arachnustextures textureNamed:@"slash_11.png"],[arachnustextures textureNamed:@"slash_12.png"],[arachnustextures textureNamed:@"slash_13.png"],[arachnustextures textureNamed:@"slash_14.png"],[arachnustextures textureNamed:@"slash_15.png"]];
        SKAction *slashrightanim=[SKAction animateWithTextures:slashrightex timePerFrame:0.09 resize:YES restore:YES];
        
        
        NSArray *turnrighttex=@[[arachnustextures textureNamed:@"turn_1.png"],[arachnustextures textureNamed:@"turn_2.png"],[arachnustextures textureNamed:@"turn_3.png"],[arachnustextures textureNamed:@"turn_4.png"]];
        SKAction *turnrightanim=[SKAction animateWithTextures:turnrighttex timePerFrame:0.2 resize:YES restore:YES];
        
        
        NSArray *recievedamagetex=@[[arachnustextures textureNamed:@"damage_scream_1.png"],[arachnustextures textureNamed:@"damage_scream_2.png"],[arachnustextures textureNamed:@"damage_scream_3.png"],[arachnustextures textureNamed:@"damage_scream_4.png"],[arachnustextures textureNamed:@"damage_scream_5.png"]];
        SKAction *recievedamagerightanim=[SKAction animateWithTextures:recievedamagetex timePerFrame:0.15 resize:YES restore:YES];
        
        self.testallactions=/*[SKAction repeatActionForever:*/[SKAction sequence:[NSArray arrayWithObjects:morphtoballrightanim,ballattackrightanim,ballattackrightanim,ballattackrightanim,moveforewardanim,moveforewardanim,moveforewardanim,fireattackrightanim,slashrightanim,turnrightanim,recievedamagerightanim, nil]];//];
        
        //initialize attacks
        
        
        
    }
    
    return self;
}

@end
