//
//  TravelPortal.h
//  Metroidvania
//
//  Created by nick vancise on 6/1/18.
//

#import <Foundation/Foundation.h>
#import "SpriteKit/SpriteKit.h"

@interface TravelPortal : SKSpriteNode

-(instancetype)initWithImage:(NSString*)name;
-(CGRect)collisionBoundingBox;

@end
