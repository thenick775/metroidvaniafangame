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
  NSString *fintext;
  SKLabelNode *endgamelabel;
  UIButton *replaybutton;
  UIButton *continuebutton;
  SKSpriteNode*_pauselabel,*_unpauselabel;
  UISlider*_volumeslider;
}

-(instancetype)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup scene here */
    //self.view.ignoresSiblingOrder=YES; //for performance optimization every time this class is instanciated
    //self.view.shouldCullNonVisibleNodes=NO; //??? seems to help framerate for now
    
    self.backgroundColor =[SKColor colorWithRed:0.7259 green:0 blue:0.8863 alpha:1.0];
    self.map = [JSTileMap mapNamed:@"level1.tmx"];
    [self addChild:self.map];
    
    self.walls=[self.map layerNamed:@"walls"];
    self.hazards=[self.map layerNamed:@"hazards"];
    self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
    
    __weak GameLevelScene *weakself=self;
    self.userInteractionEnabled=NO; //for use with player enter scene
    //player initializiation stuff
    self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];
    self.player.position = CGPointMake(100, 150);
    self.player.zPosition = 15;
    
    SKConstraint*plyrconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:0 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-33]];
    plyrconst.referenceNode=self.parent;
    self.player.constraints=@[plyrconst];
    
    [self.map addChild:self.player];
    [self.player runAction:self.player.enterfromportalAnimation completion:^{[weakself.player runAction:[SKAction setTexture:weakself.player.forewards resize:YES]];weakself.userInteractionEnabled=YES;}];
    
    self.player.forwardtrack=YES;
    self.player.backwardtrack=NO;
    
    //camera initialization
    SKCameraNode*mycam=[SKCameraNode new];
    self.camera=mycam;
    [self addChild:mycam];
    SKRange *xrange=[SKRange rangeWithLowerLimit:self.size.width/2 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-self.size.width/2];
    SKRange *yrange=[SKRange rangeWithLowerLimit:self.size.height/2 upperLimit:(self.map.mapSize.height*self.map.tileSize.height)-self.size.height/2];
    SKConstraint*edgeconstraint=[SKConstraint positionX:xrange Y:yrange];
    self.camera.constraints=@[[SKConstraint distance:[SKRange rangeWithUpperLimit:4] toNode:self.player],edgeconstraint];/*=@[[SKConstraint distance:[SKRange rangeWithConstantValue:0.0] toNode:self.player],edgeconstraint];*/
    
    //health label initialization
    self.healthlabel=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
    self.healthlabel.fontSize=15;
    self.healthlabel.zPosition=15;
    self.healthlabel.position=CGPointMake((-4*(self.size.width/10))+3, self.size.height/2-20);
    [self.camera addChild:self.healthlabel];
    
    //health bar initialization
    self.healthbar=[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(200, 20)];
    self.healthbar.zPosition=14;
    self.healthbar.anchorPoint=CGPointMake(0.0, 0.0);
    self.healthbar.position=CGPointMake((-9*(self.size.width/20))-9.5/*self.size.width/20-10*/, self.size.height/2-24);
    [self.camera addChild:self.healthbar];
    _healthbarsize=(double)self.healthbar.size.width;
    
    self.healthbarborder=[SKSpriteNode spriteNodeWithImageNamed:@"healthbarborder.png"];
    self.healthbarborder.anchorPoint=CGPointMake(0.0, 0.0);
    self.healthbarborder.zPosition=15;
    self.healthbarborder.position=CGPointMake((-9*(self.size.width/20))-9.5/*self.size.width/20-10*/, self.size.height/2-24);
    [self.camera addChild:self.healthbarborder];
    
    //gameover buttons/labels
    endgamelabel=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    endgamelabel.fontSize=40;
    endgamelabel.position=CGPointMake(0,35);

    replaybutton=[UIButton buttonWithType:UIButtonTypeCustom];
    replaybutton.tag=666;
    UIImage *replayimage=[UIImage imageNamed:@"replay"];
    [replaybutton setImage:replayimage forState:UIControlStateNormal];
    [replaybutton addTarget:self action:@selector(replaybuttonpush:) forControlEvents:UIControlEventTouchUpInside];
    replaybutton.frame=CGRectMake(self.size.width/2.0-replayimage.size.width/4.0+5, self.size.height/2.0-replayimage.size.height/4.0+5, replayimage.size.width, replayimage.size.height);
    
    continuebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    continuebutton.tag=888;
    UIImage *continueimage=[UIImage imageNamed:@"continuebutton.png"];
    [continuebutton setImage:continueimage forState:UIControlStateNormal];
    [continuebutton addTarget:self action:@selector(continuebuttonpush:) forControlEvents:UIControlEventTouchUpInside];
    continuebutton.frame=CGRectMake(self.size.width/2.0-continueimage.size.width/4.0-15, self.size.height/2.0-continueimage.size.height/4.0+7, continueimage.size.width, continueimage.size.height);
    
    //pause-unpause buttons/labels & pause screen items
    _pauselabel=[SKSpriteNode spriteNodeWithImageNamed:@"pauselabel.png"];
    _pauselabel.position=CGPointMake(0,35);
    _unpauselabel=[SKSpriteNode spriteNodeWithImageNamed:@"unpauselabel.png"];
    _unpauselabel.position=CGPointMake(0,10);
    self.volumeslider=[[UISlider alloc] initWithFrame:CGRectMake(weakself.size.width/2+200,weakself.size.height/2+15, weakself.size.height-40, 15.0)];
    
    //portal stuff
    _travelportal=[[TravelPortal alloc] initWithImage:@"travelmirror.png"];
    _travelportal.position=CGPointMake((self.map.mapSize.width * self.map.tileSize.width)-120, 95.0);
    
    //button initialization
    _buttonup=[SKSpriteNode spriteNodeWithImageNamed:@"buttonupv4real.png"];
    _buttonup.position=CGPointMake((-2*(self.size.width/6)), -36);//CGPointMake(self.size.width/6, self.size.height/2-36);
    [self.camera addChild:_buttonup];
    
    _buttonleft=[SKSpriteNode spriteNodeWithImageNamed:@"buttonleftv2real.png"];
    _buttonleft.position=CGPointMake((-2*(self.size.width/6))-28, -75);//CGPointMake(self.size.width/6-28, self.size.height/2-75);
    [self.camera addChild:_buttonleft];
   
    _buttonright=[SKSpriteNode spriteNodeWithImageNamed:@"buttonrightv2real.png"];
    _buttonright.position=CGPointMake((-2*(self.size.width/6))+28, -75);//CGPointMake(self.size.width/6+28, self.size.height/2-75);
    [self.camera addChild:_buttonright];
    
    _startbutton=[SKSpriteNode spriteNodeWithImageNamed:@"startbutton.png"];
    _startbutton.position=CGPointMake(self.size.width/4+90,self.size.height/2-12);
    [self.camera addChild:_startbutton];
    
    //scene mutable arrays here
    self.bullets=[[NSMutableArray alloc]init];
    self.enemies=[[NSMutableArray alloc]init];
    
    //enemies here
    sciserenemy *enemy=[[sciserenemy alloc] initWithPos:CGPointMake(self.player.position.x+100, self.player.position.y-108)];
    [self.enemies addObject:enemy];
    [self.map addChild:enemy];
    
    sciserenemy *enemy2=[[sciserenemy alloc] initWithPos:CGPointMake(self.map.mapSize.width * self.map.tileSize.width-400, self.player.position.y-125)];
    [self.enemies addObject:enemy2];
    [self.map addChild:enemy2];
    
    waver*enemy3=[[waver alloc] initWithPosition:CGPointMake(160*self.map.tileSize.width, 8*self.map.tileSize.height)];
    [self.enemies addObject:enemy3];
    [self.map addChild:enemy3];
    
    //door stuff here
    _repeating=NO;
    
  }
  return self;
}

-(void)didMoveToView:(SKView *)view{
  //setup sound
  self.audiomanager=[gameaudio alloc];
  [self.audiomanager runBkgrndMusicForlvl:1];
  
  __weak GameLevelScene*weakself=self;
  dispatch_async(dispatch_get_main_queue(), ^{ //deal with certain ui (that could be used immediately) on main thread only
  weakself.volumeslider.minimumValue=0;
  weakself.volumeslider.maximumValue=100.0;
  weakself.volumeslider.continuous=YES;
  weakself.volumeslider.value=70;
  weakself.volumeslider.hidden=YES;
  weakself.volumeslider.minimumTrackTintColor=[UIColor redColor];
  weakself.volumeslider.maximumTrackTintColor=[UIColor darkGrayColor];
  [weakself.volumeslider setThumbImage:[UIImage imageNamed:@"supermetroid_sliderbar.png"] forState:UIControlStateNormal];
  [weakself.volumeslider setTransform:CGAffineTransformRotate(weakself.volumeslider.transform, M_PI_2)];
  [weakself.volumeslider setBackgroundColor:[UIColor clearColor]];
  [weakself.volumeslider addTarget:weakself action:@selector(slideraction:) forControlEvents:UIControlEventValueChanged];
  [weakself.view addSubview:weakself.volumeslider];
  });
}

- (void)update:(NSTimeInterval)currentTime{
  
  if(self.gameOver)
    return;
  
  NSTimeInterval delta=currentTime-self.storetime;
  
  if(delta>0.2)
    delta=0.2;
  
  self.storetime=currentTime;
  
  [self.player update:delta];
  
  //do collision detection calls here
  
  [self checkAndResolveCollisionsForPlayer:self.player];
  
  [self handleBulletEnemyCollisions];
}



-(NSInteger)tileGIDAtTileCoord:(CGPoint)tilecoordinate forLayer:(TMXLayer *)fnclayer {
  @autoreleasepool{
  TMXLayerInfo *currinfo=fnclayer.layerInfo;
  return [currinfo tileGidAtCoord:tilecoordinate];
  }
}



-(CGRect)tileRectFromTileCoords:(CGPoint)fnccoordinate{
  
  float levelheightinpixels=self.map.mapSize.height * self.map.tileSize.height;
  
  CGPoint origin=CGPointMake(fnccoordinate.x * self.map.tileSize.width, levelheightinpixels - ((fnccoordinate.y+1)* self.map.tileSize.height));
  
  return CGRectMake(origin.x, origin.y, self.map.tileSize.width,self.map.tileSize.height);
}



-(void)checkAndResolveCollisionsForPlayer:(Player *)fncplayer{
  
  NSInteger tileindecies[8]={7,1,3,5,0,2,6,8};
  fncplayer.onGround=NO;
  
  
  
  for(NSInteger i=0;i<8;i++){
    NSInteger tileindex=tileindecies[i];
    
    CGRect playerrect=[fncplayer collisionBoundingBox];
    CGPoint playercoordinate=[self.walls coordForPoint:fncplayer.desiredPosition];
    
  
    if(playercoordinate.y >= self.map.mapSize.height-1 ){ //sets gameover if you go below the bottom of the maps y max-1
      [self gameOver:0];
      return;
    }
    if(fncplayer.position.x>=(self.map.mapSize.width*self.map.tileSize.width)-220 && !_repeating){
      [self.map addChild:_travelportal];
      _repeating=YES;
    }
    if(_travelportal!=NULL && CGRectIntersectsRect(CGRectInset(playerrect,4,6),[_travelportal collisionBoundingBox])){      
      [fncplayer runAction:[SKAction moveTo:_travelportal.position duration:1.5] completion:^{[self gameOver:1];}];
      return;
    }
    
    
    
    NSInteger tilecolumn=tileindex%3; //this is how array of coordinates around player is navigated
    NSInteger tilerows=tileindex/3;
    
    CGPoint tilecoordinate=CGPointMake(playercoordinate.x+(tilecolumn-1), playercoordinate.y+(tilerows-1));
    
    NSInteger thetileGID=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.walls];
    NSInteger hazardtilegid=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.hazards];
    NSInteger mysteryboxgid=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.mysteryboxes];
    
  
    if(thetileGID !=0 || mysteryboxgid!=0){
      CGRect tilerect=[self tileRectFromTileCoords:tilecoordinate];
      //NSLog(@"TILE GID: %ld Tile coordinate: %@ Tile rect: %@ Player Rect: %@",(long)thetileGID,NSStringFromCGPoint(tilecoordinate),NSStringFromCGRect(tilerect),NSStringFromCGRect(playerrect));
      //collision detection here
      
      if(CGRectIntersectsRect(playerrect, tilerect)){
        CGRect pl_tl_intersection=CGRectIntersection(playerrect, tilerect); //distance of intersection where player and tile overlap
        
        if(tileindex==7){
          //tile below the sprite
          fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x, fncplayer.desiredPosition.y+pl_tl_intersection.size.height);
          
          fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0);
          fncplayer.onGround=YES;
        }
        else if(tileindex==1){
          //tile above the sprite
          if(mysteryboxgid!=0){
            //NSLog(@"hit a mysterybox!!");
            [self.mysteryboxes removeTileAtCoord:tilecoordinate];
            [self hitHealthBox]; //adjusts player healthlabel/healthbar
          }
          else{
          fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x, fncplayer.desiredPosition.y-pl_tl_intersection.size.height);
          fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0);
          }
        }
        else if(tileindex==3){
          //tile back left of sprite
          fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x+pl_tl_intersection.size.width, fncplayer.desiredPosition.y);
        }
        else if(tileindex==5){
          //tile front right of sprite
          fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x-pl_tl_intersection.size.width, fncplayer.desiredPosition.y);
        }
        else{
          if(pl_tl_intersection.size.width>pl_tl_intersection.size.height){
            //this is for resolving collision up or down due to ^
            float intersectionheight;
            if(thetileGID!=0){
            fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0);
            }
            
            if(tileindex>4){
              intersectionheight=pl_tl_intersection.size.height;
              fncplayer.onGround=YES;
            }
            else
              intersectionheight=-pl_tl_intersection.size.height;
            
            fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x, fncplayer.desiredPosition.y+intersectionheight);
         
          }
          else{
            //this is for resolving collisions left or right due to ^
            float intersectionheight;
            
            if(tileindex==0 || tileindex==6)
              intersectionheight=pl_tl_intersection.size.width;
            else
              intersectionheight=-pl_tl_intersection.size.width;
            
            fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x+intersectionheight, fncplayer.desiredPosition.y);
          }
          
        }
      }
    }//if thetilegid bracket
    
    if(hazardtilegid!=0){//for hazard layer
      CGRect hazardtilerect=[self tileRectFromTileCoords:tilecoordinate];
      if(CGRectIntersectsRect(CGRectInset(playerrect, 1, 0), hazardtilerect)){
        [self damageRecievedMsg];
        if(fncplayer.health<=0){
          [self gameOver:0];
        }
      }//if rects intersect
    }//if hazard tile
    
    
    
  }//for loop bracket
  fncplayer.position=fncplayer.desiredPosition;
}//fnc bracket



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
  if(self.gameOver || self.player.meleeinaction)
    return;
  
  
  for(UITouch *touch in touches){
    //NSLog(@"touchbegan");
    CGPoint touchlocation=[touch locationInNode:self.camera];  //location of the touch
    
    //start delegating parts of the screen to specific movements
    
    if(self.paused && CGRectContainsPoint(_unpauselabel.frame, touchlocation)) //check for unpause
      [self unpausegame];
    else if(self.paused)
      return;
    else if(CGRectContainsPoint(_startbutton.frame, touchlocation)){
      [self pausegame];
    }
    else if(CGRectContainsPoint(_buttonright.frame, touchlocation)){
      //NSLog(@"touching right control");
      self.player.goForeward=YES;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      [_buttonright runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      [self.player runAction:self.player.runAnimation withKey:@"runf"];
    }
    else if(CGRectContainsPoint(_buttonleft.frame, touchlocation)){
      //NSLog(@"touching left control");
      self.player.goBackward=YES;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      [_buttonleft runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      [self.player runAction:self.player.runBackwardsAnimation withKey:@"runb"];
    }
    else if(CGRectContainsPoint(_buttonup.frame,touchlocation)){
      //NSLog(@"touching up control");
      self.player.shouldJump=YES;
      [_buttonup runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      if(self.player.forwardtrack)
        [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      else
        [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
    }
    
  
  }//uitouch iteration end
}//function end



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{ //need to modify to fit ^v asap
  
  if(self.gameOver || self.paused || self.player.meleeinaction)
    return;
  
  
  //NSLog(@"Touch is moving");
  for(UITouch *touch in touches){
  
    CGPoint currtouchlocation=[touch locationInNode:self.camera];
    CGPoint previoustouchlocation=[touch previousLocationInNode:self.camera];
    
    if(currtouchlocation.x>self.size.width/2 && (previoustouchlocation.x<=self.size.width/2)){
      //NSLog(@"moving to firing weapon");
      self.player.shouldJump=NO;
      [_buttonup runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      self.player.goForeward=NO;
      [_buttonright runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      self.player.goBackward=NO;
      [_buttonleft runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
    }
    else if(CGRectContainsPoint(_buttonup.frame, currtouchlocation) && CGRectContainsPoint(_buttonright.frame, previoustouchlocation)){
    //NSLog(@"moving from move right to jumping");
      self.player.shouldJump=YES;
      [_buttonup runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      self.player.goForeward=NO;
      [_buttonright runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      
      [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      [self.player removeActionForKey:@"runf"];
    }
    else if(CGRectContainsPoint(_buttonup.frame, currtouchlocation) && CGRectContainsPoint(_buttonleft.frame, previoustouchlocation)){
      //NSLog(@"moving from move backward to jumping");
      self.player.shouldJump=YES;
      [_buttonup runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      self.player.goBackward=NO;
      [_buttonleft runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      
      [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
      [self.player removeActionForKey:@"runb"];
    }
    else if(CGRectContainsPoint(_buttonright.frame, currtouchlocation) && CGRectContainsPoint(_buttonleft.frame, previoustouchlocation)){
      //NSLog(@"moving from move backward to moveforeward");
      self.player.goForeward=YES;
      [_buttonright runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      self.player.goBackward=NO;
      [_buttonleft runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      [self.player runAction:self.player.runAnimation withKey:@"runf"];
      [self.player removeActionForKey:@"runb"];
    }
    else if(CGRectContainsPoint(_buttonright.frame, currtouchlocation) && CGRectContainsPoint(_buttonup.frame, previoustouchlocation)){
      //NSLog(@"move up to move foreward");
      self.player.goForeward=YES;
      [_buttonright runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      self.player.shouldJump=NO;
      [_buttonup runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
    }
    else if(CGRectContainsPoint(_buttonleft.frame, currtouchlocation) && CGRectContainsPoint(_buttonright.frame, previoustouchlocation)){
      //NSLog(@"move forewards to movebackwards");
      self.player.goBackward=YES;
      [_buttonleft runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      self.player.goForeward=NO;
      [_buttonright runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      [self.player runAction:self.player.runBackwardsAnimation withKey:@"runb"];
      [self.player removeActionForKey:@"runf"];
    }
    else if(CGRectContainsPoint(_buttonleft.frame, currtouchlocation) && CGRectContainsPoint(_buttonup.frame, previoustouchlocation)){
      //NSLog(@"move up to movebackwards");
      self.player.goBackward=YES;
      [_buttonleft runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05]];
      self.player.shouldJump=NO;
      [_buttonup runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
    }
    else if(!CGRectContainsPoint(_buttonup.frame, currtouchlocation) && !CGRectContainsPoint(_buttonright.frame, currtouchlocation) && !CGRectContainsPoint(_buttonleft.frame, currtouchlocation) && currtouchlocation.x<self.camera.frame.size.width/2){
      //NSLog(@"not in dpad");
      self.player.shouldJump=NO;
      self.player.goForeward=NO;
      self.player.goBackward=NO;
      [_buttonup runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      [_buttonright runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
      [_buttonleft runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];

      
      [self.player removeActionForKey:@"runf"];
      [self.player removeActionForKey:@"runb"];
      [self.player removeActionForKey:@"jmpf"];
      [self.player removeActionForKey:@"jmpb"];
      //[self.player removeActionForKey:@"jmpblk"];
      
      if(self.player.forwardtrack){
        [self.player runAction:[SKAction setTexture:self.player.forewards resize:YES]];
      }
      else{
        [self.player runAction:[SKAction setTexture:self.player.backwards resize:YES]];
      }
    }
    
    
  }//for uitouch bracket
}//fnc bracket


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

  if(self.gameOver || self.paused)
    return;
  if(self.player.meleeinaction){
    [self.player removeActionForKey:@"jmpblk"]; //these actions are the only ones possibly needing to be removed
    self.player.shouldJump=NO;
    [self.player removeActionForKey:@"runf"];
    self.player.goForeward=NO;
    [self.player removeActionForKey:@"runb"];
    self.player.goBackward=NO;
    [self.player removeActionForKey:@"jmpf"];
    [self.player removeActionForKey:@"jmpb"];
    return;
  }
  
  for(UITouch *touch in touches){
  CGPoint fnctouchlocation=[touch locationInNode:self.camera];
  
    [self.player removeActionForKey:@"jmpblk"]; //these actions are the only ones possibly needing to be removed
    [self.player removeActionForKey:@"runf"];   //also these movements must be NO after every touch finishes
    self.player.goForeward=NO;                   //initial solution for fixing sticky buttons
    [self.player removeActionForKey:@"runb"];
    self.player.goBackward=NO;
    [self.player removeActionForKey:@"jmpf"];
    [self.player removeActionForKey:@"jmpb"];
    self.player.shouldJump=NO;
    
    [_buttonup runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
    [_buttonright runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
    [_buttonleft runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05]];
    
    if(CGRectContainsPoint(_buttonup.frame, fnctouchlocation)){
      //NSLog(@"done touching up");
      //self.player.shouldJump=NO;
      if(self.player.backwardtrack)
        [self.player runAction:[SKAction setTexture:self.player.backwards resize:YES]];
      else
        [self.player runAction:[SKAction setTexture:self.player.forewards resize:YES]];
    }
    else if(CGRectContainsPoint(_buttonright.frame, fnctouchlocation)){
      //NSLog(@"done touching right");
      //self.player.goForeward=NO;
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      [self.player runAction:[SKAction setTexture:self.player.forewards resize:YES]];
    }
    else if(CGRectContainsPoint(_buttonleft.frame, fnctouchlocation)){
      //NSLog(@"done touching left");
      //self.player.goBackward=NO;
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      [self.player runAction:[SKAction setTexture:self.player.backwards resize:YES]];
    }
    else if(CGRectContainsPoint(_startbutton.frame, fnctouchlocation)){
      //NSLog(@"do nothing hit the pause");//put here so the melee is not hit
    }
    else if(fnctouchlocation.x>self.camera.frame.size.width/2 && fnctouchlocation.y<self.camera.frame.size.height/2){
      //call build projectile/set it going right ->
      if(self.player.forwardtrack)
        [self firePlayerProjectilewithdirection:TRUE];
      else
        [self firePlayerProjectilewithdirection:FALSE];
     // NSLog(@"start firing weapon");
    }
    else if(fnctouchlocation.x>self.camera.frame.size.width/2 && fnctouchlocation.y>self.camera.frame.size.height/2){
      [self.player runAction:self.player.meleeactionright withKey:@"melee"];
      //NSLog(@"start melee");
    }
    /*else{// to handle any case where the touches are not in sync (gets rid of sticky dpad)
    NSLog(@"blank touches ended");
    self.player.goForeward=NO;
    self.player.goBackward=NO;
    self.player.shouldJump=NO;
  }*/
    
    
  }
}
-(void)firePlayerProjectilewithdirection:(BOOL)direction{
  PlayerProjectile *newProjectile=[[PlayerProjectile alloc] initWithPos:self.player.position andDirection:direction];
  newProjectile.zPosition=16;
  [self.map addChild:newProjectile];
  [self.bullets addObject:newProjectile];
  //NSLog(@"adding projectile,count:%d",(int)self.bullets.count);
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  NSLog(@"recieved CANCELED touch");
  [self.player removeActionForKey:@"jmpblk"]; //these actions are the only ones possibly needing to be removed
  [self.player removeActionForKey:@"runf"];
  self.player.goForeward=NO;
  [self.player removeActionForKey:@"runb"];
  self.player.goBackward=NO;
  [self.player removeActionForKey:@"jmpf"];
  [self.player removeActionForKey:@"jmpb"];
  self.player.shouldJump=NO;
}

-(void)handleBulletEnemyCollisions{ //switch this to ise id in fast enumeration so as to keep 1 enemy arr with multiple enemy types
  
  for(id enemycon in [self.enemies reverseObjectEnumerator]){
    
    if([enemycon isKindOfClass:[sciserenemy class]]){
      sciserenemy*enemyconcop=(sciserenemy*)enemycon;
      if(fabs(self.player.position.x-enemyconcop.position.x)<70){  //minimize comparisons
        //NSLog(@"in here");
        if(CGRectContainsPoint(self.player.collisionBoundingBox, CGPointAdd(enemyconcop.enemybullet1.position, enemyconcop.position))){
          //NSLog(@"enemy hit player bullet#1");
          [enemyconcop.enemybullet1 setHidden:YES];
          if(!self.player.plyrrecievingdmg){
            self.player.plyrrecievingdmg=YES;
            [self enemyhitplayerdmgmsg:25];
          }
        }
        else if(CGRectContainsPoint(self.player.collisionBoundingBox,CGPointAdd(enemyconcop.enemybullet2.position, enemyconcop.position))){
          //NSLog(@"enemy hit player buller#2");
          [enemyconcop.enemybullet2 setHidden:YES];
          if(!self.player.plyrrecievingdmg){
            self.player.plyrrecievingdmg=YES;
            [self enemyhitplayerdmgmsg:25];
          }
        }
        if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect([self.player meleeBoundingBoxNormalized],enemyconcop.frame)){
          //NSLog(@"meleehit");
          enemyconcop.health=enemyconcop.health-10;
          [self.player runAction:self.player.meleedelayac];
          if(enemyconcop.health<=0){
            [enemycon removeAllActions];
            [enemycon removeAllChildren];
            [enemycon removeFromParent];
            [self.enemies removeObject:enemycon];
          }
        }
      }
    }
    else if([enemycon isKindOfClass:[waver class]]){
      waver*enemyconcop=(waver*)enemycon;
      [enemyconcop updateWithDeltaTime:0.16 andPlayerpos:self.player.position];
      if(fabs(self.player.position.x-enemyconcop.position.x)<40 && fabs(self.player.position.y-enemyconcop.position.y)<60 && !enemyconcop.attacking){
        [enemyconcop attack];
      }
      if(CGRectIntersectsRect(self.player.frame,CGRectInset(enemyconcop.frame,2,0)) && !self.player.plyrrecievingdmg){
        self.player.plyrrecievingdmg=YES;
        [self enemyhitplayerdmgmsg:15];
      }
      if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect([self.player meleeBoundingBoxNormalized],enemyconcop.frame)){
        //NSLog(@"meleehit");
        enemyconcop.health=enemyconcop.health-10;
        [self.player runAction:self.player.meleedelayac];
        if(enemyconcop.health<=0){
          [enemyconcop removeAllActions];
          [enemyconcop removeAllChildren];
          [enemyconcop removeFromParent];
          [self.enemies removeObject:enemyconcop];
        }
      }
    }
  }
  
  
  for(PlayerProjectile *currbullet in [self.bullets reverseObjectEnumerator]){
    
    if(currbullet.cleanup){//here to avoid another run through of arr
      //NSLog(@"removing from array");
      [self.bullets removeObject:currbullet];
      [currbullet removeFromParent];
      continue;//avoid comparing with removed bullet
    }
    
    for(id enemyl in self.enemies){
      //NSLog(@"bullet frame:%@",NSStringFromCGRect(currbullet.frame));
      if([enemyl isKindOfClass:[sciserenemy class]]){
        sciserenemy*enemylcop=(sciserenemy*)enemyl;
        if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,5,0), currbullet.frame)){
          //NSLog(@"hit an enemy");
          enemylcop.health--;
          if(enemylcop.health<=0){
            [enemyl removeAllActions];
            [enemyl removeAllChildren];
            [enemyl runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[enemyl removeFromParent];}]]]];
            [self.enemies removeObject:enemyl];
          }
          [currbullet removeAllActions];
          [currbullet removeFromParent];
          [self.bullets removeObject:currbullet];
          break; //if bullet hits enemy stop checking for same bullet
        }
      }
      else if([enemyl isKindOfClass:[waver class]]){
        waver*enemylcop=(waver*)enemyl;
        if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,5,0), currbullet.frame)){
          enemylcop.health--;
          if(enemylcop.health<=0){
            [enemyl removeAllActions];
            [enemyl removeAllChildren];
            [enemyl runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[enemyl removeFromParent];}]]]];
            [self.enemies removeObject:enemyl];
          }
          [currbullet removeAllActions];
          [currbullet removeFromParent];
          [self.bullets removeObject:currbullet];
          break; //if bullet hits enemy stop checking for same bullet
        }
      }
    }
  }//for currbullet
  
  
  
}

-(void)damageRecievedMsg{
  
  --self.player.health;
  self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
  self.healthbar.size=CGSizeMake((self.healthbar.size.width-(_healthbarsize/100)), self.healthbar.size.height);
  
}
-(void)enemyhitplayerdmgmsg:(int)hit{
  self.player.health=self.player.health-hit;
  if(self.player.health<=0 && !self.gameOver){
    self.player.health=0;
    [self gameOver:0];
  }
  self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
  self.healthbar.size=CGSizeMake((((float)self.player.health/100)*_healthbarsize), self.healthbar.size.height);
  
  [self.player runAction:[SKAction group:@[self.player.plyrdmgwaitlock,[SKAction repeatAction:self.player.damageaction count:15]]]];
}

-(void)pausegame{
  //NSLog(@"game paused");
  //[self.startbutton runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05] completion:^{NSLog(@"coloringstart");}];
  [self.camera addChild:_pauselabel];
  [self.camera addChild:_unpauselabel];
  self.volumeslider.hidden=NO;
  self.paused=YES;
  self.player.playervelocity=CGPointMake(0,18);
}
-(void)unpausegame{
  //[self.startbutton runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05] completion:^{NSLog(@"uncoloringstart");}];
  [_pauselabel removeFromParent];
  [_unpauselabel removeFromParent];
  self.volumeslider.hidden=YES;
  
  self.paused=NO;
}

-(void)slideraction:(id)sender{
  UISlider*tmpslider=(UISlider*)sender;
  
  self.audiomanager.bkgrndmusic.volume=tmpslider.value/100;
}

-(void) gameOver:(BOOL)didwin{
  
  self.gameOver=YES;
  [self.player removeAllActions];
  
  if(didwin){
    fintext=@"You Won!";
    endgamelabel.text=fintext;
    if(self.player.forwardtrack)
      self.player.texture=self.player.forewards;
    else
      self.player.texture=self.player.backwards;
    
    __weak SKLabelNode *weakendgamelabel=endgamelabel;
    __weak UIButton *weakcontinuebutton=continuebutton;
    [self.player runAction:self.player.travelthruportalAnimation completion:^{[self.camera addChild:weakendgamelabel];[self.view addSubview:weakcontinuebutton];}];
  }
  else{
    fintext=@"You Died :(";
  //label setup for end of game message
  endgamelabel.text=fintext;
  [self.camera addChild:endgamelabel];
  [self.view addSubview:replaybutton];
  }
}
-(void)replaybuttonpush:(id)sender{
  [[self.view viewWithTag:666] removeFromSuperview];
  [self.view presentScene:[[GameLevelScene alloc] initWithSize:self.size]];
  [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}
-(void)continuebuttonpush:(id)sender{
  [[self.view viewWithTag:888] removeFromSuperview];
  __weak GameLevelScene*weakself=self;
  [SKTextureAtlas preloadTextureAtlasesNamed:@[@"honeypot",@"Arachnus"] withCompletionHandler:^(NSError*error,NSArray*foundatlases){
      GameLevelScene2*preload=[[GameLevelScene2 alloc]initWithSize:weakself.size];
      preload.scaleMode = SKSceneScaleModeAspectFill;
        NSLog(@"preloaded lvl2");
        [weakself.view presentScene:preload];
    }];
  [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}


-(void)hitHealthBox{
  
  self.player.health+=10; //reward for hitting mystery box
  if(self.player.health>100){
    self.player.health=100;
  }
  
  self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
  self.healthbar.size=CGSizeMake((((float)self.player.health/100)*_healthbarsize), self.healthbar.size.height);
}

/*-(void)dealloc {
  NSLog(@"LVL1 SCENE DEALLOCATED");
}*/

@end
