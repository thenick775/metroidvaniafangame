//
//  GameLevelScene3.m
//  Metroidvania
//
//  Created by nick vancise on 10/29/18.
//
#import "GameLevelScene3.h"
#import "door.h"
#import "sciserenemy.h"
#import "waver.h"
#import "SKTUtils.h"
#import "nettoriboss.h"
#import "powerupBubble.h"
#import "choot.h"
#import "desgeega.h"

@implementation GameLevelScene3{
    SKTextureAtlas*_lvl3assets;
    SKAction *removebosswall;
    nettoriboss *nettori;
    SKAction*idlecheck;
    SKAction*idleblock;
}

-(instancetype)initWithSize:(CGSize)size andVol:(float)vol{
    self = [super initWithSize:size andVol:vol];
    if (self!=nil) {
        self.volume=vol;
        
        self.backgroundColor = [SKColor blackColor];
        self.map = [JSTileMap mapNamed:@"level3.tmx"];
        [self addChild:self.map];
        [saveData editlvlwithval:@3 forsaveslot:[saveData getcurrslot]];
        [saveData arch];
    
        self.walls=[self.map layerNamed:@"walls"];
        self.hazards=[self.map layerNamed:@"hazards"];
        self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
        self.background=[self.map layerNamed:@"background"];
        self.foreground=[self.map layerNamed:@"foreground"];
        self.foreground.zPosition=17;
        
        _lvl3assets=[SKTextureAtlas atlasNamed:@"lvl3assets"];
        
        __weak GameLevelScene3*weakself=self;
        self.userInteractionEnabled=NO; //for use with player enter scene
        
        //audio setup (get rid of reference to previous audio manager)
        self.audiomanager=nil;
        
        //player initializiation stuff
        self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];
        self.player.position = CGPointMake(150, 170);
        self.player.zPosition = 15;
        self.hasHadBossInterac=NO;
        
        self.travelportal=NULL;
        [self.travelportal removeAllActions];
        [self.travelportal removeFromParent];
        
        SKConstraint*plyrconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:0 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-33] Y:[SKRange rangeWithUpperLimit:(self.map.tileSize.height*self.map.mapSize.height)-22]];
        plyrconst.referenceNode=self.parent;
        self.player.constraints=@[plyrconst];
        
        [self.map addChild:self.player];
        [self.player runAction:self.player.enterfromportalAnimation completion:^{[weakself.player runAction:[SKAction setTexture:weakself.player.forewards resize:YES]];weakself.userInteractionEnabled=YES;}];//need to modify to turn player when entering map, rename entermap/have seperate for travelthruportal
        
        self.player.forwardtrack=YES;
        self.player.backwardtrack=NO;
        
        //camera initialization
        SKRange *xrange=[SKRange rangeWithLowerLimit:self.size.width/2 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-self.size.width/2];
        SKRange *yrange=[SKRange rangeWithLowerLimit:self.size.height/2 upperLimit:(self.map.mapSize.height*self.map.tileSize.height)-self.size.height/2];
        SKConstraint*edgeconstraint=[SKConstraint positionX:xrange Y:yrange];
        self.camera.constraints=@[[SKConstraint distance:[SKRange rangeWithLowerLimit:0 upperLimit:4] toNode:self.player],edgeconstraint];
        self.replayimage=[UIImage imageNamed:@"replay5.png"];
        
        //mutable arrays here
        self.doors=[[NSMutableArray alloc]init];
        
        //scene items here
        SKSpriteNode*powerupstatue=[SKSpriteNode spriteNodeWithTexture:[_lvl3assets textureNamed:@"powerupstatuelvl3.png"]];
        powerupstatue.position=CGPointMake(17*self.map.tileSize.width, 5*self.map.tileSize.height);
        [powerupstatue setScale:0.7];
        powerupstatue.zPosition=0;
        [self.map addChild:powerupstatue];
        
        powerupBubble*bubble1=[[powerupBubble alloc] initWithPosition:CGPointMake(powerupstatue.position.x-11, powerupstatue.position.y+11) andCenter:CGPointMake(self.camera.frame.size.width/2,self.frame.size.height/2) andTexAtlas:_lvl3assets];
        [self.map addChild:bubble1];
        [self.enemies addObject:bubble1];
        
        //doors here
        door *door1=[[door alloc] initWithTextureAtlas:_lvl3assets hasMarker:NO andNames:@[@"door.png",@"door1.png",@"door2.png"]];
        door1.position=CGPointMake(39*self.map.tileSize.width, 7*self.map.tileSize.height);
        [self.map addChild:door1];
        [self.doors addObject:door1];
        
        door *door2=[[door alloc] initWithTextureAtlas:_lvl3assets hasMarker:YES andNames:@[@"bluedoor1.png",@"bluedoor2.png",@"bluedoor3.png",@"bluedoor4.png",@"bluedoor5.png",@"marker",@"bluedoormeniscus1.png",@"bluedoormeniscus2.png",@"bluedoormeniscus3.png",@"bluedoormeniscus4.png",@"doormeniscus5.png"]];
        door2.position=CGPointMake(81*self.map.tileSize.width, 6*self.map.tileSize.height);
        [self.map addChild:door2];
        [self.doors addObject:door2];
        
        door *door3=[[door alloc] initWithTextureAtlas:_lvl3assets hasMarker:NO andNames:@[@"door.png",@"door1.png",@"door2.png"]];
        door3.position=CGPointMake(128.5*self.map.tileSize.width, 6*self.map.tileSize.height);
        [self.map addChild:door3];
        [self.doors addObject:door3];
        
        door *door4=[[door alloc] initWithTextureAtlas:_lvl3assets hasMarker:NO andNames:@[@"door.png",@"door1.png",@"door2.png"]];
        door4.position=CGPointMake(144.5*self.map.tileSize.width, 19*self.map.tileSize.height);
        [self.map addChild:door4];
        [self.doors addObject:door4];
        
        door *door5=[[door alloc] initWithTextureAtlas:_lvl3assets hasMarker:YES andNames:@[@"bluedoor1.png",@"bluedoor2.png",@"bluedoor3.png",@"bluedoor4.png",@"bluedoor5.png",@"marker",@"bluedoormeniscus1.png",@"bluedoormeniscus2.png",@"bluedoormeniscus3.png",@"bluedoormeniscus4.png",@"doormeniscus5.png"]];
        door5.position=CGPointMake(178.5*self.map.tileSize.width, 5*self.map.tileSize.height);
        [self.map addChild:door5];
        [self.doors addObject:door5];
        
        //enemies here
        waver*enemy1=[[waver alloc] initWithPosition:CGPointMake(107*self.map.tileSize.width, 8*self.map.tileSize.height) xRange:350 yRange:15];
        [self.enemies addObject:enemy1];
        [self.map addChild:enemy1];
        
        waver*enemy2=[[waver alloc] initWithPosition:CGPointMake(87*self.map.tileSize.width, 8*self.map.tileSize.height) xRange:300 yRange:15];
        [self.enemies addObject:enemy2];
        [self.map addChild:enemy2];
        
        waver*enemy3=[[waver alloc] initWithPosition:CGPointMake(117*self.map.tileSize.width, 8*self.map.tileSize.height) xRange:128 yRange:15];
        [self.enemies addObject:enemy3];
        [self.map addChild:enemy3];
        
        choot*enemy4=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*98,self.map.tileSize.height*3) andDist:150 andCount:9 andTime:1.2 Del:0];
        [self.enemies addObject:enemy4];
        [self.map addChild:enemy4];
        
        choot*enemy5=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*117,self.map.tileSize.height*3) andDist:150 andCount:9 andTime:1.2 Del:5.364];
        [self.enemies addObject:enemy5];
        [self.map addChild:enemy5];
        
        choot*enemy6=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*297,self.map.tileSize.height*18) andDist:95 andCount:9 andTime:1.2 Del:5.364];
        [self.enemies addObject:enemy6];
        [self.map addChild:enemy6];
        
        choot*enemy7=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*301,self.map.tileSize.height*18) andDist:95 andCount:9 andTime:1.25 Del:5.364];
        [self.enemies addObject:enemy7];
        [self.map addChild:enemy7];
        
        choot*enemy8=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*305,self.map.tileSize.height*18) andDist:95 andCount:9 andTime:1.3 Del:5.364];
        [self.enemies addObject:enemy8];
        [self.map addChild:enemy8];
        
        choot*enemy9=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*319,self.map.tileSize.height*18) andDist:95 andCount:9 andTime:1.2 Del:5.364];
        [self.enemies addObject:enemy9];
        [self.map addChild:enemy9];
        
        choot*enemy10=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*323,self.map.tileSize.height*18) andDist:95 andCount:9 andTime:1.25 Del:5.364];
        [self.enemies addObject:enemy10];
        [self.map addChild:enemy10];
        
        choot*enemy11=[[choot alloc] initWithPos:CGPointMake(self.map.tileSize.width*327,self.map.tileSize.height*18) andDist:95 andCount:9 andTime:1.3 Del:5.364];
        [self.enemies addObject:enemy11];
        [self.map addChild:enemy11];
        
        desgeega*enemy12=[[desgeega alloc] initWithPosition:CGPointMake(self.map.tileSize.width*234, (self.map.tileSize.height*4)-3) andPosConst:[SKRange rangeWithLowerLimit:self.map.tileSize.width*222 upperLimit:self.map.tileSize.width*282] andJmpHeight:150 andJmpDist:80];
        [self.enemies addObject:enemy12];
        [self.map addChild:enemy12];
        
        desgeega*enemy13=[[desgeega alloc] initWithPosition:CGPointMake(self.map.tileSize.width*258, (self.map.tileSize.height*11)-3) andPosConst:[SKRange rangeWithLowerLimit:self.map.tileSize.width*255 upperLimit:self.map.tileSize.width*276] andJmpHeight:150 andJmpDist:80];
        [self.enemies addObject:enemy13];
        [self.map addChild:enemy13];
        
        nettori=[[nettoriboss alloc] initWithPosition:CGPointMake(176*self.map.tileSize.width-10, 5*self.map.tileSize.height-2)];
        [self.map addChild:nettori];
        [self.enemies addObject:nettori];
        
        __block BOOL bossdidenter=NO;
        __weak nettoriboss*weaknettori=nettori;
        idleblock=[SKAction runBlock:^{
            if(weakself.player.position.x>weaknettori.position.x-200 && weakself.player.position.y<(weakself.map.tileSize.height*weakself.map.mapSize.height)/2  && !bossdidenter){
                weaknettori.healthlbl.position=CGPointMake((-3.65*(weakself.size.width/10)), weakself.size.height/2-40);
                [weakself.camera addChild:weaknettori.healthlbl];
                [weaknettori startAttack];
                //weakself.hasHadBossInterac=YES;
                [weakself setBossInterac];
                bossdidenter=YES;
                [weakself removeActionForKey:@"idlecheck"];
            }
        }];
        
        removebosswall=[SKAction runBlock:^{
            [weaknettori.healthlbl removeFromParent];
            for(int i=13;i<20;i++){
                [weakself.walls removeTileAtCoord:CGPointMake(174,i)];
                [weakself.walls removeTileAtCoord:CGPointMake(175,i)];
            }}];
        
        idlecheck=[SKAction sequence:@[[SKAction waitForDuration:10],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:1],idleblock]]]]];
        [self runAction:idlecheck];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    //setup sound
    self.audiomanager=[gameaudio alloc];
    [self.audiomanager runBkgrndMusicForlvl:3 andVol:self.volume];
    
    __weak GameLevelScene3*weakself=self;
    dispatch_async(dispatch_get_main_queue(), ^{//deal with certain ui on main thread only
        [weakself setupVolumeSliderAndReplayAndContinue:weakself];
    });
}

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [[self.view viewWithTag:4545] removeFromSuperview];
    //[self.view presentScene:[[GameLevelScene3 alloc] initWithSize:self.size andVol:self.audiomanager.currentVolume/100]];
    if(self.hasHadBossInterac){
        [self removeAllActions];
        [self removeAllChildren];
        [self.view presentScene:[[GameLevelScene3 alloc] initNearBossWithSize:self.size andVol:self.audiomanager.currentVolume/100]];
    }
    else{
        [self removeAllActions];
        [self removeAllChildren];
        [self.view presentScene:[[GameLevelScene3 alloc] initWithSize:self.size andVol:self.audiomanager.currentVolume/100]];
    }
    //[gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}

-(void)handleBulletEnemyCollisions{ //switch this to ise id in fast enumeration so as to keep 1 enemy arr with multiple enemy types
    BOOL bulletlock=NO;
    
    __weak GameLevelScene3*weakself=self;
    
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
        
        for(id enemyl in self.enemies){//swotch this to below line
            //NSLog(@"bullet frame:%@",NSStringFromCGRect(currbullet.frame));
                enemyBase*enemylcop=(enemyBase*)enemyl;
                if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,enemylcop.dx,enemylcop.dy), currbullet.frame) && !enemylcop.dead){
                    //NSLog(@"hit an enemy");
                    [enemylcop hitByBulletWithArrayToRemoveFrom:self.enemies withHit:currbullet.hit];
                    
                    if([enemylcop isKindOfClass:[nettoriboss class]] && enemylcop.dead){//maybe
                        //NSLog(@"removing boss wall");
                        [self runAction:removebosswall];
                    }
                    
                    [currbullet removeAllActions];
                    [currbullet removeFromParent];
                    [self.bullets removeObject:currbullet];
                    bulletlock=YES;//to prevent from comparing with a deallocated bullet for door collision
                    break; //if bullet hits enemy stop checking for same bullet
                }
        }
        
        if(!bulletlock){
        for(door* door in _doors){//maybe handle doors along with enemies to disperse run through of this array
            if(fabs((self.player.position.x-door.position.x)<180) && CGRectIntersectsRect(door.frame, currbullet.frame) && !door.openAlready){
            [door opendoor];
            [currbullet removeAllActions];
            [currbullet removeFromParent];
            [self.bullets removeObject:currbullet];
            break; //if bullet hits enemy stop checking for same bullet
            }
        }
        }
    }//for currbullet
    
    
    
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
            //NSLog(@"TILE GID: %ld Tile coordinate: %@ Tile rect: %@ Player Rect: %@",(long)thetileGID,NSStringFromCGPoint(tilecoordinate),NSStringFromCGRect(tilerect),NSStringFromCGRect(playerrect));
            //collision detection here
            
            if(CGRectIntersectsRect(playerrect, tilerect)){
                CGRect pl_tl_intersection=CGRectIntersection(playerrect, tilerect); //distance of intersection where player and tile overlap
                
                if(tileindex==7){
                    //tile below the sprite
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x, self.player.desiredPosition.y+pl_tl_intersection.size.height);
                    
                    self.player.playervelocity=CGPointMake(self.player.playervelocity.x, 0.0);
                    self.player.onGround=YES;
                }
                else if(tileindex==1){
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
                }
                else if(tileindex==3){
                    //tile back left of sprite
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x+pl_tl_intersection.size.width, self.player.desiredPosition.y);
                }
                else if(tileindex==5){
                    //tile front right of sprite
                    self.player.desiredPosition=CGPointMake(self.player.desiredPosition.x-pl_tl_intersection.size.width, self.player.desiredPosition.y);
                }
                else{
                    if(pl_tl_intersection.size.width>pl_tl_intersection.size.height){
                        //this is for resolving collision up or down due to ^
                        float intersectionheight;
                        if(thetileGID!=0){
                            self.player.playervelocity=CGPointMake(self.player.playervelocity.x, 0.0);
                        }
                        
                        if(tileindex>4){
                            intersectionheight=pl_tl_intersection.size.height;
                            self.player.onGround=YES;
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
        
        if(tileindex==3 || tileindex==5 || tileindex==1 || tileindex==7){
        for(door*tmpdoor in self.doors){
            [tmpdoor handleCollisionsWithPlayer:self.player];
        }
        }
        
    }//for loop bracket
    self.player.position=self.player.desiredPosition;
}//fnc bracket

-(instancetype)initNearBossWithSize:(CGSize)size andVol:(float)volume{
    self=[self initWithSize:size andVol:volume];
    if(self!=nil){
        for(SKSpriteNode*tmp in self.enemies.reverseObjectEnumerator){
            if([tmp isKindOfClass:[nettoriboss class]] || tmp.position.x>nettori.position.x)
                continue;
            else{
                [tmp removeAllActions];
                [tmp removeAllChildren];
                [tmp removeFromParent];
                [self.enemies removeObject:tmp];
            }
        }
        self.player.position=CGPointMake(149*self.map.tileSize.width, 23*self.map.tileSize.height);
        self.player.chargebeamenabled=YES;
        [self.player switchbeamto:@"chargereg"];
        idlecheck=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.8],idleblock]]];
        [self runAction:idlecheck];
    }
    return self;
}

-(void)setBossInterac{
    //NSLog(@"in set boss interac");
    if(!self.hasHadBossInterac){
        //NSLog(@"actually setting boss interac");
        self.hasHadBossInterac=YES;
        [saveData editseenbosswithval:YES forsaveslot:[saveData getcurrslot]];
        [saveData arch];
    }
}

/*-(void)dealloc {
    NSLog(@"LVL3 SCENE DEALLOCATED");
}*/

@end
