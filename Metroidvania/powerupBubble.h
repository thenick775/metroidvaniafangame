//
//  powerupBubble.h
//  Metroidvania
//
//  Created by nick vancise on 3/28/19.
//

#import <SpriteKit/SpriteKit.h>
#import "enemyBase.h"

@interface powerupBubble : enemyBase

@property(nonatomic,strong) SKAction* gainPowerup;
@property(nonatomic,assign) BOOL served;
@property(nonatomic,strong) SKEffectNode*effectNode;

-(instancetype)initWithPosition:(CGPoint)pos andCenter:(CGPoint)center andTexAtlas:(SKTextureAtlas*)atlas;
-(void)setgainac:(CGPoint)point;

@end
