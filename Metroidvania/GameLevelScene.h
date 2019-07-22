//
//  GameLevelScene.h
//  Metroidvania
//


#import <SpriteKit/SpriteKit.h>
#import "TravelPortal.h"
#import "Player.h"
#import "JSTileMap.h"
#import "gameaudio.h"
#import "saveData.h"

@interface MySlider : UISlider
@end

@interface GameLevelScene : SKScene

@property (nonatomic,strong) Player *player;
@property (nonatomic,strong) JSTileMap *map;
@property (nonatomic,strong) TMXLayer *walls,*hazards,*mysteryboxes;
@property (nonatomic,assign) NSTimeInterval storetime,delta;
@property (nonatomic,assign) BOOL gameOver,repeating,stayPaused;
@property (nonatomic,strong) SKLabelNode *healthlabel;
@property (nonatomic,strong) SKSpriteNode *healthbar,*healthbarborder;
@property (nonatomic,strong) NSMutableArray *enemies,*bullets;
@property (nonatomic,assign) double healthbarsize;
@property (nonatomic,strong) TravelPortal * travelportal;
@property (nonatomic,strong) gameaudio*audiomanager;
@property (nonatomic,strong) MySlider*volumeslider;
@property (nonatomic,assign) float volume;
@property (nonatomic,strong) UIImage*replayimage;
@property (nonatomic,assign) BOOL hasHadBossInterac;

-(void)slideraction:(id)sender;
-(void)damageRecievedMsg;
-(void)enemyhitplayerdmgmsg:(int)hit;
-(void) gameOver:(BOOL)didwin;
-(void)replaybuttonpush:(id)sender;
-(void)continuebuttonpush:(id)sender;
-(void)setupVolumeSliderAndReplayAndContinue:(GameLevelScene*)weakself;
-(CGRect)tileRectFromTileCoords:(CGPoint)fnccoordinate;
-(NSInteger)tileGIDAtTileCoord:(CGPoint)tilecoordinate forLayer:(TMXLayer *)fnclayer;
-(void)hitHealthBox;
-(instancetype)initWithSize:(CGSize)size andVol:(float)vol;
-(instancetype)initNearBossWithSize:(CGSize)size andVol:(float)volume;
-(void)setBossInterac;
@end
