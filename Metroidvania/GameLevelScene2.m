//
//  GameLevelScene2.m
//  Metroidvania
//
//  Created by nick vancise on 6/10/18.

#import "GameLevelScene2.h"
#import "GameLevelScene3.h"
#import "sciserenemy.h"
#import "honeypot.h"
#import "arachnusboss.h"
#import "SKTUtils.h"
#import "PlayerProjectile.h"
#import "waver.h"
#import "gameaudio.h"
#import "enemyBase.h"

@implementation GameLevelScene2{
    arachnusboss*boss1;
    SKAction *handlebridge;
    SKAction *idlecheck;
}

-(instancetype)initWithSize:(CGSize)size {
    self=[super initWithSize:size];
    if (self!=nil) {
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
        self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];
        self.player.position = CGPointMake(100, 150);
        //self.player.position=CGPointMake(3980-60,100);
        self.player.zPosition = 15;
        self.hasHadBossInterac=NO;
        
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
        sciserenemy *enemy=[[sciserenemy alloc] initWithPos:CGPointMake(12.5*self.map.tileSize.width,2.625*self.map.tileSize.height)];
        [self.enemies addObject:enemy];
        [self.map addChild:enemy];
        
        sciserenemy *enemy1=[[sciserenemy alloc] initWithPos:CGPointMake(64*self.map.tileSize.width,16*self.map.tileSize.height-7)];
        [self.enemies addObject:enemy1];
        [self.map addChild:enemy1];
        
        honeypot *enemy2=[[honeypot alloc] init];
        enemy2.position=CGPointMake(179*self.map.tileSize.width,3*self.map.tileSize.height-3);
        [self.enemies addObject:enemy2];
        [self.map addChild:enemy2];
        
        honeypot *enemy3=[[honeypot alloc] init];
        enemy3.position=CGPointMake(110*self.map.tileSize.width,20*self.map.tileSize.height-3);
        [self.enemies addObject:enemy3];
        [self.map addChild:enemy3];
        
        honeypot *enemy4=[[honeypot alloc] init];
        enemy4.position=CGPointMake(367*self.map.tileSize.width,18*self.map.tileSize.height-3);
        [self.enemies addObject:enemy4];
        [self.map addChild:enemy4];
        
        waver*enemy5=[[waver alloc] initWithPosition:CGPointMake(31*self.map.tileSize.width, 8*self.map.tileSize.height) xRange:350 yRange:20];
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
                    [weakself.walls setTileGid:3007 at:CGPointMake(plyrtilecoordx-2,28)];
                if(plyrtilecoordx+2<297)
                    [weakself.walls setTileGid:3007 at:CGPointMake(plyrtilecoordx+2,28)];
            }
        }];
        
        __weak arachnusboss*weakboss1=boss1;
        
        SKAction* removebosswall=[SKAction runBlock:^{
            [weakboss1.healthlbl removeFromParent];
            for(int i=23;i<28;i++){
                [weakself.walls removeTileAtCoord:CGPointMake(263,i)];
                [weakself.background removeTileAtCoord:CGPointMake(262,i)];
            }}];
        
        handlebridge=[SKAction sequence:@[[SKAction waitForDuration:8.5],removebosswall,[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.1],bridgeblk]]]]];
        
        SKEmitterNode*bossFire=[SKEmitterNode nodeWithFileNamed:@"arachnusintroduction.sks"];
        bossFire.zPosition=16;
        bossFire.position=CGPointMake(249*self.map.tileSize.width,2*self.map.tileSize.height);
        
        __block BOOL bossdidenter=NO;
        __block BOOL timerrepeat=NO;
        SKAction *bossEntrance=[SKAction sequence:@[[SKAction waitForDuration:3.0],[SKAction runBlock:^{
            weakboss1.zPosition=0.0;
            weakboss1.healthlbl.position=CGPointMake((-3.65*(weakself.size.width/10)), weakself.size.height/2-40);
            [weakself.camera addChild:weakboss1.healthlbl];
            for(int i=247;i<=250;i++){
                for(int k=25;k<=27;k++){
                    [weakself.walls removeTileAtCoord:CGPointMake(i,k)];
                }
            }
            [bossFire removeFromParent];
            weakboss1.zPosition=0.0;
            [weakself.enemies addObject:weakboss1];
            weakboss1.active=YES;
            [weakself removeActionForKey:@"idlecheck"];
        }]]];
        
        SKAction*idleblk=[SKAction runBlock:^{
            //NSLog(@"checking boss idle");
            if(weakself.player.meleeinaction && CGRectIntersectsRect([weakself.player meleeBoundingBoxNormalized],weakboss1.frame) && !bossdidenter){
                [weakself removeActionForKey:@"backuptimer"];
                weakself.hasHadBossInterac=YES;
                bossdidenter=YES;
                [weakself addChild:bossFire];
                [weakself runAction:bossEntrance];
            }
            else if(weakself.player.position.x>weakboss1.position.x-100 && !bossdidenter && !timerrepeat){
                weakself.hasHadBossInterac=YES;
                timerrepeat=YES;
                [weakself runAction:[SKAction sequence:@[[SKAction waitForDuration:13.0],[SKAction runBlock:^{
                bossdidenter=YES;
                [weakself addChild:bossFire];
                [weakself runAction:bossEntrance];
                }]]] withKey:@"backuptimer"];
            }
        }];
        idlecheck=[SKAction sequence:@[[SKAction waitForDuration:38],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:1],idleblk]]]]];
        [self runAction:idlecheck withKey:@"idlecheck"];
     
        //
        self.player.chargebeamenabled=YES;
        //
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    //setup sound
    self.audiomanager=[gameaudio alloc];
    [self.audiomanager runBkgrndMusicForlvl:2];
    
    __weak GameLevelScene2*weakself=self;
    dispatch_async(dispatch_get_main_queue(), ^{//deal with certain ui on main thread only
        [weakself setupVolumeSliderAndReplayAndContinue:weakself];
    });
}

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [[self.view viewWithTag:4545] removeFromSuperview];
    if(self.hasHadBossInterac)
        [self.view presentScene:[[GameLevelScene2 alloc] initNearBossWithSize:self.size]];
    else
        [self.view presentScene:[[GameLevelScene2 alloc] initWithSize:self.size]];
    [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}
-(void)continuebuttonpush:(id)sender{
    [[self.view viewWithTag:888] removeFromSuperview];
    [[self.view viewWithTag:4545] removeFromSuperview];
    __weak GameLevelScene2*weakself=self;
    [SKTextureAtlas preloadTextureAtlasesNamed:@[@"lvl3assets",@"Nettori"] withCompletionHandler:^(NSError*error,NSArray*foundatlases){
        GameLevelScene3*preload=[[GameLevelScene3 alloc]initWithSize:weakself.size];
        preload.scaleMode = SKSceneScaleModeAspectFill;
        NSLog(@"preloaded lvl3");
        [weakself.view presentScene:preload];
    }];
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
                [self enemyhitplayerdmgmsg:25];
            }
            else if(CGRectContainsPoint(self.player.collisionBoundingBox,CGPointAdd(enemyconcop.enemybullet2.position, enemyconcop.position))){
                //NSLog(@"enemy hit player bullet#2");
                [enemyconcop.enemybullet2 setHidden:YES];
                [self enemyhitplayerdmgmsg:25];
            }
            if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect([self.player meleeBoundingBoxNormalized],enemyconcop.frame)){
                //NSLog(@"meleehit");
                [self.player runAction:self.player.meleedelayac];
                [enemyconcop hitByMeleeWithArrayToRemoveFrom:self.enemies];
            }
        }
    }
    else if([enemycon isKindOfClass:[arachnusboss class]]){
        arachnusboss*enemyconcop=(arachnusboss*)enemycon;
        if(fabs(self.player.position.x-enemyconcop.position.x)<440){
        if(CGRectContainsPoint(CGRectInset(enemyconcop.frame,3,0), self.player.position)){
                [self enemyhitplayerdmgmsg:15];
        }
        for(SKSpriteNode*arachchild in [enemyconcop.projectilesinaction reverseObjectEnumerator]){
            if(CGRectIntersectsRect(self.player.collisionBoundingBox,arachchild.frame)){
                [self enemyhitplayerdmgmsg:22];
            }
        }
    }
  }
    else if([enemycon isKindOfClass:[honeypot class]]){
        honeypot*enemyconcop=(honeypot*)enemycon;
        if(enemyconcop.dead){
            [enemyconcop updateWithDeltaTime:self.delta];
            CGPoint realpos=[self convertPoint:self.player.position toNode:enemyconcop];
            enemyconcop.target.position=vector2((float)realpos.x,(float)realpos.y);
        
            for(honeypotproj *child in [enemyconcop.children reverseObjectEnumerator]){
                if(CGRectContainsPoint(self.player.frame,[self convertPoint:child.position fromNode:enemyconcop])){
                    [self enemyhitplayerdmgmsg:12];
                }
                if(!child.anger && self.player.meleeinaction && !self.player.meleedelay && CGRectContainsPoint([self.player meleeBoundingBoxNormalized],[self convertPoint:child.position fromNode:enemyconcop])){
                    //NSLog(@"hit honeypot child");
                    [enemyconcop dealChildDamage:3 withChild:child];
                }
            }
            if(enemyconcop.agentSystem.components.count==0){
                [enemyconcop removeAllActions];
                [enemyconcop removeAllChildren];
                [enemyconcop removeFromParent];
                [self.enemies removeObject:enemyconcop];
            }
        
        }
        else if(CGRectIntersectsRect(self.player.frame,enemyconcop.frame) && [enemyconcop actionForKey:@"walk"]/*!enemyconcop.dead*/){
            [self enemyhitplayerdmgmsg:15];
        }
        if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect([self.player meleeBoundingBoxNormalized],enemyconcop.frame) && [enemyconcop actionForKey:@"walk"]){
            //NSLog(@"meleehit");
            [self.player runAction:self.player.meleedelayac];
            [enemyconcop hitByMeleeWithArrayToRemoveFrom:self.enemies];
        }
        if(self.player.position.x>enemyconcop.position.x+150 && [enemyconcop actionForKey:@"walk"]){
            //NSLog(@"past position of player");
            [enemyconcop runAction:enemyconcop.explodeangry];
        }
        
    }
    else if([enemycon isKindOfClass:[waver class]]){
        waver*enemyconcop=(waver*)enemycon;
        [enemyconcop updateWithDeltaTime:self.delta andPlayerpos:self.player.position];
        if(fabs(self.player.position.x-enemyconcop.position.x)<40 && fabs(self.player.position.y-enemyconcop.position.y)<60 && !enemyconcop.attacking){
            [enemyconcop attack];
        }
        if(CGRectIntersectsRect(self.player.frame,CGRectInset(enemyconcop.frame,2,0))){
            [self enemyhitplayerdmgmsg:15];
        }
        if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect([self.player meleeBoundingBoxNormalized],enemyconcop.frame)){
            //NSLog(@"meleehit");
            [self.player runAction:self.player.meleedelayac];
            [enemyconcop hitByMeleeWithArrayToRemoveFrom:self.enemies];
        }
    }
        
}
    
    
    for(PlayerProjectile *currbullet in [self.bullets reverseObjectEnumerator]){//bullet to enemy
        if(currbullet.cleanup || [self tileGIDAtTileCoord:[self.walls coordForPoint:currbullet.position] forLayer:self.walls]){//here to avoid another run through of arr
            //NSLog(@"removing from array");
            [currbullet removeAllActions];
            [currbullet removeFromParent];
            [self.bullets removeObject:currbullet];
            continue;//avoid comparing with removed bullet
        }
        
        for(id enemyl in self.enemies){
        if([enemyl isKindOfClass:[arachnusboss class]]){
                arachnusboss*enemylcop=(arachnusboss*)enemyl;
                if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,5,0), currbullet.frame)){
                    //NSLog(@"hit an enemy");
                    enemylcop.health--;
                    enemylcop.healthlbl.text=[NSString stringWithFormat:@"Boss Health:%d",enemylcop.health];
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
           else{
                enemyBase*enemylcop=(enemyBase*)enemyl;
                if(CGRectIntersectsRect(CGRectInset(enemylcop.frame,5,0), currbullet.frame) && !enemylcop.dead){
                    //NSLog(@"hit an enemy");
                    [enemylcop hitByBulletWithArrayToRemoveFrom:self.enemies withHit:self.player.currentBulletDamage];
                    [currbullet removeAllActions];
                    [currbullet removeFromParent];
                    [self.bullets removeObject:currbullet];
                    break; //if bullet hits enemy stop checking for same bullet
                }
            }
      }
    }//for currbullet
    
    
    
}

-(instancetype)initNearBossWithSize:(CGSize)size{//initial workaround for now but it is functional until i can devise a good inheritance scheme or other minimized solution..
    if (self = [super initWithSize:size]) {
        NSLog(@"in near boss with size\n");
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
        self.player = [[Player alloc] initWithImageNamed:@"samus_standf.png"];
        self.player.position = CGPointMake(3700,150);
        //self.player.position=CGPointMake(3980-60,100);
        self.player.zPosition = 15;
        self.hasHadBossInterac=YES;
        
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
        honeypot *enemy4=[[honeypot alloc] init];
        enemy4.position=CGPointMake(367*self.map.tileSize.width,18*self.map.tileSize.height-3);
        [self.enemies addObject:enemy4];
        [self.map addChild:enemy4];
       
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
                    [weakself.walls setTileGid:3007 at:CGPointMake(plyrtilecoordx-2,28)];
                if(plyrtilecoordx+2<297)
                    [weakself.walls setTileGid:3007 at:CGPointMake(plyrtilecoordx+2,28)];
            }
        }];
        
        __weak arachnusboss*weakboss1=boss1;
        
        SKAction* removebosswall=[SKAction runBlock:^{
            [weakboss1.healthlbl removeFromParent];
            for(int i=23;i<28;i++){
                [weakself.walls removeTileAtCoord:CGPointMake(263,i)];
                [weakself.background removeTileAtCoord:CGPointMake(262,i)];
            }}];
        
        handlebridge=[SKAction sequence:@[[SKAction waitForDuration:8.5],removebosswall,[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.1],bridgeblk]]]]];
        
        SKEmitterNode*bossFire=[SKEmitterNode nodeWithFileNamed:@"arachnusintroduction.sks"];
        bossFire.zPosition=16;
        bossFire.position=CGPointMake(249*self.map.tileSize.width,2*self.map.tileSize.height);
        
        __block BOOL bossdidenter=NO;
        __block BOOL timerrepeat=NO;
        SKAction *bossEntrance=[SKAction sequence:@[[SKAction waitForDuration:3.0],[SKAction runBlock:^{
            weakboss1.zPosition=0.0;
            weakboss1.healthlbl.position=CGPointMake((-3.65*(weakself.size.width/10)), weakself.size.height/2-40);
            [weakself.camera addChild:weakboss1.healthlbl];
            for(int i=247;i<=250;i++){
                for(int k=25;k<=27;k++){
                    [weakself.walls removeTileAtCoord:CGPointMake(i,k)];
                }
            }
            [bossFire removeFromParent];
            weakboss1.zPosition=0.0;
            [weakself.enemies addObject:weakboss1];
            weakboss1.active=YES;
            [weakself removeActionForKey:@"idlecheck"];
        }]]];
        
        SKAction*idleblk=[SKAction runBlock:^{
            //NSLog(@"checking boss idle");
            if(weakself.player.meleeinaction && CGRectIntersectsRect([weakself.player meleeBoundingBoxNormalized],weakboss1.frame) && !bossdidenter){
                [weakself removeActionForKey:@"backuptimer"];
                weakself.hasHadBossInterac=YES;
                bossdidenter=YES;
                [weakself addChild:bossFire];
                [weakself runAction:bossEntrance];
            }
            else if(weakself.player.position.x>weakboss1.position.x-100 && !bossdidenter && !timerrepeat){
                weakself.hasHadBossInterac=YES;
                timerrepeat=YES;
                [weakself runAction:[SKAction sequence:@[[SKAction waitForDuration:13.0],[SKAction runBlock:^{
                    bossdidenter=YES;
                    [weakself addChild:bossFire];
                    [weakself runAction:bossEntrance];
                }]]] withKey:@"backuptimer"];
            }
        }];
        idlecheck=[SKAction sequence:@[[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:1],idleblk]]]]];
        [self runAction:idlecheck withKey:@"idlecheck"];
    }
    return self;
}

/*- (void)dealloc {
    NSLog(@"LVL2 SCENE DEALLOCATED");
}*/

@end
