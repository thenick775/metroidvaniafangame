//
//  GameLevelScene2.m
//  Metroidvania
//
//  Created by nick vancise on 6/10/18.

#import "GameLevelScene2.h"
#import "sciserenemy.h"
#import "arachnusboss.h"
#import "SKTUtils.h"
#import "PlayerProjectile.h"

@implementation GameLevelScene2{
    arachnusboss*boss1;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //self.view.multipleTouchEnabled=YES;
        //self.view.ignoresSiblingOrder=YES; //for performance optimization every time this class is instanciated
        [self.map removeFromParent]; //gets rid of super's implementation of my map
        self.backgroundColor = [SKColor blackColor];
        self.map = [JSTileMap mapNamed:@"level2.tmx"];
        [self addChild:self.map];
        
        self.walls=[self.map layerNamed:@"walls"];
        self.hazards=[self.map layerNamed:@"hazards"];
        self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
        
        //player initializiation stuff
        self.player = [[Player alloc] initWithImageNamed:@"samus_fusion_walking3_v1.png"];
        self.player.position = CGPointMake(100, 150);
        self.player.zPosition = 15;
        
        SKConstraint*plyrconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:0 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-33] Y:[SKRange rangeWithUpperLimit:(self.map.tileSize.height*self.map.mapSize.height)-22]];
        plyrconst.referenceNode=self.parent;
        self.player.constraints=[NSArray arrayWithObjects:plyrconst, nil];
        
        [self.map addChild:self.player];
        
        self.player.forwardtrack=YES;
        self.player.backwardtrack=NO;
        
        //camera initialization
        SKRange *xrange=[SKRange rangeWithLowerLimit:self.size.width/2 upperLimit:(self.map.mapSize.width*self.map.tileSize.width)-self.size.width/2];
        SKRange *yrange=[SKRange rangeWithLowerLimit:self.size.height/2 upperLimit:(self.map.mapSize.height*self.map.tileSize.height)-self.size.height/2];
        SKConstraint*edgeconstraint=[SKConstraint positionX:xrange Y:yrange];
        
        self.camera.constraints=[NSArray arrayWithObjects:[SKConstraint distance:[SKRange rangeWithConstantValue:0.0] toNode:self.player],edgeconstraint, nil];
        
        //star parallax initialization here
        SKEmitterNode *starbackground=[SKEmitterNode nodeWithFileNamed:@"starsbackground.sks"];
        starbackground.position=CGPointMake(2400,(self.map.mapSize.height*self.map.tileSize.height));
        [starbackground advanceSimulationTime:180.0];
        [self.map addChild: starbackground];
        
        //mutable arrays here
        self.bullets=nil;
        self.enemies=nil;
        self.bullets=[[NSMutableArray alloc]init];
        self.enemies=[[NSMutableArray alloc]init];
        
        //enemies here
        sciserenemy *enemy=[[sciserenemy alloc] initWithPos:CGPointMake(self.player.position.x+100, self.player.position.y-108)];
        [self.enemies addObject:enemy];
        [self.map addChild:enemy];
        
        boss1=[[arachnusboss alloc] initWithImageNamed:@"wait_1.png"];
        boss1.position=CGPointMake(3980,56);
        //[boss1 runAction:[SKAction repeatActionForever:boss1.testallactions]];
        [self.map addChild:boss1];
        
    }
    return self;
}

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [self.view presentScene:[[GameLevelScene2 alloc] initWithSize:self.size]];
}


/*- (void)dealloc {
    NSLog(@"LVL2 SCENE DEALLOCATED");
}*/

-(void)handleBulletEnemyCollisions{ //switch this to ise id in fast enumeration so as to keep 1 enemy arr with multiple enemy types
    
    [boss1 handleanimswithfocuspos:self.player.position.x];   //evaluate boss actions/attacks
    
    for(sciserenemy*enemycon in [self.enemies reverseObjectEnumerator]){
        if(fabs(self.player.position.x-enemycon.position.x)<70){  //minimize comparisons
            //NSLog(@"in here");
            if(CGRectContainsPoint(self.player.collisionBoundingBox, CGPointAdd(enemycon.enemybullet1.position, enemycon.position))){
                //NSLog(@"enemy hit player bullet#1");
                [enemycon.enemybullet1 setHidden:YES];
                if(!self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg];
                }
            }
            else if(CGRectContainsPoint(self.player.collisionBoundingBox,CGPointAdd(enemycon.enemybullet2.position, enemycon.position))){
                //NSLog(@"enemy hit player buller#2");
                [enemycon.enemybullet2 setHidden:YES];
                if(!self.player.plyrrecievingdmg){
                    self.player.plyrrecievingdmg=YES;
                    [self enemyhitplayerdmgmsg];
                }
            }
            if(self.player.meleeinaction && !self.player.meleedelay && CGRectIntersectsRect(CGRectMake(self.player.meleeweapon.frame.origin.x+self.player.frame.origin.x, self.player.meleeweapon.frame.origin.y+self.player.frame.origin.y, self.player.meleeweapon.frame.size.width, self.player.meleeweapon.frame.size.height),enemycon.frame)){
                NSLog(@"meleehit");
                enemycon.health=enemycon.health-10;
                self.player.meleedelay=YES; //this variable locks melee to 1 hit every 1.2 sec, might need a weakself
                [self runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.2],[SKAction runBlock:^{self.player.meleedelay=NO;}], nil]]];
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
    }//for currbullet
    
    
    
}




@end
