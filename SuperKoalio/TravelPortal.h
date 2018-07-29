//
//  TravelPortal.h
//  Metroidvania
//
//  Created by nick vancise on 6/1/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteKit/SpriteKit.h"

@interface TravelPortal : SKSpriteNode

-(instancetype)initWithStuff:(NSString*)name;
-(CGRect)collisionBoundingBox;

@end
