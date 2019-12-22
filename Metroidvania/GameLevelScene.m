//
//  GameLevelScene.m
//  Base: SuperKoalio
//
//  Base Created by Jake Gundersen on 12/27/13.
//
//  Made by Nick VanCise
//  Metroidvania
//  jun 11 2018
//  this is a game for fun and experience, nothing serious
//  ill give sprite credit in the gameplay when polished


#import "GameLevelScene.h"
#import "GameLevelScene2.h"
#import "SKTUtils.h"
#import "PlayerProjectile.h"
#import "sciserenemy.h"
#import "waver.h"

@implementation GameLevelScene{
  UIButton *_continuebutton,*_replaybutton;
  //SKSpriteNode *won,*died;
  //SKSpriteNode*_pauselabel,*_unpauselabel,*_controlslabel,*_startbutton,*_mask;
  UITextView *_controlstext;
}

-(instancetype)initWithSize:(CGSize)size andVol:(float)vol{
  self=[super initWithSize:size andVol:vol];//initWithSize:size];
  if (self!=nil) {
    /* Setup scene here */
    //self.view.ignoresSiblingOrder=YES; //for performance optimization every time this class is instanciated
    //self.view.shouldCullNonVisibleNodes=NO; //??? seems to help framerate for now
    //[self.map removeFromParent];//was previously here to get rid of this map in subclasses
    //self.map=nil;
    self.volume=vol;
    self.backgroundColor=[SKColor colorWithRed:0.7259 green:0 blue:0.8863 alpha:1.0];
    self.map = [JSTileMap mapNamed:@"level1.tmx"];
    [self addChild:self.map];
    [saveData editlvlwithval:@1 forsaveslot:[saveData getcurrslot]];
    [saveData arch];
    
    self.hasHadBossInterac=NO;
    
    self.walls=[self.map layerNamed:@"walls"];
    self.hazards=[self.map layerNamed:@"hazards"];
    self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
    
    __weak GameLevelScene *weakself=self;
    self.userInteractionEnabled=NO; //for use with player enter scene
    //player initializiation stuff
    self.player.position = CGPointMake(100, 150);
    self.player.zPosition = 15;
    
    SKConstraint*plyrconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:0 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-33] Y:[SKRange rangeWithUpperLimit:(self.map.tileSize.height*self.map.mapSize.height)-22]];
    plyrconst.referenceNode=self.parent;
    self.player.constraints=@[plyrconst];
    
    [self.map addChild:self.player];
    [self.player runAction:self.player.enterfromportalAnimation completion:^{[weakself.player runAction:[SKAction setTexture:weakself.player.forewards resize:YES]];weakself.userInteractionEnabled=YES;}];
    
    self.player.forwardtrack=YES;
    self.player.backwardtrack=NO;
    
    //camera initialization
    SKRange *xrange=[SKRange rangeWithLowerLimit:self.size.width/2 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-self.size.width/2];
    SKRange *yrange=[SKRange rangeWithLowerLimit:self.size.height/2 upperLimit:(self.map.mapSize.height*self.map.tileSize.height)-self.size.height/2];
    SKConstraint*edgeconstraint=[SKConstraint positionX:xrange Y:yrange];
    self.camera.constraints=@[[SKConstraint distance:[SKRange rangeWithUpperLimit:4] toNode:self.player],edgeconstraint];
    
    //gameover buttons/labels
    self.replayimage=[UIImage imageNamed:@"replay.png"];
    
    //portal stuff
    self.travelportal.position=CGPointMake((self.map.mapSize.width * self.map.tileSize.width)-120, 95.0);
    
    //tutorial labels here
    SKLabelNode*shootlabel1=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    shootlabel1.text=@"Use the lower right half of";
    shootlabel1.fontSize=12;
    shootlabel1.zPosition=14;
    shootlabel1.alpha=0.9;
    shootlabel1.position=CGPointMake((17.5*self.map.tileSize.width),9*self.map.tileSize.height);
    [self.map addChild:shootlabel1];
    
    SKLabelNode*shootlabel2=shootlabel1.copy;
    shootlabel2.text=@"the screen to shoot";
    shootlabel2.position=CGPointMake((17.5*self.map.tileSize.width),8*self.map.tileSize.height);
    [self.map addChild:shootlabel2];
    
    SKLabelNode*meleelabel1=shootlabel1.copy;
    meleelabel1.text=@"Use the upper right half of";
    meleelabel1.position=CGPointMake((154.5*self.map.tileSize.width),10*self.map.tileSize.height);
    [self.map addChild:meleelabel1];
    
    SKLabelNode*meleelabel2=shootlabel1.copy;
    meleelabel2.text=@"the screen to melee";
    meleelabel2.position=CGPointMake((154.5*self.map.tileSize.width),9*self.map.tileSize.height);
    [self.map addChild:meleelabel2];
    
    //enemies here
    sciserenemy *enemy=[[sciserenemy alloc] initWithPos:CGPointMake(12.5*self.map.tileSize.width,2.625*self.map.tileSize.height)];
    [self.enemies addObject:enemy];
    [self.map addChild:enemy];
    
    sciserenemy *enemy2=[[sciserenemy alloc] initWithPos:CGPointMake(self.map.mapSize.width * self.map.tileSize.width-400, self.player.position.y-125)];
    [self.enemies addObject:enemy2];
    [self.map addChild:enemy2];
    
    waver*enemy3=[[waver alloc] initWithPosition:CGPointMake(160*self.map.tileSize.width, 8*self.map.tileSize.height) xRange:350 yRange:20];
    [self.enemies addObject:enemy3];
    [self.map addChild:enemy3];
    
    //door stuff here
    //self.repeating=NO;
    //self.stayPaused=NO;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStayPaused) name:@"stayPausedNotification" object:nil];//notification listening for stayPausedNotification
    
  }
  return self;
}

-(void)didMoveToView:(SKView *)view{
  //setup sound
  self.audiomanager=[gameaudio alloc];
  [self.audiomanager runBkgrndMusicForlvl:1 andVol:self.volume];
  __weak GameLevelScene*weakself=self;
  dispatch_async(dispatch_get_main_queue(), ^{ //deal with certain ui (that could be used immediately) on main thread only
    [weakself setupVolumeSliderAndReplayAndContinue:weakself];
  });
}


-(void)handleBulletEnemyCollisions{ //switch this to use id in fast enumeration so as to keep 1 enemy arr with multiple enemy types
  
  __weak GameLevelScene*weakself=self;
  
  for(id enemycon in [self.enemies reverseObjectEnumerator]){//enemy to player+melee
    enemyBase*enemyconcop=(enemyBase*)enemycon;
    [enemyconcop enemytoplayerandmelee:weakself];
  }
  
  
  for(PlayerProjectile *currbullet in [self.bullets reverseObjectEnumerator]){
    if(currbullet.cleanup || [self tileGIDAtTileCoord:[self.walls coordForPoint:currbullet.position] forLayer:self.walls]){//here to avoid another run through of arr
      //NSLog(@"removing from array");
      [currbullet removeAllActions];
      [currbullet removeFromParent];
      [self.bullets removeObject:currbullet];
      continue;//avoid comparing with removed bullet
    }
    
    for(id enemyl in self.enemies){
      //NSLog(@"bullet frame:%@",NSStringFromCGRect(currbullet.frame));
        enemyBase*enemylcop=(enemyBase*)enemyl;
        if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,enemylcop.dx,enemylcop.dy), currbullet.frame) && !enemylcop.dead){
          //NSLog(@"hit an enemy, current  bullet hit=%d",currbullet.hit);
          [enemylcop hitByBulletWithArrayToRemoveFrom:self.enemies withHit:currbullet.hit];
          [currbullet removeAllActions];
          [currbullet removeFromParent];
          [self.bullets removeObject:currbullet];
          break; //if bullet hits enemy stop checking for same bullet
        
      }
    }
  }//for currbullet
  
 
}

-(void)replaybuttonpush:(id)sender{
  [[self.view viewWithTag:666] removeFromSuperview];
  [[self.view viewWithTag:4545] removeFromSuperview];
  [self.view presentScene:[[GameLevelScene alloc] initWithSize:self.size andVol:self.audiomanager.currentVolume/100]];
  [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}
-(void)continuebuttonpush:(id)sender{
  [[self.view viewWithTag:888] removeFromSuperview];
  [[self.view viewWithTag:4545] removeFromSuperview];
  __weak GameLevelScene*weakself=self;
  [SKTextureAtlas preloadTextureAtlasesNamed:@[@"honeypot",@"Arachnus"] withCompletionHandler:^(NSError*error,NSArray*foundatlases){
      GameLevelScene2*preload=[[GameLevelScene2 alloc]initWithSize:weakself.size andVol:weakself.audiomanager.currentVolume/100];
      preload.scaleMode = SKSceneScaleModeAspectFill;
        NSLog(@"preloaded lvl2");
        [weakself.view presentScene:preload];
    }];
  [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}

/*-(void)dealloc {
  NSLog(@"LVL1 SCENE DEALLOCATED");
}*/

@end
