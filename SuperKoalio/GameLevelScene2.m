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
        boss1.position=CGPointMake(100,150);
        //[boss1 runAction:boss1.testallactions];
        [boss1 runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:boss1.testallactions,[SKAction waitForDuration:5.0],[SKAction scaleXTo:-1 duration:0.08],boss1.testallactions,[SKAction waitForDuration:5.0],[SKAction scaleXTo:1 duration:0.08], nil]]]];
        [self.map addChild:boss1];
        
        //door stuff here
        //self.repeating=NO;
        
        //self.userInteractionEnabled=YES;
        
    }
    return self;
}

/*- (void)dealloc {
    NSLog(@"LVL2 SCENE DEALLOCATED");
}*/

@end
