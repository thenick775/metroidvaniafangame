//
//  GameLevelScene2.m
//  Metroidvania
//
//  Created by nick vancise on 6/10/18.

#include "GameLevelScene2.h"
#include "sciserenemy.h"
#include "arachnusboss.h"

@implementation GameLevelScene2

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
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
        
        arachnusboss *boss1=[[arachnusboss alloc] initWithImageNamed:@"wait_1.png"];
        boss1.position=CGPointMake(3888,56);
        [boss1 runAction:[SKAction repeatActionForever:boss1.testallactions]];
        [self.map addChild:boss1];
        
    }
    return self;
}

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [self.view presentScene:[[GameLevelScene2 alloc] initWithSize:self.size]];
}


- (void)dealloc {
    NSLog(@"LVL2 SCENE DEALLOCATED");
}

@end
