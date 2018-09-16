//
//  TravelPortal.m
//  Metroidvania
//
//  Created by nick vancise on 6/1/18.
//

#import "TravelPortal.h"


@implementation TravelPortal{
    SKAction *_appearaction;
    SKAction *_repeataction;
}


-(instancetype)initWithStuff:(NSString *)name{
    __weak NSString *weakname=name;
    if(self==[super initWithImageNamed:weakname]){
        SKTextureAtlas *portalatlas=[SKTextureAtlas atlasNamed:@"travelmirror"];
        
        NSArray *appeararray=@[[portalatlas textureNamed:@"mirror1.png"],[portalatlas textureNamed:@"mirror2.png"],[portalatlas textureNamed:@"mirror3.png"],[portalatlas textureNamed:@"mirror4.png"],[portalatlas textureNamed:@"mirror5.png"],[portalatlas textureNamed:@"mirror6.png"],[portalatlas textureNamed:@"mirror7.png"],[portalatlas textureNamed:@"mirror8.png"],[portalatlas textureNamed:@"mirror9.png"],[portalatlas textureNamed:@"mirror10.png"],[portalatlas textureNamed:@"mirror11.png"],[portalatlas textureNamed:@"mirror12.png"],[portalatlas textureNamed:@"mirror13.png"],[portalatlas textureNamed:@"mirror14.png"],[portalatlas textureNamed:@"mirror15.png"],[portalatlas textureNamed:@"mirror16.png"],[portalatlas textureNamed:@"mirror17.png"],[portalatlas textureNamed:@"mirror18.png"],[portalatlas textureNamed:@"mirror19.png"],[portalatlas textureNamed:@"mirror20.png"]];
       
        
        NSArray *repeatarray=@[[portalatlas textureNamed:@"mirror21.png"],[portalatlas textureNamed:@"mirror22.png"],[portalatlas textureNamed:@"mirror23.png"],[portalatlas textureNamed:@"mirror24.png"],[portalatlas textureNamed:@"mirror25.png"],[portalatlas textureNamed:@"mirror26.png"],[portalatlas textureNamed:@"mirror27.png"],[portalatlas textureNamed:@"mirror28.png"],[portalatlas textureNamed:@"mirror29.png"],[portalatlas textureNamed:@"mirror30.png"],[portalatlas textureNamed:@"mirror31.png"],[portalatlas textureNamed:@"mirror32.png"],[portalatlas textureNamed:@"mirror33.png"],[portalatlas textureNamed:@"mirror34.png"],[portalatlas textureNamed:@"mirror35.png"],[portalatlas textureNamed:@"mirror36.png"],[portalatlas textureNamed:@"mirror37.png"],[portalatlas textureNamed:@"mirror38.png"],[portalatlas textureNamed:@"mirror39.png"],[portalatlas textureNamed:@"mirror40.png"]];
        
        _appearaction=[SKAction animateWithTextures:appeararray timePerFrame:0.15];
        _repeataction=[SKAction animateWithTextures:repeatarray timePerFrame:0.15];
        __weak TravelPortal*weakself=self;
        __weak SKAction*weakrepeataction=_repeataction;
        [self runAction:_appearaction completion:^{[weakself runAction:[SKAction repeatActionForever:weakrepeataction]];}];
        
    }
    
    
    
    return self;
}

-(CGRect)collisionBoundingBox{
    CGRect portalrect=CGRectInset(self.frame,4,6);
    return portalrect;
}

/*-(void)dealloc{
 NSLog(@"travelportal dealloc");
 }*/

@end
