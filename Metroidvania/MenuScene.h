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

@interface saveCell : SKShapeNode

@property (nonatomic,strong) SKLabelNode*center;
@property (nonatomic,strong) SKLabelNode*left;
@property (nonatomic,strong) SKLabelNode*right;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) int cellno;

-(void)fadeLabels;
-(void)showLabels;
-(instancetype)initWithSize:(CGSize)size andcorRad:(CGFloat)corrad forslot:(int)slot;

@end
