//
//  GameLevelScene2.m
//  SuperKoalio
//
//  Created by nick vancise on 6/10/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

#import "GameLevelScene2.h"
#import "JSTileMap.h"
#import "SKTUtils.h"
#import "Player.h"
#import "PlayerProjectile.h"
#import "sciserenemy.h"
#import "TravelPortal.h"

@interface GameLevelScene2()

@property (nonatomic,strong) Player *player;
@property (nonatomic,strong) JSTileMap *map;
@property (nonatomic,strong) TMXLayer *walls,*hazards,*mysteryboxes;
@property (nonatomic,assign) NSTimeInterval storetime;
@property (nonatomic,assign) BOOL gameOver;
@property (nonatomic,strong) SKLabelNode *healthlabel;
@property (nonatomic,strong) SKSpriteNode *healthbar,*healthbarborder;
@property (nonatomic,strong) NSMutableArray *enemies,*bullets;

@end

@implementation GameLevelScene2{
    double _healthbarsize; //size of healthbar at start used to reduce the bar by a constant rate equivilent with playerhealth
    TravelPortal * _travelportal;
    BOOL _repeating;
    SKSpriteNode *buttonup,*buttonright,*buttonleft,*startbutton;
    SKSpriteNode*pauselabel,*unpauselabel;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.view.ignoresSiblingOrder=YES; //for performance optimization every time this class is instanciated
        //self.view.shouldCullNonVisibleNodes=NO; //??? seems to help framerate for now
        
        self.backgroundColor = [SKColor blackColor];/*[SKColor colorWithRed:0.7259 green:0 blue:0.8863 alpha:1.0];*/
        self.map = [JSTileMap mapNamed:@"level2.tmx"];
        [self addChild:self.map];
        
        self.walls=[self.map layerNamed:@"walls"];
        self.hazards=[self.map layerNamed:@"hazards"];
        self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
        
        //player initializiation stuff
        self.player = [[Player alloc] initWithImageNamed:@"samus_fusion_walking3_v1.png"];
        self.player.position = CGPointMake(100, 150);
        self.player.zPosition = 15;
        [self.map addChild:self.player];
        
        self.player.forwardtrack=YES;
        self.player.backwardtrack=NO;
        
        //health label initialization
        self.healthlabel=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
        self.healthlabel.fontSize=15;
        self.healthlabel.zPosition=14;
        self.healthlabel.position=CGPointMake(self.size.width/10+3, self.size.height-20);
        [self addChild:self.healthlabel];
        
        //health bar stuff initialization
        self.healthbar=[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(200, 20)];
        self.healthbar.zPosition=12;
        self.healthbar.anchorPoint=CGPointMake(0.0, 0.0);
        self.healthbar.position=CGPointMake(self.size.width/20-10, self.size.height-24);
        [self addChild:self.healthbar];
        _healthbarsize=(double)self.healthbar.size.width;
        
        self.healthbarborder=[SKSpriteNode spriteNodeWithImageNamed:@"healthbarborder.png"];
        self.healthbarborder.anchorPoint=CGPointMake(0.0, 0.0);
        self.healthbarborder.zPosition=13;
        self.healthbarborder.position=CGPointMake(self.size.width/20-10, self.size.height-24);
        [self addChild:self.healthbarborder];
        
        //button stuff unless i find a better place to put it...
        buttonup=[SKSpriteNode spriteNodeWithImageNamed:@"buttonupv4real.png"];
        buttonup.position=CGPointMake(self.size.width/6, self.size.height/2-36);
        [self addChild:buttonup];
        
        buttonleft=[SKSpriteNode spriteNodeWithImageNamed:@"buttonleftv2real.png"];
        buttonleft.position=CGPointMake(self.size.width/6-28, self.size.height/2-75);
        [self addChild:buttonleft];
        
        buttonright=[SKSpriteNode spriteNodeWithImageNamed:@"buttonrightv2real.png"];
        buttonright.position=CGPointMake(self.size.width/6+28, self.size.height/2-75);
        [self addChild:buttonright];
        
        startbutton=[SKSpriteNode spriteNodeWithImageNamed:@"startbutton.png"];
        startbutton.position=CGPointMake(self.size.width/2+206,self.size.height-12);
        [self addChild:startbutton];
        
        //mutable arrays here
        self.bullets=[[NSMutableArray alloc]init];
        self.enemies=[[NSMutableArray alloc]init];
        
        //enemies here
        sciserenemy *enemy=[[sciserenemy alloc] initWithPos:CGPointMake(self.player.position.x+100, self.player.position.y-108)];
        [self.enemies addObject:enemy];
        [self.map addChild:enemy];
        
        /*sciserenemy *enemy2=[[sciserenemy alloc] initWithPos:CGPointMake(self.map.mapSize.width * self.map.tileSize.width-400, self.player.position.y-120)];
        [self.enemies addObject:enemy2];
        [self.map addChild:enemy2];*/
        
        //door stuff here
        _repeating=NO;
        
        self.userInteractionEnabled=YES;
        
    }
    return self;
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
    
    //if(self.bullets.count!=0)
    [self handleBulletEnemyCollisions];
    
    [self setViewPointCenter:self.player.position];
    
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
        }else if(fncplayer.position.y>self.map.tileSize.height*self.map.mapSize.height-20)//opposite of-^
            self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x,self.map.tileSize.height*self.map.mapSize.height-20);
        if(fncplayer.position.x>=(self.map.mapSize.width*self.map.tileSize.width)-220 && !_repeating){
            _travelportal=[[TravelPortal alloc] initWithStuff:@"travelmirror.png"];
            _travelportal.position=CGPointMake((self.map.mapSize.width * self.map.tileSize.width)-120, 95.0);
            [self.map addChild:_travelportal];
            _repeating=YES;
        }
        if(fncplayer.position.x<0){
            NSLog(@"off screen resetting pos");
            self.player.desiredPosition=CGPointMake(0,47.49);
        }
        else if(fncplayer.position.x>=(self.map.mapSize.width*self.map.tileSize.width)-32){
            self.player.desiredPosition=CGPointMake((self.map.mapSize.width*self.map.tileSize.width)-33, self.player.desiredPosition.y);
        }
        if(_travelportal!=NULL && CGRectIntersectsRect(CGRectInset(playerrect,4,6),[_travelportal collisionBoundingBox])){
            SKAction *moveplayeraction=[SKAction moveTo:_travelportal.position duration:1.5];
            [fncplayer runAction:moveplayeraction completion:^{[self gameOver:1];}];
            return;
        }
        
        
        
        NSInteger tilecolumn=tileindex%3; //this is how array of coordinates around player is navigated
        NSInteger tilerows=tileindex/3;
        
        CGPoint tilecoordinate=CGPointMake(playercoordinate.x+(tilecolumn-1), playercoordinate.y+(tilerows-1));
        
        NSInteger thetileGID=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.walls];
        NSInteger hazardtilegid=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.hazards];
        NSInteger mysteryboxgid=[self tileGIDAtTileCoord:tilecoordinate forLayer:self.mysteryboxes];
        
        
        if(thetileGID !=0 ){
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
                    fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x, fncplayer.desiredPosition.y-pl_tl_intersection.size.height);
                    fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0);
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
                        fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0);
                        
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
                NSLog(@"hit hazard");
                [self damageRecievedMsg];
                if(fncplayer.health<=0){
                    [self gameOver:0];
                }
            }//if rects intersect
        }//if hazard tile
        
        if(mysteryboxgid!=0){//for mysterybox layer
            CGRect mysboxtilerect=[self tileRectFromTileCoords:tilecoordinate];
            
            if(CGRectIntersectsRect(playerrect, mysboxtilerect)){
                CGRect playermysbox_intersection=CGRectIntersection(playerrect, mysboxtilerect);
                
                if(tileindex==1){
                    //NSLog(@"hit a mysterybox!!");
                    [self.mysteryboxes removeTileAtCoord:tilecoordinate];
                    [self hitHealthBox]; //adjusts player healthlabel/healthbar
                    
                }
                if(tileindex==7){
                    fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x, fncplayer.desiredPosition.y+playermysbox_intersection.size.height);
                    
                    fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0);
                    fncplayer.onGround=YES;
                }
                else if(tileindex==3){
                    fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x+playermysbox_intersection.size.width, fncplayer.desiredPosition.y);
                }
                else if(tileindex==5){
                    fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x-playermysbox_intersection.size.width, fncplayer.desiredPosition.y);
                }
                else{
                    if(playermysbox_intersection.size.width>playermysbox_intersection.size.height){
                        //this is for resolving collision up or down due to ^
                        float intersectionheight;
                        //fncplayer.playervelocity=CGPointMake(fncplayer.playervelocity.x, 0.0); // so as to avoid rough jumping collisions
                        
                        if(tileindex>4){
                            intersectionheight=playermysbox_intersection.size.height;
                            fncplayer.onGround=YES;
                        }
                        else
                            intersectionheight=-playermysbox_intersection.size.height;
                        fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x, fncplayer.desiredPosition.y+intersectionheight);
                    }
                    else{
                        //this is for resolving collisions left or right due to ^
                        float intersectionheight;
                        
                        if(tileindex==0 || tileindex==6)
                            intersectionheight=playermysbox_intersection.size.width;
                        else
                            intersectionheight=-playermysbox_intersection.size.width;
                        
                        fncplayer.desiredPosition=CGPointMake(fncplayer.desiredPosition.x+intersectionheight, fncplayer.desiredPosition.y);
                    }
                }
            }//if mysboxrect intersects playerrect
        }//if mysterybox
        
        
    }//for loop bracket
    fncplayer.position=fncplayer.desiredPosition;
}//fnc bracket



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(self.gameOver)
        return;
    
    for(UITouch *touch in touches){
        
        CGPoint touchlocation=[touch locationInNode:self];  //location of the touch
        
        //start delegating parts of the screen to specific movements
        
        if(self.paused && CGRectContainsPoint(unpauselabel.frame, touchlocation)) //check for unpause
            [self unpausegame];
        else if(self.paused)
            return;
        else if(CGRectContainsPoint(buttonright.frame, touchlocation)){
            NSLog(@"touching right control");
            self.player.goForeward=YES;
            
            self.player.forwardtrack=YES;
            self.player.backwardtrack=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.runAnimation] withKey:@"runf"];
        }
        else if(CGRectContainsPoint(buttonleft.frame, touchlocation)){
            NSLog(@"touching left control");
            self.player.goBackward=YES;
            
            self.player.backwardtrack=YES;
            self.player.forwardtrack=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.runBackwardsAnimation] withKey:@"runb"];
        }
        else if(CGRectContainsPoint(buttonup.frame, touchlocation)){
            NSLog(@"touching up control");
            self.player.shouldJump=YES;
            if(self.player.forwardtrack)
                [self.player runAction:[SKAction repeatActionForever:self.player.jumpForewardsAnimation] withKey:@"jmpf"];
            else
                [self.player runAction:[SKAction repeatActionForever:self.player.jumpBackwardsAnimation] withKey:@"jmpb"];
        }
        else if(CGRectContainsPoint(startbutton.frame, touchlocation)){
            [self pausegame];
        }
        else if(touchlocation.x>self.size.width/2 && touchlocation.y<self.size.height/2){
            self.player.fireProjectile=YES;
            //NSLog(@"firing weapon");
        }
        
        
    }//uitouch iteration end
}//function end



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{ //need to modify to fit ^v asap
    
    if(self.gameOver || self.paused)
        return;
    
    
    //NSLog(@"Touch is moving");
    for(UITouch *touch in touches){
        
        CGPoint currtouchlocation=[touch locationInNode:self];
        CGPoint previoustouchlocation=[touch previousLocationInNode:self];
        
        if(currtouchlocation.x>self.size.width/2 && (previoustouchlocation.x<=self.size.width/2)){
            NSLog(@"moving to firing weapon");
            self.player.shouldJump=NO;
            self.player.goForeward=NO;
            self.player.goBackward=NO;
            self.player.fireProjectile=YES;
        }
        else if(CGRectContainsPoint(buttonup.frame, currtouchlocation) && CGRectContainsPoint(buttonright.frame, previoustouchlocation)){
            NSLog(@"moving from move right to jumping");
            self.player.shouldJump=YES;
            self.player.goForeward=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.jumpForewardsAnimation] withKey:@"jmpf"];
            [self.player removeActionForKey:@"runf"];
        }
        else if(CGRectContainsPoint(buttonup.frame, currtouchlocation) && CGRectContainsPoint(buttonleft.frame, previoustouchlocation)){
            NSLog(@"moving from move backward to jumping");
            
            self.player.shouldJump=YES;
            self.player.goBackward=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.jumpBackwardsAnimation] withKey:@"jmpb"];
            [self.player removeActionForKey:@"runb"];
        }
        else if(CGRectContainsPoint(buttonright.frame, currtouchlocation) && CGRectContainsPoint(buttonleft.frame, previoustouchlocation)){
            NSLog(@"moving from move backward to moveforeward");
            self.player.goForeward=YES;
            self.player.goBackward=NO;
            
            self.player.forwardtrack=YES;
            self.player.backwardtrack=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.runAnimation] withKey:@"runf"];
            [self.player removeActionForKey:@"runb"];
        }
        else if(CGRectContainsPoint(buttonright.frame, currtouchlocation) && CGRectContainsPoint(buttonup.frame, previoustouchlocation)){
            NSLog(@"move up to move foreward");
            self.player.goForeward=YES;
            self.player.shouldJump=NO;
            
            
            [self.player runAction:[SKAction repeatActionForever:self.player.jumpForewardsAnimation] withKey:@"jmpf"];
            [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
        }
        else if(CGRectContainsPoint(buttonleft.frame, currtouchlocation) && CGRectContainsPoint(buttonright.frame, previoustouchlocation)){
            NSLog(@"move forewards to movebackwards");
            self.player.goBackward=YES;
            self.player.goForeward=NO;
            
            self.player.backwardtrack=YES;
            self.player.forwardtrack=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.runBackwardsAnimation] withKey:@"runb"];
            [self.player removeActionForKey:@"runf"];
        }
        else if(CGRectContainsPoint(buttonleft.frame, currtouchlocation) && CGRectContainsPoint(buttonup.frame, previoustouchlocation)){
            NSLog(@"move up to movebackwards");
            self.player.goBackward=YES;
            self.player.shouldJump=NO;
            
            [self.player runAction:[SKAction repeatActionForever:self.player.jumpBackwardsAnimation] withKey:@"jmpb"];
            [self.player runAction:[SKAction repeatActionForever:self.player.jmptomfmbcheck] withKey:@"jmpblk"];
        }
        else if(!CGRectContainsPoint(buttonup.frame, currtouchlocation) && !CGRectContainsPoint(buttonright.frame, currtouchlocation) && !CGRectContainsPoint(buttonleft.frame, currtouchlocation) && currtouchlocation.x<self.size.width/2){
            NSLog(@"not in dpad");
            self.player.shouldJump=NO;
            self.player.goForeward=NO;
            self.player.goBackward=NO;
            self.player.fireProjectile=NO;
            [self.player removeAllActions];
        }
        
        
    }//for uitouch bracket
}//fnc bracket


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(self.gameOver || self.paused)
        return;
    
    for(UITouch *touch in touches){
        CGPoint fnctouchlocation=[touch locationInNode:self];
        
        [self.player removeActionForKey:@"jmpblk"]; //these actions are the only ones possibly needing to be removed
        [self.player removeActionForKey:@"runf"];
        [self.player removeActionForKey:@"runb"];
        [self.player removeActionForKey:@"jmpf"];
        [self.player removeActionForKey:@"jmpb"];
        
        
        if(CGRectContainsPoint(buttonup.frame, fnctouchlocation)){
            //NSLog(@"done touching up");
            self.player.shouldJump=NO;
            if(self.player.backwardtrack)
                [self.player runAction:[SKAction repeatAction:self.player.standbackwardsAnimation count:3]];
            else
                [self.player runAction:[SKAction repeatAction:self.player.standAnimation count:3]];
        }
        else if(CGRectContainsPoint(buttonright.frame, fnctouchlocation)){
            //NSLog(@"done touching right");
            self.player.goForeward=NO;
            self.player.forwardtrack=YES;
            self.player.backwardtrack=NO;
            [self.player runAction:[SKAction repeatAction:self.player.standAnimation count:3]];
            
        }
        else if(CGRectContainsPoint(buttonleft.frame, fnctouchlocation)){
            //NSLog(@"done touching left");
            self.player.goBackward=NO;
            self.player.backwardtrack=YES;
            self.player.forwardtrack=NO;
            [self.player runAction:[SKAction repeatAction:self.player.standbackwardsAnimation count:3]];
        }
        else if(CGRectContainsPoint(startbutton.frame, fnctouchlocation)){
            NSLog(@"do nothing hit the pause");
        }
        else if(fnctouchlocation.x>self.size.width/2 && fnctouchlocation.y<self.size.height/2){
            self.player.fireProjectile=NO;
            //call build projectile/set it going right ->
            if(self.player.forwardtrack)
                [self firePlayerProjectilewithdirection:TRUE];
            else
                [self firePlayerProjectilewithdirection:FALSE];
            //NSLog(@"done firing weapon");
        }
        else if(fnctouchlocation.x>self.size.width/2 && fnctouchlocation.y>self.size.height/2){
            [self.player runAction:self.player.meleeactionright];
        }
        
        
    }
}
-(void)firePlayerProjectilewithdirection:(BOOL)direction{
    PlayerProjectile *newProjectile=[[PlayerProjectile alloc] initWithPos:self.player.position andDirection:direction];
    newProjectile.zPosition=16;
    [self.map addChild:newProjectile];
    [self.bullets addObject:newProjectile];
    //NSLog(@"adding projectile,count:%d",(int)self.bullets.count);
}


-(void)handleBulletEnemyCollisions{
    
    //NSLog(@"enemypoint:%@",NSStringFromCGRect(CGRectMake(self.player.meleeweapon.frame.origin.x+self.player.frame.origin.x, self.player.meleeweapon.frame.origin.y+self.player.frame.origin.y, self.player.meleeweapon.frame.size.width, self.player.meleeweapon.frame.size.height)));
    
    for(sciserenemy*enemycon in [self.enemies reverseObjectEnumerator]){    //check all of this for __weak problems, due to blocks
        if(fabs(self.player.position.x-enemycon.position.x)<70){  //minimize comparisons
            //NSLog(@"in here");
            if(CGRectContainsPoint(self.player.collisionBoundingBox, CGPointAdd(enemycon.enemybullet1.position, enemycon.position))){
                NSLog(@"enemy hit player bullet#1");
                [enemycon.enemybullet1 setHidden:YES];
                if(!self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg];
                }
            }
            else if(CGRectContainsPoint(self.player.collisionBoundingBox,CGPointAdd(enemycon.enemybullet2.position, enemycon.position))){
                NSLog(@"enemy hit player buller#2");
                [enemycon.enemybullet2 setHidden:YES];
                if(!self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg];
                }
            }
            if(self.player.meleeinaction && CGRectIntersectsRect(CGRectMake(self.player.meleeweapon.frame.origin.x+self.player.frame.origin.x, self.player.meleeweapon.frame.origin.y+self.player.frame.origin.y, self.player.meleeweapon.frame.size.width, self.player.meleeweapon.frame.size.height),enemycon.frame)){
                NSLog(@"meleehit");
                enemycon.health=enemycon.health-10;
                if(enemycon.health<=0){
                    [enemycon removeAllActions];
                    [enemycon removeAllChildren];
                    [enemycon removeFromParent];
                    [self.enemies removeObject:enemycon];
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
        
        if(self.enemies.count!=0){
            for(sciserenemy *enemyl in self.enemies){
                //NSLog(@"bullet frame:%@",NSStringFromCGRect(currbullet.frame));
                if(CGRectIntersectsRect(CGRectInset(enemyl.frame,5,0), currbullet.frame)){
                    //NSLog(@"hit an enemy");
                    enemyl.health--;
                    if(enemyl.health<=0){
                        [enemyl removeAllActions];
                        [enemyl removeAllChildren];
                        [enemyl removeFromParent];
                        [self.enemies removeObject:enemyl];
                    }
                    [currbullet removeAllActions];
                    [currbullet removeFromParent];
                    [self.bullets removeObject:currbullet];
                    break; //if bullet hits enemy stop checking for same bullet
                }
            }
        }//if enemiescount!=0
    }//for currbullet
    
    
    
}

-(void)damageRecievedMsg{
    
    --self.player.health;
    self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
    self.healthbar.size=CGSizeMake((self.healthbar.size.width-(_healthbarsize/100)), self.healthbar.size.height);
    
}
-(void)enemyhitplayerdmgmsg{
    self.player.health=self.player.health-10;
    if(self.player.health<=0){
        self.player.health=0;
        [self gameOver:0];
    }
    self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
    self.healthbar.size=CGSizeMake((((float)self.player.health/100)*_healthbarsize), self.healthbar.size.height);
    
    [self.player runAction:self.player.plyrdmgwaitlock completion:^{NSLog(@"waitlockdone");}];
    [self.player runAction:[SKAction repeatAction:self.player.damageaction count:15] completion:^{NSLog(@"dmganimationdone");}];
}

-(void)pausegame{
    NSLog(@"game paused");
    
    pauselabel=[SKSpriteNode spriteNodeWithImageNamed:@"pauselabel.png"];
    pauselabel.position=CGPointMake(self.size.width/2, self.size.height/2+35);
    [self addChild:pauselabel];
    
    unpauselabel=[SKSpriteNode spriteNodeWithImageNamed:@"unpauselabel.png"];
    unpauselabel.position=CGPointMake(self.size.width/2, self.size.height/2+10);
    [self addChild: unpauselabel];
    
    self.paused=YES;
    self.player.playervelocity=CGPointMake(0,18);
    
}
-(void)unpausegame{
    [pauselabel removeFromParent];
    [unpauselabel removeFromParent];
    self.paused=NO;
}

-(void)setViewPointCenter:(CGPoint) position{
    
    NSInteger x=MAX(position.x,self.size.width/2);
    NSInteger y=MAX(position.y, self.size.height/2);
    
    x = MIN(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width / 2);
    y = MIN(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height / 2);
    
    CGPoint actualPosition=CGPointMake(x, y);
    CGPoint centerOfTheView=CGPointMake(self.size.width/2, self.size.height/2);
    CGPoint viewPoint=CGPointSubtract(centerOfTheView, actualPosition);
    
    self.map.position=viewPoint;
}


-(void) gameOver:(BOOL)didwin{
    
    self.gameOver=YES;
    [self.player removeAllActions];
    
    NSString *fintext;
    //label setup for end of game message
    SKLabelNode *endgamelabel=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    endgamelabel.fontSize=40;
    endgamelabel.position=CGPointMake(self.size.width/2.0, self.size.height/2+35);
    
    //setup replay message/reset the screen stuff
    UIButton *replaybutton=[UIButton buttonWithType:UIButtonTypeCustom];
    replaybutton.tag=666;
    UIImage *replayimage=[UIImage imageNamed:@"replay"];
    [replaybutton setImage:replayimage forState:UIControlStateNormal];
    [replaybutton addTarget:self action:@selector(replaybuttonpush:) forControlEvents:UIControlEventTouchUpInside];
    replaybutton.frame=CGRectMake(self.size.width/2.0-replayimage.size.width/4.0+5, self.size.height/2.0-replayimage.size.height/4.0+5, replayimage.size.width, replayimage.size.height);
    
    
    if(didwin){
        fintext=@"You Won!";
        endgamelabel.text=fintext;
        [self.player runAction:self.player.travelthruportalAnimation completion:^{[self addChild:endgamelabel];[self.view addSubview:replaybutton];}];
    }
    else{
        fintext=@"You Died :(";
        //label setup for end of game message
        endgamelabel.text=fintext;
        [self addChild:endgamelabel];
        [self.view addSubview:replaybutton];
    }
}
-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [self.view presentScene:[[GameLevelScene2 alloc] initWithSize:self.size]];
}


-(void)hitHealthBox{
    
    self.player.health+=10; //reward for hitting mystery box
    if(self.player.health>100){
        self.player.health=100;
    }
    
    self.healthlabel.text=[NSString stringWithFormat:@"Health:%d",self.player.health];
    self.healthbar.size=CGSizeMake((((float)self.player.health/100)*_healthbarsize), self.healthbar.size.height);
}

/*- (void)dealloc {
 NSLog(@"LVL1 SCENE DEALLOCATED");
 }*/




@end
