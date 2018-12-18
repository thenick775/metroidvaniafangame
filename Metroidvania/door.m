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
}

-(instancetype)initWithTextureAtlas:(SKTextureAtlas *)texatlas andNames:(NSArray*)names{
    self=[super initWithTexture:[texatlas textureNamed:names[0]]];
    if(self!=nil){
        self.passable=NO;
        self.anchorPoint=CGPointMake(1,0);
        self.zPosition=17;
        _open=[SKAction animateWithTextures:@[[texatlas textureNamed:names[0]],[texatlas textureNamed:names[1]],[texatlas textureNamed:names[2]]] timePerFrame:0.2];
        _close=_open.reversedAction;
        
    }
    return self;
}

-(void)opendoor{
    __weak door*weakdoor=self;
    __weak SKAction*weakdoorclose=_close;
    [self runAction:_open completion:^{weakdoor.passable=YES;[weakdoor runAction:[SKAction sequence:@[[SKAction waitForDuration:5.0],weakdoorclose]] completion:^{weakdoor.passable=NO;}];}];
}

@end
