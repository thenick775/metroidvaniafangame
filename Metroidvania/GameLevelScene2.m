//
//  GameLevelScene2.m
//  Metroidvania
//
//  Created by nick vancise on 6/10/18.

#import "GameLevelScene2.h"
#import "sciserenemy.h"
#import "honeypot.h"
#import "arachnusboss.h"
#import "SKTUtils.h"
#import "PlayerProjectile.h"
#import "waver.h"
#import "gameaudio.h"

@implementation GameLevelScene2{
    arachnusboss*boss1;
    SKAction *handlebridge;
    SKAction *idlecheck;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //self.view.ignoresSiblingOrder=YES; //for performance optimization every time this class is instanciated
        [self.map removeFromParent]; //gets rid of super's implementation of my map
        self.map=nil;
        self.backgroundColor = [SKColor blackColor];
        self.map = [JSTileMap mapNamed:@"level2.tmx"];
        [self addChild:self.map];
        
        self.walls=[self.map layerNamed:@"walls"];
        self.hazards=[self.map layerNamed:@"hazards"];
        self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
        self.background=[self.map layerNamed:@"background"];
        
        __weak GameLevelScene2*weakself=self;
        self.userInteractionEnabled=NO; //for use with player enter scene
        
        //audio setup (get rid of reference to previous audio manager)
        self.audiomanager=nil;
        
        //player initializiation stuff
        self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];//_fusion_walking3_v1.png"];
        self.player.position = CGPointMake(100, 150);
        self.player.zPosition = 15;
        
        SKConstraint*plyrconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:0 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-33] Y:[SKRange rangeWithUpperLimit:(self.map.tileSize.height*self.map.mapSize.height)-22]];
        plyrconst.referenceNode=self.parent;
        self.player.constraints=[NSArray arrayWithObjects:plyrconst, nil];
        
        [self.map addChild:self.player];
        [self.player runAction:self.player.enterfromportalAnimation completion:^{[weakself.player runAction:[SKAction setTexture:weakself.player.forewards resize:YES]];weakself.userInteractionEnabled=YES;}];//need to modify to turn player when entering map, rename entermap/have seperate for travelthruportal
        
        self.player.forwardtrack=YES;
        self.player.backwardtrack=NO;
        
        //camera initialization
        SKRange *xrange=[SKRange rangeWithLowerLimit:self.size.width/2 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-self.size.width/2];
        SKRange *yrange=[SKRange rangeWithLowerLimit:self.size.height/2 upperLimit:(self.map.mapSize.height*self.map.tileSize.height)-self.size.height/2];
        SKConstraint*edgeconstraint=[SKConstraint positionX:xrange Y:yrange];
        self.camera.constraints=[NSArray arrayWithObjects:[SKConstraint distance:[SKRange rangeWithLowerLimit:0 upperLimit:4] toNode:self.player],edgeconstraint, nil];
       
        //star background initialization here
        SKEmitterNode *starbackground=[SKEmitterNode nodeWithFileNamed:@"starsbackground.sks"];
        starbackground.position=CGPointMake(2400,(self.map.mapSize.height*self.map.tileSize.height));
        [starbackground advanceSimulationTime:180.0];
        [self.map addChild: starbackground];
        
        //portal adjust position to suit this level
        self.travelportal.position=CGPointMake(self.map.tileSize.width*391,self.map.tileSize.height*8);
        
        //mutable arrays here
        [self.bullets removeAllObjects];
        [self.enemies removeAllObjects];
        self.bullets=[[NSMutableArray alloc]init];
        self.enemies=[[NSMutableArray alloc]init];
        
        //enemies here
        sciserenemy *enemy=[[sciserenemy alloc] initWithPos:CGPointMake(self.player.position.x+100, self.player.position.y-108)];
        [self.enemies addObject:enemy];
        [self.map addChild:enemy];
        
        sciserenemy *enemy1=[[sciserenemy alloc] initWithPos:CGPointMake(64*self.map.tileSize.width,16*self.map.tileSize.height-7)];
        [self.enemies addObject:enemy1];
        [self.map addChild:enemy1];
        
        honeypot *enemy2=[[honeypot alloc] initcomplete];
        enemy2.position=CGPointMake(179*self.map.tileSize.width,3*self.map.tileSize.height-3);
        [self.enemies addObject:enemy2];
        [self.map addChild:enemy2];
        
        honeypot *enemy3=[[honeypot alloc] initcomplete];
        enemy3.position=CGPointMake(110*self.map.tileSize.width,20*self.map.tileSize.height-3);
        [self.enemies addObject:enemy3];
        [self.map addChild:enemy3];
        
        honeypot *enemy4=[[honeypot alloc] initcomplete];
        enemy4.position=CGPointMake(367*self.map.tileSize.width,18*self.map.tileSize.height-3);
        [self.enemies addObject:enemy4];
        [self.map addChild:enemy4];
        
        waver*enemy5=[[waver alloc] initWithPosition:CGPointMake(31*self.map.tileSize.width, 8*self.map.tileSize.height)];
        [self.enemies addObject:enemy5];
        [self.map addChild:enemy5];
        
        boss1=[[arachnusboss alloc] initWithImageNamed:@"wait_1.png"];
        boss1.position=CGPointMake(3980,56);
        boss1.zPosition=-81.0;
        [self.map addChild:boss1];
        
        SKAction* bridgeblk=[SKAction runBlock:^{
            int plyrtilecoordx=[weakself.walls coordForPoint:weakself.player.position].x;
            if(plyrtilecoordx>296){
                //remove all the tiles for the bridge
                for(int i=264;i<=296;i++){
                    [weakself.walls removeTileAtCoord:CGPointMake(i,28)];
                }
                [weakself removeActionForKey:@"handlebridge"];
            }
            else if(plyrtilecoordx>263){
                [weakself.walls setTileGid:1 at:CGPointMake(plyrtilecoordx,28)];
                if(plyrtilecoordx+1<297)
                    [weakself.walls setTileGid:1 at:CGPointMake(plyrtilecoordx+1,28)];
                if(plyrtilecoordx-1>263)
                    [weakself.walls setTileGid:1 at:CGPointMake(plyrtilecoordx-1,28)];
                if(plyrtilecoordx-2>263)
                    [weakself.walls setTileGid:3063 at:CGPointMake(plyrtilecoordx-2,28)];
                if(plyrtilecoordx+2<297)
                    [weakself.walls setTileGid:3063 at:CGPointMake(plyrtilecoordx+2,28)];
            }
            
            
        }];
        
        SKAction* removebosswall=[SKAction runBlock:^{
            for(int i=23;i<28;i++){
                [weakself.walls removeTileAtCoord:CGPointMake(263,i)];
                [weakself.background removeTileAtCoord:CGPointMake(262,i)];
            }}];
        
        handlebridge=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:8.5],removebosswall,[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.1],bridgeblk, nil]]],nil]];
        
        SKEmitterNode*bossintro=[SKEmitterNode nodeWithFileNamed:@"arachnusintroduction.sks"];
        bossintro.zPosition=16;
        bossintro.position=CGPointMake(249*self.map.tileSize.width,2*self.map.tileSize.height);
        __weak arachnusboss*weakboss1=boss1;
        __block BOOL bossdidenter=NO;
        SKAction*idleblk=[SKAction runBlock:^{
            NSLog(@"checking boss idle");
            if(weakself.player.meleeinaction && CGRectIntersectsRect(CGRectMake(weakself.player.meleeweapon.frame.origin.x+weakself.player.frame.origin.x, weakself.player.meleeweapon.frame.origin.y+weakself.player.frame.origin.y, weakself.player.meleeweapon.frame.size.width, weakself.player.meleeweapon.frame.size.height),weakboss1.frame) && !bossdidenter){
                bossdidenter=YES;
                [weakself addChild:bossintro];
                [weakself runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:3.0],[SKAction runBlock:^{
                    weakboss1.zPosition=0.0;
                    for(int i=247;i<=250;i++){
                        for(int k=25;k<=27;k++){
                            [weakself.walls removeTileAtCoord:CGPointMake(i,k)];
                        }
                    }
                    [bossintro removeFromParent];
                    weakboss1.zPosition=0.0;
                    [weakself.enemies addObject:weakboss1];
                    weakboss1.active=YES;
                    [weakself removeActionForKey:@"idlecheck"];
                }], nil]]];
            }
        }];
        idlecheck=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:85],[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1],idleblk, nil]]], nil]];
        [self runAction:idlecheck withKey:@"idlecheck"]; 
     
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    //setup sound
    self.audiomanager=[gameaudio alloc];
    [self.audiomanager runBkgrndMusicForlvl:2];
}

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [self.view presentScene:[[GameLevelScene2 alloc] initWithSize:self.size]];
    [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}


-(void)handleBulletEnemyCollisions{
    if(boss1.active)
    [boss1 handleanimswithfocuspos:self.player.position.x];   //evaluate boss actions/attacks
    
    for(id enemycon in [self.enemies reverseObjectEnumerator]){//enemy to player (also including melee to enemy for convienence)
        
        if([enemycon isKindOfClass:[sciserenemy class]]){
            sciserenemy*enemyconcop=(sciserenemy*)enemycon;
        if(fabs(self.player.position.x-enemyconcop.position.x)<70){  //minimize comparisons
            //NSLog(@"in here");
            if(CGRectContainsPoint(self.player.collisionBoundingBox, CGPointAdd(enemyconcop.enemybullet1.position, enemyconcop.position))){
                //NSLog(@"enemy hit player bullet#1");
                [enemyconcop.enemybullet1 setHidden:YES];
                if(!self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg:10];
                }
            }
            else if(CGRectContainsPoint(self.player.collisionBoundingBox,CGPointAdd(enemyconcop.enemybullet2.position, enemyconcop.position))){
                //NSLog(@"enemy hit player buller#2");
                [enemyconcop.enemybullet2 setHidden:YES];
                if(!self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg:10];
                }
            }
            if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect(CGRectMake(self.player.meleeweapon.frame.origin.x+self.player.frame.origin.x, self.player.meleeweapon.frame.origin.y+self.player.frame.origin.y, self.player.meleeweapon.frame.size.width, self.player.meleeweapon.frame.size.height),enemyconcop.frame)){
                //NSLog(@"meleehit");
                enemyconcop.health=enemyconcop.health-10;
                self.player.meleedelay=YES; //this variable locks melee to 1 hit every 1.2 sec, might need a weakself
                [self runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.2],[SKAction runBlock:^{self.player.meleedelay=NO;}], nil]]];//encapsulate in playerclass (ex meleedelayac or something)
                if(enemyconcop.health<=0){
                    [enemyconcop removeAllActions];
                    [enemyconcop removeAllChildren];
                    [enemyconcop removeFromParent];
                    [self.enemies removeObject:enemyconcop];
                }
            }
        }
    }
    else if([enemycon isKindOfClass:[arachnusboss class]]){
        arachnusboss*enemyconcop=(arachnusboss*)enemycon;
        if(fabs(self.player.position.x-enemyconcop.position.x)<440){
        if(CGRectContainsPoint(CGRectInset(enemyconcop.frame,3,0), self.player.position) && !self.player.plyrrecievingdmg){
                self.player.plyrrecievingdmg=YES;
                [self enemyhitplayerdmgmsg:10];
        }
        for(SKSpriteNode*arachchild in [enemyconcop.projectilesinaction reverseObjectEnumerator]){
            if(CGRectIntersectsRect(self.player.collisionBoundingBox,arachchild.frame) && !self.player.plyrrecievingdmg){
                self.player.plyrrecievingdmg=YES;
                [self enemyhitplayerdmgmsg:15];
            }
        }
    }
  }
    else if([enemycon isKindOfClass:[honeypot class]]){
        honeypot*enemyconcop=(honeypot*)enemycon;
        if(enemyconcop.dead){
            [enemyconcop updateWithDeltaTime:0.16];
            CGPoint realpos=[self convertPoint:self.player.position toNode:enemyconcop];
            enemyconcop.target.position=vector2((float)realpos.x,(float)realpos.y);
        
            for(honeypotproj *child in [enemyconcop.children reverseObjectEnumerator]){
                if(CGRectContainsPoint(self.player.frame,[self convertPoint:child.position fromNode:enemyconcop]) && !self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg:10];
                }
            }
            if(enemyconcop.agentSystem.components.count==0){
                [enemyconcop removeAllActions];
                [enemyconcop removeAllChildren];
                [enemyconcop removeFromParent];
                [self.enemies removeObject:enemyconcop];
            }
        
        }
            
        else if(CGRectIntersectsRect(self.player.frame,enemyconcop.frame) && !self.player.plyrrecievingdmg && !enemyconcop.dead){
            self.player.plyrrecievingdmg=YES;
            [self enemyhitplayerdmgmsg:10];
        }
        if(self.player.position.x>enemyconcop.position.x+150 && [enemyconcop actionForKey:@"walk"]){
            NSLog(@"past position of player");
            __weak honeypot*weakenemyconcop=enemyconcop;
            [enemyconcop removeActionForKey:@"walk"];
            [enemyconcop runAction:enemyconcop.explode completion:^{weakenemyconcop.texture=nil;enemyconcop.dead=YES;}];
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
            [self enemyhitplayerdmgmsg:8];
        }
        if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect(CGRectMake(self.player.meleeweapon.frame.origin.x+self.player.frame.origin.x, self.player.meleeweapon.frame.origin.y+self.player.frame.origin.y, self.player.meleeweapon.frame.size.width, self.player.meleeweapon.frame.size.height),enemyconcop.frame)){
            //NSLog(@"meleehit");
            enemyconcop.health=enemyconcop.health-10;
            self.player.meleedelay=YES; //this variable locks melee to 1 hit every 1.2 sec, might need a weakself
            [self runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.2],[SKAction runBlock:^{self.player.meleedelay=NO;}], nil]]];//encapsulate in playerclass (ex meleedelayac or something)
            if(enemyconcop.health<=0){
                [enemyconcop removeAllActions];
                [enemyconcop removeAllChildren];
                [enemyconcop removeFromParent];
                [self.enemies removeObject:enemyconcop];
            }
        }
    }
        
}
    
    
    for(PlayerProjectile *currbullet in [self.bullets reverseObjectEnumerator]){//bullet to enemy
        
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
                    [enemyl runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[enemyl removeFromParent];}], nil]]];
                    [self.enemies removeObject:enemyl];
                }
                [currbullet removeAllActions];
                [currbullet removeFromParent];
                [self.bullets removeObject:currbullet];
                break; //if bullet hits enemy stop checking for same bullet
            }
        }
            else if([enemyl isKindOfClass:[arachnusboss class]]){
                arachnusboss*enemylcop=(arachnusboss*)enemyl;
                if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,5,0), currbullet.frame)){
                    //NSLog(@"hit an enemy");
                    enemylcop.health--;
                    if(enemylcop.health<=0){
                        [self.enemies removeObject:enemylcop];
                        [self runAction:handlebridge withKey:@"handlebridge"];
                    }
                    [currbullet removeAllActions];
                    [currbullet removeFromParent];
                    [self.bullets removeObject:currbullet];
                    break; //if bullet hits enemy stop checking for same bullet
                }
            }
            else if([enemyl isKindOfClass:[honeypot class]]){
                honeypot*enemylcop=(honeypot*)enemyl;
                if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,5,0),currbullet.frame) && [enemylcop actionForKey:@"walk"]/*!enemylcop.dead*/){
                    enemylcop.health--;
                    if(enemylcop.health<=0 && /*!enemylcop.dead*/[enemylcop actionForKey:@"walk"]){
                        __weak honeypot*weakenemylcop=enemylcop;
                        [weakenemylcop removeActionForKey:@"walk"];
                        [enemylcop runAction:enemylcop.explode completion:^{weakenemylcop.texture=nil;enemylcop.dead=YES;}];
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
                        [enemyl runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[enemyl removeFromParent];}], nil]]];
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


/*- (void)dealloc {
    NSLog(@"LVL2 SCENE DEALLOCATED");
}*/

@end
