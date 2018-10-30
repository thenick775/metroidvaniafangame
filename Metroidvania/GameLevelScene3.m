//
//  GameLevelScene3.m
//  Metroidvania
//
//  Created by nick vancise on 10/29/18.
//
#import "GameLevelScene3.h"

@implementation GameLevelScene3

-(instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        [self.map removeFromParent];
        self.map=nil;
        
        self.backgroundColor = [SKColor blackColor];
        self.map = [JSTileMap mapNamed:@"level3.tmx"];
        [self addChild:self.map];
    
        self.walls=[self.map layerNamed:@"walls"];
        self.hazards=[self.map layerNamed:@"hazards"];
        self.mysteryboxes=[self.map layerNamed:@"mysteryboxes"];
        self.background=[self.map layerNamed:@"background"];
    
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
        
        //mutable arrays here
        [self.bullets removeAllObjects];
        [self.enemies removeAllObjects];
        self.bullets=[[NSMutableArray alloc]init];
        self.enemies=[[NSMutableArray alloc]init];
        
        
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    //setup sound
    self.audiomanager=[gameaudio alloc];
    //[self.audiomanager runBkgrndMusicForlvl:2];
}

-(void)replaybuttonpush:(id)sender{
    [[self.view viewWithTag:666] removeFromSuperview];
    [self.view presentScene:[[GameLevelScene3 alloc] initWithSize:self.size]];
    [gameaudio pauseSound:self.audiomanager.bkgrndmusic];
}

@end
