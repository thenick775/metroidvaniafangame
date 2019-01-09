//
//  door.h
//  Metroidvania
//
//  Created by nick vancise on 12/1/18.
//

#include <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface door : SKSpriteNode

@property (nonatomic,assign) BOOL passable;
@property (nonatomic,assign) BOOL openAlready;
-(instancetype)initWithTextureAtlas:(SKTextureAtlas*)texatlas hasMarker:(BOOL)hasMarker andNames:(NSArray*)names;
-(void)opendoor;
-(void)handleCollisionsWithPlayer:(Player*)player;

@end
