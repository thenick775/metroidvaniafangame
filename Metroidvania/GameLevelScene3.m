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
#import "PlayerProjectile.h"

@implementation GameLevelScene3{
    SKTextureAtlas*_lvl3assets;
}

-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self!=nil) {
        [self.map removeFromParent];
        self.map=nil;
        
        self.backgroundColor = [SKColor blackColor];
        self.map = [JSTileMap mapNamed:@"level3.tmx"];
        [self addChild:self.map];
    
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
        self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];//_fusion_walking3_v1.png"];
        self.player.position = CGPointMake(150, 170);
        self.player.zPosition = 15;
        
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
        
        //mutable arrays here
        [self.bullets removeAllObjects];
        [self.enemies removeAllObjects];
        self.bullets=[[NSMutableArray alloc]init];
        self.enemies=[[NSMutableArray alloc]init];
        self.doors=[[NSMutableArray alloc]init];
        
        //scene items here
        SKSpriteNode*powerupstatue=[SKSpriteNode spriteNodeWithTexture:[_lvl3assets textureNamed:@"powerupstatuelvl3.png"]];
        powerupstatue.position=CGPointMake(17*self.map.tileSize.width, 5*self.map.tileSize.height);
        [powerupstatue setScale:0.7];
        powerupstatue.zPosition=0;
        [self.map addChild:powerupstatue];
        
        //doors here
        door *door1=[[door alloc] initWithTextureAtlas:_lvl3assets andNames:@[@"door.png",@"door1.png",@"door2.png"]];
        door1.position=CGPointMake(39*self.map.tileSize.width, 7*self.map.tileSize.height);
        [self.map addChild:door1];
        [self.doors addObject:door1];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    //setup sound
    self.audiomanager=[gameaudio alloc];
    //[self.audiomanager runBkgrndMusicForlvl:2];
    
    __weak GameLevelScene3*weakself=self;
    dispatch_async(dispatch_get_main_queue(), ^{//deal with certain ui on main thread only
        self.volumeslider=[[UISlider alloc] initWithFrame:CGRectMake(weakself.size.width/2+200,weakself.size.height/2+15, weakself.size.height-40, 15.0)];
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

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [self.view presentScene:[[GameLevelScene3 alloc] initWithSize:self.size]];
    [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
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
        
        for(door* door in _doors){
            if(fabs((self.player.position.x-door.position.x)<100) && CGRectIntersectsRect(door.frame, currbullet.frame) && !door.passable)
                [door opendoor];
        }
    }//for currbullet
    
    
    
}




/*- (void)dealloc {
    NSLog(@"LVL3 SCENE DEALLOCATED");
}*/

@end
