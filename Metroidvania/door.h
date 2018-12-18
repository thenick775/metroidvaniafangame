//
//  door.h
//  Metroidvania
//
//  Created by nick vancise on 12/1/18.
//

#include <SpriteKit/SpriteKit.h>

@interface door : SKSpriteNode

@property (nonatomic,assign) BOOL passable;

-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)texatlas andNames:(NSArray*)names;
-(void)opendoor;

@end
