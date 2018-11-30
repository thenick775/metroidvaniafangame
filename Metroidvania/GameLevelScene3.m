//
//  GameLevelScene3.m
//  Metroidvania
//
//  Created by nick vancise on 10/29/18.
//
#import "GameLevelScene3.h"

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
        
        //scene items here
        SKSpriteNode*powerupstatue=[SKSpriteNode spriteNodeWithTexture:[_lvl3assets textureNamed:@"powerupstatuelvl3.png"]];
        powerupstatue.position=CGPointMake(17*self.map.tileSize.width, 5*self.map.tileSize.height);
        [powerupstatue setScale:0.7];
        powerupstatue.zPosition=0;
        [self.map addChild:powerupstatue];
        
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    //setup sound
    self.audiomanager=[gameaudio alloc];
    //[self.audiomanager runBkgrndMusicForlvl:2];
    
    __weak GameLevelScene3*weakself=self;
    dispatch_async(dispatch_get_main_queue(), ^{//deal with certain ui on main thread only
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

/*- (void)dealloc {
    NSLog(@"LVL3 SCENE DEALLOCATED");
}*/

@end
