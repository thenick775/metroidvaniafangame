//
//  MenuScene.h
//  Metroidvania
//
//  Created by nick vancise on 6/20/18.

#import <SpriteKit/SpriteKit.h>

@interface MenuScene : SKScene

-(instancetype)initWithSize:(CGSize)size;
@property (nonatomic,strong) SKSpriteNode *_playlabel;
@property (nonatomic,strong) SKSpriteNode *_playbutton;
@property (nonatomic,strong) SKSpriteNode *_cntrllabel;
@property (nonatomic,strong) SKSpriteNode *titlelabel;
@property (nonatomic,strong) SKAction*labelsin;

@end

