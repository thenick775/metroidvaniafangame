//
//  MenuScene.m
//  Metriodvania
//
//  Created by nick vancise on 6/20/18.


#import "MenuScene.h"
#import "GameLevelScene.h"
#import "GameLevelScene2.h"

@implementation MenuScene{
    SKSpriteNode *_playlabel;
    SKSpriteNode *_playbutton;
    SKAction *shipflyact;
    SKSpriteNode *samusgunship;
    SKSpriteNode *shipflames1;
    SKSpriteNode *shipflamesright2;
    SKSpriteNode *shipflamesleft2;
    SKAction *shipreducesize;
    SKAction *flameflicker;
    UIBezierPath *shippath;
}

-(instancetype)initWithSize:(CGSize)size {
    if(self=[super initWithSize:size]){
       
        SKTextureAtlas *backgroundtexatl=[SKTextureAtlas atlasNamed:@"menusceneitems"];
        SKTexture *backgroundtex=[backgroundtexatl textureNamed:@"parallax-space-backgound.png"];
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithTexture:backgroundtex size:self.size];
        background.anchorPoint=CGPointMake(0,0);
        background.position=CGPointMake(0,0);
        background.zPosition=0;
        [self addChild:background];
        
        SKSpriteNode *stars1=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-stars.png"] size:self.size];
        stars1.anchorPoint=CGPointMake(0,0);
        stars1.position=CGPointMake(0,0);
        stars1.zPosition=1;
        [self addChild:stars1];
        
        SKAction *starsactinc=[SKAction fadeAlphaTo:0 duration:5.0];
        SKAction *starsactdec=[SKAction fadeAlphaTo:1 duration:5.0];
        NSArray *starsactarr=@[starsactinc,starsactdec];
        SKAction *starsactseq=[SKAction sequence:starsactarr];
        [stars1 runAction:[SKAction repeatActionForever:starsactseq]];
        
        NSArray *pixstarsarr=@[[backgroundtexatl textureNamed:@"star1.png"],[backgroundtexatl textureNamed:@"star2.png"],[backgroundtexatl textureNamed:@"star3.png"],[backgroundtexatl textureNamed:@"star4.png"],[backgroundtexatl textureNamed:@"star5.png"]];
        SKAction *stariterate=[SKAction animateWithTextures:pixstarsarr timePerFrame:0.2];
        SKSpriteNode *pixelstar=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"stars1.png"]];
        pixelstar.zPosition=2;
        pixelstar.size=CGSizeMake(9,9);
        pixelstar.position=CGPointMake(50,50);
        [self addChild:pixelstar];
        [pixelstar runAction:[SKAction repeatActionForever:stariterate]];
        
        SKSpriteNode *pixelstar2=pixelstar.copy;
        pixelstar2.position=CGPointMake(170,125);
        [self addChild:pixelstar2];
        SKSpriteNode *pixelstar3=pixelstar.copy;
        pixelstar3.position=CGPointMake(500,143);
        [self addChild:pixelstar3];
        SKSpriteNode *pixelstar4=pixelstar.copy;
        pixelstar4.position=CGPointMake(250,300);
        [self addChild:pixelstar4];
        SKSpriteNode *pixelstar5=pixelstar.copy;
        pixelstar5.position=CGPointMake(360,88);
        [self addChild:pixelstar5];
        SKSpriteNode *pixelstar6=pixelstar.copy;
        pixelstar6.position=CGPointMake(76,147);
        [self addChild:pixelstar6];
        SKSpriteNode *pixelstar7=pixelstar.copy;
        pixelstar7.position=CGPointMake(445,258);
        [self addChild:pixelstar7];
        
        SKSpriteNode *bigplanet=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-big-planet.png"] size:CGSizeMake(100,99)];
        bigplanet.position=CGPointMake(self.size.width/2+60,self.size.height/2+30);
        bigplanet.zPosition=2;
        [self addChild:bigplanet];
        
        SKSpriteNode *ringplanet=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-ring-planet.png"] size:CGSizeMake(51,115)];
        ringplanet.position=CGPointMake(self.size.width/4,self.size.height/2-48);
        ringplanet.zPosition=2;
        [self addChild:ringplanet];
        
        SKSpriteNode *farplanets=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-far-planets.png"] size:CGSizeMake(272,160)];
        farplanets.position=CGPointMake(self.size.width/2+80,self.size.height/2+10);
        farplanets.zPosition=3;
        [self addChild:farplanets];
        
        SKSpriteNode *titlelabel=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"titlelabelv2.png"] size:CGSizeMake(453,24)];
        titlelabel.position=CGPointMake(self.size.width/2,self.size.height/2+25);
        titlelabel.zPosition=4;
        [self addChild:titlelabel];
        
        
        SKSpriteNode *referencepoint=[[SKSpriteNode alloc] init];
        referencepoint.position=bigplanet.position;
        SKSpriteNode *alienship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"shipv2.png"]];
        alienship.size=CGSizeMake(28,17);
        alienship.position=CGPointMake(45,50);
        SKAction *thrustrepeat=[SKAction repeatAction:[SKAction animateWithTextures:[NSArray arrayWithObjects:[backgroundtexatl textureNamed:@"shipv2_2.png"],[backgroundtexatl textureNamed:@"shipv2_3.png"], nil] timePerFrame:0.03] count:38];
        SKAction *waitthrustersact=[SKAction waitForDuration:11.0];
        SKAction *beginningtex=[SKAction setTexture:[backgroundtexatl textureNamed:@"shipv2.png"]];
        SKAction *thrustact=[SKAction sequence:[NSArray arrayWithObjects:thrustrepeat,beginningtex,waitthrustersact,nil]];
        alienship.zPosition=2;
        alienship.zRotation=-0.77;
        [self addChild:referencepoint];
        [referencepoint addChild:alienship];
        [referencepoint runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:2*M_PI duration:260]]];
        [alienship runAction:[SKAction repeatActionForever:thrustact]];
        
        
        _playlabel=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"playlabel.png"] size:CGSizeMake(120,30)];
        _playlabel.position=CGPointMake(self.size.width/2+110,self.size.height/2-110);
        _playlabel.zPosition=4;
        [self addChild:_playlabel];
        
        _playbutton=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"buttonplay.png"] size:CGSizeMake(64,64)];
        _playbutton.position=CGPointMake(self.size.width/2+200,self.size.height/2-110);
        _playbutton.zPosition=4;
        [self addChild:_playbutton];
        
        //ship fly to planet
        samusgunship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"samusgunship.png"]];
        shipflames1=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflames1.png"]];
        shipflamesright2=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesright2.png"]];
        shipflamesleft2=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesleft2.png"]];
        
        
        shipreducesize=[SKAction scaleTo:0 duration:1.9];
        flameflicker=[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:0 duration:0.08],[SKAction fadeAlphaTo:1 duration:0.08], nil]]];
        
        shippath=[UIBezierPath bezierPath];
        [shippath moveToPoint:samusgunship.position];
        [shippath addQuadCurveToPoint:CGPointMake(self.size.width/2+23, self.size.height/2+75) controlPoint:CGPointMake(self.size.width/2-190, self.size.height/2+90)];
        
        
        samusgunship.position=CGPointMake(-15,-15);
        shipflamesright2.position=CGPointMake(25,-8);
        shipflamesleft2.position=CGPointMake(-25,-8);
        [samusgunship addChild:shipflames1];
        [samusgunship addChild:shipflamesright2];
        [samusgunship addChild:shipflamesleft2];
        [self addChild:samusgunship];
       
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch*touch in touches){
        if((CGRectContainsPoint(_playlabel.frame,[touch locationInNode:self])) || (CGRectContainsPoint(_playbutton.frame,[touch locationInNode:self]))){
            
            SKScene * scene = [[GameLevelScene2 alloc]initWithSize:CGSizeMake(self.view.bounds.size.width/1.2,self.view.bounds.size.height/1.2-10)];//[GameLevelScene sceneWithSize:CGSizeMake(self.view.bounds.size.width/1.2,self.view.bounds.size.height/1.2-10)];  //was skView.bounds.size
            SKTransition *menutolvl1tran=[SKTransition fadeWithDuration:1.5];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            NSArray *shipgrp=@[shipreducesize,[SKAction followPath:shippath.CGPath duration:1.8]];
            [shipflamesright2 runAction:flameflicker];
            [shipflamesleft2 runAction:flameflicker];
            [samusgunship runAction:[SKAction group:shipgrp] completion:^{ [self.view presentScene:scene transition:menutolvl1tran];}];
        }
    }
}

/*- (void)dealloc {
 NSLog(@"MENU SCENE DEALLOCATED");
 }*/

@end
