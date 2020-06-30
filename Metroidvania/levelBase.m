//
//  levelBase.m
//  Metroidvania
//
//  Created by nick vancise on 10/16/19.
//

#import "levelBase.h"

@implementation MySlider //created to make a more responsive UISlider
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{//adjust here to adjust the size of the entire slider hit area
  CGRect mybound=CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width+5, self.bounds.size.height+45);
  return CGRectContainsPoint(mybound, point);
}
- (BOOL) beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
  CGRect bounds = self.bounds;
  float thumbPercent = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
  float thumbPos = [self currentThumbImage].size.height + (thumbPercent * (bounds.size.width+5 - (2 * [self currentThumbImage].size.height)));
  CGPoint touchPoint = [touch locationInView:self];
  return (touchPoint.x >= (thumbPos - 45) && touchPoint.x <= (thumbPos + 25));//adjust where the x pos of your touch falls relative to the slider thumb
}
/*-(void)dealloc{
  NSLog(@"in slider dealloc");
}*/
@end

@implementation levelBase{
 UIButton *_continuebutton,*_replaybutton;
 SKSpriteNode *won,*died;
 UITextView *_controlstext;
 SKSpriteNode*_pauselabel,*_unpauselabel,*_controlslabel,*_startbutton,*_mask;
}

-(instancetype)initWithSize:(CGSize)size andVol:(float)vol{
   self=[super initWithSize:size];
   if (self!=nil) {
    self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];
       
    //camera initialization
    SKCameraNode*mycam=[SKCameraNode new];
    self.camera=mycam;
    [self addChild:mycam];
       
    //health label initialization
    self.healthlabel=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
    self.healthlabel.fontSize=15;
    self.healthlabel.zPosition=19;
    self.healthlabel.position=CGPointMake((-4*(self.size.width/10))+5, self.size.height/2-20);
    [self.camera addChild:self.healthlabel];
       
    //health bar initialization
    self.healthbar=[SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200, 20)];
    self.healthbar.zPosition=18;
    self.healthbar.anchorPoint=CGPointMake(0.0, 0.0);
    self.healthbar.position=CGPointMake((-9*(self.size.width/20))-9.5/*self.size.width/20-10*/, self.size.height/2-24);
    [self.camera addChild:self.healthbar];
    _healthbarsize=(double)self.healthbar.size.width;
       
    self.healthbarborder=[SKSpriteNode spriteNodeWithImageNamed:@"healthbarborder.png"];
    self.healthbarborder.anchorPoint=CGPointMake(0.0, 0.0);
    self.healthbarborder.zPosition=19;
    self.healthbarborder.position=CGPointMake((-9*(self.size.width/20))-9.5/*self.size.width/20-10*/, self.size.height/2-24);
    [self.camera addChild:self.healthbarborder];
       
    //pause-unpause buttons/labels & pause screen items
    _pauselabel=[SKSpriteNode spriteNodeWithImageNamed:@"pauselabel.png"];
    _pauselabel.position=CGPointMake(0,35);
    _pauselabel.zPosition=21;
    _unpauselabel=[SKSpriteNode spriteNodeWithImageNamed:@"unpauselabel.png"];
    _unpauselabel.position=CGPointMake(0,0);
    _unpauselabel.zPosition=21;
    [_unpauselabel setScale:1.35];
    _controlslabel=[SKSpriteNode spriteNodeWithImageNamed:@"controlslabel.png"];
    _controlslabel.position=CGPointMake(0,-30);
    _controlslabel.zPosition=21;
    _mask=[SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    _mask.alpha=0.65;
    _mask.zPosition=20;
       
    _startbutton=[SKSpriteNode spriteNodeWithImageNamed:@"startbutton.png"];
    [_startbutton setScale:1.1];
    _startbutton.position=CGPointMake(self.size.width/4+83,self.size.height/2-12);
    _startbutton.zPosition=18;
    [self.camera addChild:_startbutton];
       
    //portal stuff
    self.travelportal=[[TravelPortal alloc] initWithImage:@"travelmirror.png"];
       
    //joystick initialization
    self.myjoystick=[[joystick alloc] initWithPos:CGPointMake(-158.27777099609375, -75)];
    self.myjoystick.zPosition=18;
    [self.camera addChild:self.myjoystick];
    
    //game over labels here
    won=[SKSpriteNode spriteNodeWithImageNamed:@"won.png"];
    won.position=CGPointMake(0, 51);
    won.zPosition=21;
    died=[SKSpriteNode spriteNodeWithImageNamed:@"died.png"];
    died.position=CGPointMake(0, 51);
    died.zPosition=21;
       
       
    //scene mutable arrays here
    self.bullets=[[NSMutableArray alloc]init];
    self.enemies=[[NSMutableArray alloc]init];
       
    //door stuff here
    self.repeating=NO;
    self.stayPaused=NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStayPaused) name:@"stayPausedNotification" object:nil];//notification listening for stayPausedNotification
       
   }
    return self;
}

- (void)update:(NSTimeInterval)currentTime{
  
  if(self.gameOver || self.stayPaused)
    return;
  
  NSTimeInterval delta=currentTime-self.storetime;
  
  if(delta>0.2)
    delta=0.2;
  
  self.storetime=currentTime;
  self.delta=delta;
  
  [self.player update:delta];
  
  //do collision detection calls here
  
  [self checkAndResolveCollisionsForPlayer];
  
  [self handleBulletEnemyCollisions];
}

-(void)setupVolumeSliderAndReplayAndContinue:(levelBase*)weakself{//**setup on main thread only**might set call to main thread in this function..
  weakself.volumeslider=[[MySlider alloc] initWithFrame:CGRectMake(weakself.view.bounds.size.width*0.746305,weakself.view.bounds.size.height/2, weakself.view.bounds.size.width*0.348610, 15.0)];
  
  weakself.volumeslider.minimumValue=0;
  weakself.volumeslider.maximumValue=100.0;
  weakself.volumeslider.tag=4545;
  weakself.volumeslider.continuous=YES;
  weakself.volumeslider.value=weakself.audiomanager.currentVolume;
  weakself.volumeslider.hidden=YES;
  weakself.volumeslider.minimumTrackTintColor=[SKColor redColor];
  weakself.volumeslider.maximumTrackTintColor=[SKColor darkGrayColor];
  [weakself.volumeslider setThumbImage:[UIImage imageNamed:@"supermetroid_sliderbar.png"] forState:UIControlStateNormal];
  [weakself.volumeslider setTransform:CGAffineTransformRotate(weakself.volumeslider.transform, M_PI_2)];
  [weakself.volumeslider setBackgroundColor:[SKColor clearColor]];
  [weakself.volumeslider addTarget:weakself action:@selector(slideraction:) forControlEvents:UIControlEventValueChanged];
  [weakself.view addSubview:weakself.volumeslider];
  
  _replaybutton=[UIButton buttonWithType:UIButtonTypeCustom]; //replay button
  _replaybutton.tag=666;
  [_replaybutton setImage:weakself.replayimage forState:UIControlStateNormal];
  [_replaybutton addTarget:weakself action:@selector(replaybuttonpush:) forControlEvents:UIControlEventTouchUpInside];
  _replaybutton.frame=CGRectMake(weakself.view.bounds.size.width/2.0-weakself.replayimage.size.width/2, weakself.view.bounds.size.height/2.0-weakself.replayimage.size.height/1.5, weakself.replayimage.size.width, weakself.replayimage.size.height);
  
  _continuebutton=[UIButton buttonWithType:UIButtonTypeCustom]; //continue button
  _continuebutton.tag=888;
  UIImage *continueimage=[UIImage imageNamed:@"continuebutton.png"];
  [_continuebutton setImage:continueimage forState:UIControlStateNormal];
  [_continuebutton addTarget:weakself action:@selector(continuebuttonpush:) forControlEvents:UIControlEventTouchUpInside];
  _continuebutton.frame=CGRectMake(weakself.view.bounds.size.width/2.0-continueimage.size.width/2, weakself.view.bounds.size.height/2.0-continueimage.size.height/1.5, continueimage.size.width, continueimage.size.height);
  
  _controlstext=[[UITextView alloc] initWithFrame:CGRectMake(weakself.view.bounds.size.width/2-(weakself.view.bounds.size.width*0.7)/2, weakself.view.bounds.size.height/4, weakself.view.bounds.size.width*0.7,weakself.view.bounds.size.height/2)];
  _controlstext.scrollEnabled=YES;
  _controlstext.editable=NO;
  [_controlstext setFont:[UIFont systemFontOfSize:16]];
  _controlstext.backgroundColor=[SKColor darkGrayColor];
  _controlstext.textColor=[SKColor whiteColor];
  _controlstext.text=@"Use the joystick to move around by sliding your finger,\nit is 5 directional allowing you to jump and move foreward or backwards at the same time,\n\nTap the upper right half of the screen to melee\n\nTap the lower right half of the screen to fire your weapon\n\nRemember, one touch at a time, but two fingers to fire are fair game!\n\nHealth Boxes are in all levels, look for the unusual tiles\n\nEnemies Guide:\nScisser: melee or fire to kill,\n\nHoneypot (walking cactus): melee or fire to kill, green projectiles means you can damage them with melee, red means they are invincible,\n\nWavers: melee or fire to kill, or simply keep your distance,\n\nChoot: melee or fire to kill, or just jump over,\n\nZero: melee or fire to kill.";
}

-(NSInteger)tileGIDAtTileCoord:(CGPoint)tilecoordinate forLayer:(TMXLayer *)fnclayer{
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

-(void)checkAndResolveCollisionsForPlayer{
  
  NSInteger tileindecies[8]={7,1,3,5,0,2,6,8};
  self.player.onGround=NO;
  
  for(NSInteger i=0;i<8;i++){
    NSInteger tileindex=tileindecies[i];
    CGRect playerrect=[self.player collisionBoundingBox];
    CGPoint playercoordinate=[self.walls coordForPoint:self.player.desiredPosition];
      
    if(playercoordinate.y >= self.map.mapSize.height-1 ){ //sets gameover if you go below the bottom of the maps y max-1
      [self gameOver:0];
      return;
    }
    if(self.player.position.x>=(self.map.mapSize.width*self.map.tileSize.width)-220 && !self.repeating){
      [self.map addChild:self.travelportal];
      self.repeating=YES;
    }
    if(self.travelportal!=NULL && CGRectIntersectsRect(CGRectInset(playerrect,4,6),[self.travelportal collisionBoundingBox])){
      [self.player runAction:[SKAction moveTo:self.travelportal.position duration:1.5] completion:^{[self gameOver:1];}];
      return;
    }

    NSInteger tilecolumn=tileindex%3; //this is how array of coordinates around player is navigated
    NSInteger tilerows=tileindex/3;   //using a 3X3 grid
    
    CGPoint tilecoordinate=CGPointMake(playercoordinate.x+(tilecolumn-1), playercoordinate.y+(tilerows-1));
    
    NSInteger thetileGID=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.walls];
    NSInteger hazardtilegid=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.hazards];
    NSInteger mysteryboxgid=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.mysteryboxes];
    
    if(thetileGID !=0 || mysteryboxgid!=0){
        CGRect tilerect=[self tileRectFromTileCoords:tilecoordinate];
        
        if(CGRectIntersectsRect(playerrect, tilerect)){
            CGRect pl_tl_intersection=CGRectIntersection(playerrect, tilerect); //distance of intersection where player and tile overlap
            switch (tileindex) {
                case 7:
                    //tile below the sprite
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x, self.player.desiredPosition.y+pl_tl_intersection.size.height);
                    
                    self.player.playervelocity=CGPointMake(self.player.playervelocity.x, 0.0);
                    self.player.onGround=YES;
                    [self.player stopFalling];
                    break;
                case 1:
                    //tile above the sprite
                    if(mysteryboxgid!=0){
                      //NSLog(@"hit a mysterybox!!");
                      [self.mysteryboxes removeTileAtCoord:tilecoordinate];
                      [self hitHealthBox]; //adjusts player healthlabel/healthbar
                    }
                    else{
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x, self.player.desiredPosition.y-pl_tl_intersection.size.height);
                    self.player.playervelocity=CGPointMake(self.player.playervelocity.x, 0.0);
                    }
                    break;
                case 3:
                    //tile back left of sprite
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x+pl_tl_intersection.size.width, self.player.desiredPosition.y);
                    break;
                case 5:
                    //tile front right of sprite
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x-pl_tl_intersection.size.width, self.player.desiredPosition.y);
                    break;
                    
                default:
                    if(pl_tl_intersection.size.width>pl_tl_intersection.size.height){
                      //this is for resolving collision up or down due to ^
                      float intersectionheight;
                      if(thetileGID!=0){
                          self.player.playervelocity=CGPointMake(self.player.playervelocity.x, 0.0);
                      }
                      
                      if(tileindex>4){
                        intersectionheight=pl_tl_intersection.size.height;
                        self.player.onGround=YES;
                        [self.player stopFalling];
                      }
                      else
                        intersectionheight=-pl_tl_intersection.size.height;
                      
                      self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x, self.player.desiredPosition.y+intersectionheight);
                    }
                    else{
                      //this is for resolving collisions left or right due to ^
                      float intersectionheight;
                      if(tileindex==0 || tileindex==6)
                        intersectionheight=pl_tl_intersection.size.width;
                      else
                        intersectionheight=-pl_tl_intersection.size.width;
                      
                      self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x+intersectionheight, self.player.desiredPosition.y);
                    }
                    break;
            }
            
        }
        
    }//if thetilegid bracket
    
    if(hazardtilegid!=0){//for hazard layer
      CGRect hazardtilerect=[self tileRectFromTileCoords:tilecoordinate];
      if(CGRectIntersectsRect(CGRectInset(playerrect, 1, 0), hazardtilerect)){
        [self damageRecievedMsg];
        if(self.player.health<=0){
          [self gameOver:0];
        }
      }//if rects intersect
    }//if hazard tile
    
    
    
  }//for loop bracket
  self.player.position=self.player.desiredPosition;
}//fnc bracket

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
  if(self.gameOver || self.player.meleeinaction || self.player.lockmovement)
    return;
  
  for(UITouch *touch in touches){
    //NSLog(@"touchbegan");
    CGPoint touchlocation=[touch locationInNode:self.camera];  //location of the touch
    [self.myjoystick moveFingertrackerto:touchlocation];
    //start delegating parts of the screen to specific movements
    
    if(self.paused && CGRectContainsPoint(_unpauselabel.frame, touchlocation)) //check for unpause/related pause items
      [self unpausegame];
    else if(self.paused && CGRectContainsPoint(_controlslabel.frame, touchlocation))
      [self displaycontrolstext];
    else if(self.paused && _controlstext.superview!=nil)
        [_controlstext removeFromSuperview];
    else if(self.paused)//loop if paused above here
      return;
    else if(CGRectContainsPoint(_startbutton.frame, touchlocation)){
      //[self.startbutton runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05] completion:^{NSLog(@"coloringstart");
      [self pausegame];
    }
    else if([self.myjoystick shouldGoForeward:touchlocation]){
      //NSLog(@"touching right control");
      self.player.goForeward=YES;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      if(!self.player.falling)
          [self.player runAction:self.player.runAnimation withKey:@"runf"];
    }
    else if([self.myjoystick shouldGoBackward:touchlocation]){
      //NSLog(@"touching left control");
      self.player.goBackward=YES;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      if(!self.player.falling)
          [self.player runAction:self.player.runBackwardsAnimation withKey:@"runb"];
    }
    else if([self.myjoystick shouldJump:touchlocation]){
      self.player.shouldJump=YES;
      self.player.falling=NO;
      if(self.player.forwardtrack)
        [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      else
        [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
    }
    else if([self.myjoystick shouldJumpForeward:touchlocation]){
      self.player.shouldJump=YES;
      self.player.goForeward=YES;
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      self.player.falling=NO;
      [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
    }
    else if([self.myjoystick shouldJumpBackward:touchlocation]){
      self.player.shouldJump=YES;
      self.player.goBackward=YES;
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      self.player.falling=NO;
      [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
    }
    else if(touchlocation.x>self.camera.frame.size.width/2 && touchlocation.y<self.camera.frame.size.height/2){
       //NSLog(@"start charge timer");
      if(![self.player actionForKey:@"chargeT"] && self.player.chargebeamenabled)
        [self.player runAction:self.player.chargebeamtimer withKey:@"chargeT"];
    }
    
  
  }//uitouch iteration end
}//function end



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{ //need to modify to fit ^v asap
  
  if(self.gameOver || self.paused || self.player.meleeinaction || self.player.lockmovement)
    return;
  
  //NSLog(@"Touch is moving");
  for(UITouch *touch in touches){
    CGPoint currtouchlocation=[touch locationInNode:self.camera];
    CGPoint previoustouchlocation=[touch previousLocationInNode:self.camera];
    [self.myjoystick moveFingertrackerto:currtouchlocation];
    if((currtouchlocation.x<self.camera.frame.size.width/2 || currtouchlocation.y>self.camera.frame.size.height/2) && [self.player actionForKey:@"chargeT"]){//remove charge beam & related timer
      //NSLog(@"removign  chargeT");
      [self.player removeActionForKey:@"chargeT"];
    }
    if(currtouchlocation.x>self.camera.frame.size.width/2 && (previoustouchlocation.x<=self.camera.frame.size.width/2)){//this code to disable
      //NSLog(@"moving to firing weapon");                                                                                  //movement and animations
      self.player.shouldJump=NO;                                                                                           //when fire/melee area is
      self.player.goForeward=NO;                                                                                           //accessed
      self.player.goBackward=NO;
      [self.player removeMovementAnims];
      [self.player resetTex];
    }
    else if([self.myjoystick shouldJump:currtouchlocation] && [self.myjoystick shouldGoForeward:previoustouchlocation]){
      //NSLog(@"moving from move right to jumping");
      self.player.shouldJump=YES;
      self.player.goForeward=NO;
      
      [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      [self.player removeActionForKey:@"runf"];
    }
    else if([self.myjoystick shouldJumpForeward:currtouchlocation] && [self.myjoystick shouldGoForeward:previoustouchlocation]){
      //NSLog(@"moving from move right to jmpfwd");
      self.player.shouldJump=YES;
      
      [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      [self.player removeActionForKey:@"runf"];
    }
    else if([self.myjoystick shouldJump:currtouchlocation] && [self.myjoystick shouldGoBackward:previoustouchlocation]){
      //NSLog(@"moving from move backward to jumping");
      self.player.shouldJump=YES;
      self.player.goBackward=NO;
      
      [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      [self.player removeActionForKey:@"runb"];
    }
    else if([self.myjoystick shouldJumpBackward:currtouchlocation] && [self.myjoystick shouldGoBackward:previoustouchlocation]){
      //NSLog(@"moving from move backward to jmpbkwd");
      self.player.shouldJump=YES;
      
      [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      [self.player removeActionForKey:@"runb"];
    }
    else if([self.myjoystick shouldGoForeward:currtouchlocation] && [self.myjoystick shouldGoBackward:previoustouchlocation]){
      //NSLog(@"moving from move backward to move right");
      self.player.goForeward=YES;
      self.player.goBackward=NO;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      [self.player runAction:self.player.runAnimation withKey:@"runf"];
      [self.player removeActionForKey:@"runb"];
    }
    else if([self.myjoystick shouldGoForeward:currtouchlocation] && [self.myjoystick shouldJump:previoustouchlocation]){
      //NSLog(@"move up to move right");
      self.player.goForeward=YES;
      self.player.goBackward=NO;
      self.player.shouldJump=NO;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      if([self.player actionForKey:@"jmpb"]){
        [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
        [self.player removeActionForKey:@"jmpb"];
        [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      }

    }
    else if([self.myjoystick shouldGoForeward:currtouchlocation] && [self.myjoystick shouldJumpForeward:previoustouchlocation]){
      //NSLog(@"moving from jmpfwd to move right");
      self.player.shouldJump=NO;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
    }
    else if([self.myjoystick shouldGoForeward:currtouchlocation] && [self.myjoystick shouldJumpBackward:previoustouchlocation]){
      //NSLog(@"moving from jmpbkwd to move right");
      self.player.shouldJump=NO;
      self.player.goForeward=YES;
      self.player.goBackward=NO;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      [self.player runAction:self.player.runAnimation withKey:@"runf"];
      [self.player removeActionForKey:@"jmpb"];
    }
    else if([self.myjoystick shouldGoBackward:currtouchlocation] && [self.myjoystick shouldGoForeward:previoustouchlocation]){
      //NSLog(@"move right to movebackwards");
      self.player.goBackward=YES;
      self.player.goForeward=NO;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      [self.player runAction:self.player.runBackwardsAnimation withKey:@"runb"];
      [self.player removeActionForKey:@"runf"];
    }
    else if([self.myjoystick shouldGoBackward:currtouchlocation] && [self.myjoystick shouldJump:previoustouchlocation]){
      //NSLog(@"move up to movebackwards");
      self.player.goBackward=YES;
      self.player.goForeward=NO;
      self.player.shouldJump=NO;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      if([self.player actionForKey:@"jmpf"]){
        [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
        [self.player removeActionForKey:@"jmpf"];
        [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      }
      
    }
    else if([self.myjoystick shouldGoBackward:currtouchlocation] && [self.myjoystick shouldJumpBackward:previoustouchlocation]){
      //NSLog(@"moving from jmpbkwd to move backwards");
      self.player.goBackward=YES;
      self.player.shouldJump=NO;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
    }
    else if([self.myjoystick shouldGoBackward:currtouchlocation] && [self.myjoystick shouldJumpForeward:previoustouchlocation]){
      //NSLog(@"moving from jmpfwd to move backwards");
      self.player.shouldJump=NO;
      self.player.goBackward=YES;
      self.player.goForeward=NO;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      [self.player runAction:self.player.runBackwardsAnimation withKey:@"runb"];
      [self.player removeActionForKey:@"jmpf"];
    }
    else if([self.myjoystick shouldJumpForeward:currtouchlocation] && [self.myjoystick shouldJump:previoustouchlocation]){
      //NSLog(@"moving from jump to jmpfwd");
      self.player.goForeward=YES;
      self.player.goBackward=NO;
      
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      
      if([self.player actionForKey:@"jmpb"]){
      //NSLog(@"change jump");
      [self.player runAction:self.player.jumpForewardsAnimation withKey:@"jmpf"];
      [self.player removeActionForKey:@"jmpb"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      }
    }
    else if([self.myjoystick shouldJumpBackward:currtouchlocation] && [self.myjoystick shouldJump:previoustouchlocation]){
      //NSLog(@"moving from jump to jumpbkwd");
      self.player.goBackward=YES;
      self.player.goForeward=NO;
      
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      
      if([self.player actionForKey:@"jmpf"]){
      //NSLog(@"change jump");
      [self.player runAction:self.player.jumpBackwardsAnimation withKey:@"jmpb"];
      [self.player removeActionForKey:@"jmpf"];
      [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
      }
    }
  
  }//for uitouch bracket
}//fnc bracket


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

  if(self.gameOver || self.paused)
    return;
  if(self.player.meleeinaction || self.player.lockmovement){//added here should test
    self.player.shouldJump=NO;//disable player movement
    self.player.goForeward=NO;
    self.player.goBackward=NO;
    [self.player removeMovementAnims];//remove player animations/other side effects ex jmpblk/charge beam timer
    return;
  }
  
  if(self.player.chargebeamactive){
    [self.player removeChargeSpr];
    self.player.chargebeamactive=NO;
  }
    
  for(UITouch *touch in touches){
  CGPoint fnctouchlocation=[touch locationInNode:self.camera];
    [self.myjoystick resetFingertracker];   //these movements must be NO after every touch finishes
    self.player.goForeward=NO;         //initial solution for fixing sticky buttons
    self.player.goBackward=NO;
    self.player.shouldJump=NO;
    [self.player removeMovementAnims];
    
    if([self.myjoystick shouldJump:fnctouchlocation] || [self.myjoystick shouldJumpBackward:fnctouchlocation] || [self.myjoystick shouldJumpForeward:fnctouchlocation]){
        [self.player startFalling];
      //NSLog(@"done touching up");
      //[self.player resetTex];
    }
    else if([self.myjoystick shouldGoForeward:fnctouchlocation]){
      //NSLog(@"done touching right");
      self.player.forwardtrack=YES;
      self.player.backwardtrack=NO;
      if(self.player.onGround)
          [self.player resetTex];
      else
          [self.player startFalling];
    }
    else if([self.myjoystick shouldGoBackward:fnctouchlocation]){
      //NSLog(@"done touching left");
      self.player.backwardtrack=YES;
      self.player.forwardtrack=NO;
      if(self.player.onGround)
          [self.player resetTex];
      else
          [self.player startFalling];
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
        if(self.player.falling)
            [self.player stopFalling];
      [self.player runAction:self.player.meleeactionright withKey:@"melee"];
    }
  
    
  }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{//maybe need to add for touch in touches
  NSLog(@"recieved CANCELED touch");
  [self.player removeMovementAnims];
  self.player.goForeward=NO;
  self.player.goBackward=NO;
  self.player.shouldJump=NO;
}

-(void)damageRecievedMsg{//for tile hazard layer if used
  --self.player.health;
  self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
  self.healthbar.size=CGSizeMake((((float)self.player.health/100)*self.healthbarsize), self.healthbar.size.height);
}

-(void)enemyhitplayerdmgmsg:(int)hit{
  if(!self.player.plyrrecievingdmg){
      self.player.plyrrecievingdmg=YES;
      self.player.health=self.player.health-hit;
      if(self.player.health<=0 && !self.gameOver){
          self.player.health=0;
          [self gameOver:0];
      }
      self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
      self.healthbar.size=CGSizeMake((((float)self.player.health/100)*self.healthbarsize), self.healthbar.size.height);
  
      [self.player runAction:[SKAction group:@[self.player.plyrdmgwaitlock,[SKAction repeatAction:self.player.damageaction count:15]]]];
  }
}

-(void)firePlayerProjectilewithdirection:(BOOL)direction{
  PlayerProjectile *newProjectile=[[PlayerProjectile alloc] initWithPos:self.player.position andMag_Range:self.player.currentBulletRange andType:self.player.currentBulletType andDirection:direction hit:self.player.currentBulletDamage];
  newProjectile.zPosition=16;
  [self.map addChild:newProjectile];
  [self.bullets addObject:newProjectile];
  if(self.player.chargebeamenabled && [self.player.currentBulletType isEqualToString:@"charge"])
    [self.player switchbeamto:@"chargereg"];
  //NSLog(@"adding projectile,count:%d",(int)self.bullets.count);
}

-(void)hitHealthBox{
  
  self.player.health+=10; //reward for hitting mystery box
  if(self.player.health>100){
    self.player.health=100;
  }
  
  self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
  self.healthbar.size=CGSizeMake((((float)self.player.health/100)*self.healthbarsize), self.healthbar.size.height);
}

-(void)slideraction:(id)sender{
  UISlider*tmpslider=(UISlider*)sender;
  self.audiomanager.bkgrndmusic.volume=tmpslider.value/100;
  self.audiomanager.currentVolume=tmpslider.value;
}

-(void)pausegame{
  //NSLog(@"game paused");
  //[self.startbutton runAction:[SKAction colorizeWithColor:[UIColor darkGrayColor] colorBlendFactor:0.8 duration:0.05] completion:^{NSLog(@"coloringstart");}];
  //[self.view addSubview:_controlstext];
  //[self.view bringSubviewToFront:_controlstext];
  [self.camera addChild:_mask];
  [self.camera addChild:_pauselabel];
  [self.camera addChild:_unpauselabel];
  [self.camera addChild:_controlslabel];
  self.volumeslider.hidden=NO;
  self.paused=YES;
  self.player.playervelocity=CGPointMake(0,18);
}
-(void)unpausegame{
  //[self.startbutton runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05] completion:^{NSLog(@"uncoloringstart");}];
  [_pauselabel removeFromParent];
  [_unpauselabel removeFromParent];
  [_controlslabel removeFromParent];
  [_mask removeFromParent];
  self.volumeslider.hidden=YES;
  
  self.player.shouldJump=NO;//disable player movement
  self.player.goForeward=NO;
  self.player.goBackward=NO;
  [self.player removeMovementAnims];
  [self.player resetTex];
  
  self.paused=NO;
}
-(void)displaycontrolstext{
  [self.view addSubview:_controlstext];
  [self.view bringSubviewToFront:_controlstext];
}

-(void)setStayPaused{//for use to keep the scene paused while returning from background
  //NSLog(@"staying paused");
  self.userInteractionEnabled=NO;
  self.stayPaused=YES;
  [self unpausegame];
  levelBase*weakself=self;
  [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.05],[SKAction runBlock:^{[weakself pausegame];}]]] completion:^{weakself.stayPaused=NO;}];
  self.userInteractionEnabled=YES;
}

-(void)willMoveFromView:(SKView *)view{
  //NSLog(@"moving from view");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) gameOver:(BOOL)didwin{
  
  self.gameOver=YES;
  [self.player removeAllActions];
  [self.player resetTex];
  
  if(didwin){
    __weak levelBase*weakself=self;
    __weak UIButton *weakcontinuebutton=_continuebutton;
    __weak SKSpriteNode*weakwon=won;
    [self.player runAction:self.player.travelthruportalAnimation completion:^{[weakself.camera addChild:weakwon];[weakself.view addSubview:weakcontinuebutton];}];
  }
  else{
    //label setup for end of game message
    [self.camera addChild:died/*endgamelabel*/];
    [self.view addSubview:_replaybutton];
  }
}

-(void)replaybuttonpush:(id)sender{}

-(void)continuebuttonpush:(id)sender{}

-(void)setBossInterac{}

-(void)handleBulletEnemyCollisions{}

-(instancetype)initNearBossWithSize:(CGSize)size andVol:(float)volume{
  return [self initWithSize:size andVol:volume];//have to return something before overloading in subclass
}

/*-(void)dealloc{
    NSLog(@"LVLBASE DEALLOCATED");
}*/

@end
