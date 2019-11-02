//
//  levelBase.h
//  Metroidvania
//
//  Created by nick vancise on 10/16/19.
//

#import <SpriteKit/SpriteKit.h>
#import "TravelPortal.h"
#import "Player.h"
#import "PlayerProjectile.h"
#import "JSTileMap.h"
#import "gameaudio.h"
#import "saveData.h"
#import "joystick.h"

@interface MySlider : UISlider
@end

@interface levelBase : SKScene

@property (nonatomic,strong) Player *player;
@property (nonatomic,strong) JSTileMap *map;
@property (nonatomic,assign) NSTimeInterval storetime,delta;
@property (nonatomic,strong) TMXLayer *walls,*hazards,*mysteryboxes;
@property (nonatomic,strong) NSMutableArray *enemies,*bullets;
@property (nonatomic,assign) BOOL gameOver,repeating,stayPaused;
@property (nonatomic,strong) SKLabelNode *healthlabel;
@property (nonatomic,strong) SKSpriteNode *healthbar,*healthbarborder;
@property (nonatomic,assign) double healthbarsize;
@property (nonatomic,strong) TravelPortal *travelportal;
@property (nonatomic,strong) joystick *myjoystick;
@property (nonatomic,strong) gameaudio*audiomanager;
@property (nonatomic,strong) MySlider*volumeslider;
@property (nonatomic,assign) float volume;
@property (nonatomic,strong) UIImage*replayimage;
@property (nonatomic,assign) BOOL hasHadBossInterac;

-(void)checkAndResolveCollisionsForPlayer;
-(CGRect)tileRectFromTileCoords:(CGPoint)fnccoordinate;
-(NSInteger)tileGIDAtTileCoord:(CGPoint)tilecoordinate forLayer:(TMXLayer *)fnclayer;
-(void)handleBulletEnemyCollisions;
-(void)slideraction:(id)sender;
-(void)enemyhitplayerdmgmsg:(int)hit;
-(void)gameOver:(BOOL)didwin;
-(void)replaybuttonpush:(id)sender;
-(void)continuebuttonpush:(id)sender;
-(void)hitHealthBox;
-(instancetype)initWithSize:(CGSize)size andVol:(float)vol;
-(void)setupVolumeSliderAndReplayAndContinue:(levelBase*)weakself;
-(instancetype)initNearBossWithSize:(CGSize)size andVol:(float)volume;
-(void)setBossInterac;
-(void)pausegame;
-(void)unpausegame;
-(void)displaycontrolstext;
-(void)damageRecievedMsg;

@end
