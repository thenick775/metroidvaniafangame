//
//  MenuScene.m
//  Metriodvania
//
//  Created by nick vancise on 6/20/18.


#import "MenuScene.h"
#import "levelBase.h"
#import "GameLevelScene.h"
#import "GameLevelScene2.h"
#import "GameLevelScene3.h"
#import "gameaudio.h"
#import "saveData.h"

@implementation MenuScene{
    saveCellManager *_savebkrnd;
    BOOL viewingcntrls,viewingsslots;
    SKAction *shipflyac,*shipreducesize,*flameflicker;
    SKSpriteNode *samusgunship,*shipflames1,*shipflamesright2,*shipflamesleft2;
    SKSpriteNode *_cntrlbkrnd;
    UIBezierPath *shippath;
    SKTransition *menutolvl1tran;
    NSArray *texturesforlvl;
    SKAction *_buttonhighlight,*_buttonunhighlight;
    gameaudio*audiomanager;
}

-(instancetype)initWithSize:(CGSize)size {
    if(self=[super initWithSize:size]){
        self.userInteractionEnabled=NO;
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
        
         __weak MenuScene *weakself=self;
        UIBezierPath*starbez=[UIBezierPath bezierPath];
        __weak UIBezierPath*weakstarbez=starbez;
        //[starbez moveToPoint:CGPointMake(-20,self.size.height+5)];
        //[starbez addQuadCurveToPoint:CGPointMake(self.size.width-60,-180) controlPoint:CGPointMake(self.size.width/2+90,self.size.height-20)];
        SKEmitterNode*shootingstar=[SKEmitterNode nodeWithFileNamed:@"shootingstar.sks"];
        shootingstar.particleRenderOrder=SKParticleRenderOrderDontCare;
        shootingstar.targetNode=self;
        SKAction*shootstarblk=[SKAction runBlock:^{
            int rand=-90 + arc4random_uniform(330);
            [weakstarbez moveToPoint:CGPointMake(-20-abs((int)(rand*0.75)),weakself.size.height+5)];
            [weakstarbez addQuadCurveToPoint:CGPointMake(weakself.size.width-60+rand,-180) controlPoint:CGPointMake(weakself.size.width/2+90+rand,weakself.size.height-20)];
            [shootingstar setPaused:NO];
            [shootingstar resetSimulation];
            [weakself addChild:shootingstar];
            [shootingstar runAction:[SKAction followPath:starbez.CGPath asOffset:NO orientToPath:NO duration:1.8] completion:^{[shootingstar setPaused:YES];[shootingstar removeFromParent];}];
        }];
        SKAction*shootingstarac=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:2],shootstarblk,[SKAction waitForDuration:8.0]]]];
        [self runAction:shootingstarac];
        
        
        SKSpriteNode *bigplanet=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-big-planet.png"] size:CGSizeMake(100,99)];
        bigplanet.position=CGPointMake(self.size.width/2+60,self.size.height/2+30);
        bigplanet.zPosition=2;
        [self addChild:bigplanet];
        
        SKSpriteNode *ringplanet=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-ring-planet.png"] size:CGSizeMake(51,115)];
        ringplanet.position=CGPointMake(self.size.width/4,self.size.height/2-48);
        ringplanet.zPosition=3;
        [self addChild:ringplanet];
        
        SKSpriteNode *farplanets=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-far-planets.png"] size:CGSizeMake(272,160)];
        farplanets.position=CGPointMake(self.size.width/2+80,self.size.height/2+10);
        farplanets.zPosition=3;
        [self addChild:farplanets];
        
        self.titlelabel=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"titlelabelv2.png"] size:CGSizeMake(453,24)];
        self.titlelabel.position=CGPointMake(self.size.width/2,self.size.height/2+25);
        self.titlelabel.zPosition=4;
        self.titlelabel.alpha=0;
        [self addChild:self.titlelabel];
        
        
        SKSpriteNode *referencepoint1=[[SKSpriteNode alloc] init];
        referencepoint1.position=bigplanet.position;
        SKSpriteNode *alienship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"shipv2.png"]];
        alienship.size=CGSizeMake(28,17);
        alienship.position=CGPointMake(45,50);
        SKAction *thrustrepeat=[SKAction repeatAction:[SKAction animateWithTextures:@[[backgroundtexatl textureNamed:@"shipv2_2.png"],[backgroundtexatl textureNamed:@"shipv2_3.png"]] timePerFrame:0.03] count:38];
        SKAction *waitthrustersact=[SKAction waitForDuration:11.0];
        SKAction *beginningtex=[SKAction setTexture:[backgroundtexatl textureNamed:@"shipv2.png"]];
        SKAction *thrustact=[SKAction sequence:@[thrustrepeat,beginningtex,waitthrustersact]];
        alienship.zPosition=2;
        alienship.zRotation=-0.77;
        [self addChild:referencepoint1];
        [referencepoint1 addChild:alienship];
        [referencepoint1 runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:2*M_PI duration:210]]];
        [alienship runAction:[SKAction repeatActionForever:thrustact]];
        
        SKSpriteNode *humanship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"humanship.png"]];
        [humanship setScale:0.2];
        humanship.zPosition=2;
        UIBezierPath *ovalpath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(ringplanet.frame.origin.x+15, ringplanet.frame.origin.y-5, ringplanet.frame.size.width-9, ringplanet.frame.size.height)];
        [humanship runAction:[SKAction repeatActionForever:[SKAction followPath:ovalpath.CGPath asOffset:NO orientToPath:NO speed:1.0]]];
        [self addChild:humanship];
        
        self._playlabel=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"playlabel.png"] size:CGSizeMake(120,30)];
        self._playlabel.position=CGPointMake(self.size.width/2+110,self.size.height/2-110);
        self._playlabel.zPosition=4;
        self._playlabel.alpha=0;
        [self addChild:self._playlabel];
        
        self._playbutton=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"buttonplay.png"] size:CGSizeMake(64,64)];
        self._playbutton.position=CGPointMake(self.size.width/2+200,self.size.height/2-110);
        self._playbutton.zPosition=4;
        self._playbutton.alpha=0;
        [self addChild:self._playbutton];
        
        self._cntrllabel=[SKSpriteNode spriteNodeWithImageNamed:@"controllabel.png"];
        self._cntrllabel.position=CGPointMake(self.size.width/2-130,self.size.height/2-110);
        self._cntrllabel.zPosition=4;
        self._cntrllabel.alpha=0;
        [self addChild:self._cntrllabel];
        
        _cntrlbkrnd=[SKSpriteNode spriteNodeWithColor:[SKColor darkGrayColor] size:CGSizeMake(self.size.width*0.722639,95)];
        _cntrlbkrnd.alpha=0;
        _cntrlbkrnd.position=CGPointMake(self.size.width/2,self.size.height/2);
        _cntrlbkrnd.zPosition=5;
        [self addChild:_cntrlbkrnd];
        
        SKLabelNode *cntrll1=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        SKLabelNode *cntrll2=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        SKLabelNode *cntrll3=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        cntrll1.zPosition=6;
        cntrll1.fontSize=16;
        cntrll1.text=@"Use the joystick to move around by sliding your finger,";
        cntrll1.position=CGPointMake(0,20);
        cntrll2.zPosition=6;
        cntrll2.fontSize=16;
        cntrll2.text=@"Tap the upper right half of the screen to melee,";
        cntrll2.position=CGPointMake(0,-5);
        cntrll3.zPosition=6;
        cntrll3.fontSize=16;
        cntrll3.text=@"Tap the lower right half of the screen to fire your weapon";
        cntrll3.position=CGPointMake(0,-30);
        
        [_cntrlbkrnd addChild:cntrll1];
        [_cntrlbkrnd addChild:cntrll2];
        [_cntrlbkrnd addChild:cntrll3];
        
        //ship fly to planet
        samusgunship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"samusgunship.png"]];
        shipflames1=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflames1.png"]];
        shipflamesright2=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesright2.png"]];
        shipflamesleft2=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesleft2.png"]];
        SKSpriteNode *shipflamesrightinner=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesright2.png"]];
        SKSpriteNode *shipflamesleftinner=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesleft2.png"]];
        
        
        shipreducesize=[SKAction scaleTo:0 duration:1.8];
        flameflicker=[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.08],[SKAction fadeAlphaTo:1 duration:0.08]]]];
        
        shippath=[UIBezierPath bezierPath];
        [shippath moveToPoint:samusgunship.position];
        [shippath addQuadCurveToPoint:CGPointMake(self.size.width/2+23, self.size.height/2+75) controlPoint:CGPointMake(self.size.width/2-190, self.size.height/2+90)];
        
        
        samusgunship.position=CGPointMake(-15,-15);
        shipflamesrightinner.position=CGPointMake(25,-8);
        shipflamesleftinner.position=CGPointMake(-25,-8);
        shipflamesright2.position=CGPointMake(33,-12);
        shipflamesleft2.position=CGPointMake(-33,-12);
        [samusgunship addChild:shipflames1];
        [samusgunship addChild:shipflamesrightinner];
        [samusgunship addChild:shipflamesleftinner];
        [samusgunship addChild:shipflamesright2];
        [samusgunship addChild:shipflamesleft2];
        [self addChild:samusgunship];
        
        menutolvl1tran=[SKTransition fadeWithDuration:1.5];
        menutolvl1tran.pausesOutgoingScene=NO;
        
        shipflyac=[SKAction group:@[shipreducesize,[SKAction followPath:shippath.CGPath duration:1.7]]];
        [shipflyac setTimingMode:SKActionTimingEaseIn];
    texturesforlvl=@[@[@"Samusregsuit",@"projectiles",@"Sciser",@"travelmirror",@"Waver"],@[@"Samusregsuit",@"projectiles",@"Sciser",@"travelmirror",@"honeypot",@"Arachnus",@"Waver"],@[@"Samusregsuit",@"projectiles",@"Sciser",@"travelmirror",@"honeypot",@"Nettori",@"Waver"]];
        
        self.labelsin=[SKAction sequence:@[[SKAction waitForDuration:1.5],[SKAction fadeInWithDuration:1.5]]];
        [self runAction:[SKAction runBlock:^{[weakself.titlelabel runAction:weakself.labelsin completion:^{weakself.labelsin.speed=3;[weakself._playlabel runAction:weakself.labelsin];[weakself._playbutton runAction:weakself.labelsin];[weakself._cntrllabel runAction:weakself.labelsin completion:^{weakself.userInteractionEnabled=YES;}];}];}]];
      
        _buttonhighlight=[SKAction colorizeWithColor:[SKColor darkGrayColor] colorBlendFactor:0.8 duration:0.05];
        _buttonunhighlight=[SKAction colorizeWithColorBlendFactor:0.0 duration:0.05];
        
        //add loadgame stuff here
        [saveData unarch];
        
        _savebkrnd=[[saveCellManager alloc] initWithRect:CGRectMake((self.size.width/2)-((self.size.width-300)/2),(self.size.height/2)-((self.size.height*0.55)/2), self.size.width-300, self.size.height*0.55) andRad:12];
        [self addChild:_savebkrnd];
        
        audiomanager=[gameaudio alloc];
        [audiomanager runBkgrndMusicForlvl:0 andVol:[saveData getvolume]];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch*touch in touches){
        
        __weak MenuScene*weakself=self;
        if(CGRectContainsPoint(self._cntrllabel.frame,[touch locationInNode:self]) && !viewingcntrls && !viewingsslots){
            [_cntrlbkrnd runAction:[SKAction fadeInWithDuration:0.2]];
            [weakself._cntrllabel runAction:_buttonhighlight];
            viewingcntrls=YES;
        }
        else if(viewingcntrls){
            [_cntrlbkrnd runAction:[SKAction fadeOutWithDuration:0.2]];
            [self._cntrllabel runAction:_buttonunhighlight];
            viewingcntrls=NO;
        }
        else if(viewingsslots && !CGRectContainsPoint(_savebkrnd.frame,[touch locationInNode:self])){
            [_savebkrnd runAction:[SKAction fadeOutWithDuration:0.2]];
            for(saveCell*cell in _savebkrnd.cells){
                if(cell.selected)
                    [cell showLabels];
            }
            [self._playlabel runAction:_buttonunhighlight];
            [self._playbutton runAction:_buttonunhighlight];
            viewingsslots=NO;
        }
        else if((CGRectContainsPoint(self._playlabel.frame,[touch locationInNode:self]) || CGRectContainsPoint(self._playbutton.frame,[touch locationInNode:self])) && !viewingsslots){
            [_savebkrnd runAction:[SKAction fadeInWithDuration:0.25]];
            [self._playlabel runAction:_buttonhighlight];
            [self._playbutton runAction:_buttonhighlight];
            viewingsslots=YES;
        }
        else if(viewingsslots && CGRectContainsPoint(_savebkrnd.frame,[touch locationInNode:self])){
            int p=[_savebkrnd cgpointinslot:[touch locationInNode:_savebkrnd]];
            for(saveCell*cell in _savebkrnd.cells){
                if(p==-1){
                    for(saveCell*cell in _savebkrnd.cells){
                        if(cell.selected)
                            [cell showLabels];
                    }
                    break;
                }
                else if(cell.selected && [touch locationInNode:cell].x<=0 && p==cell.cellno){
                    //NSLog(@"cell %d less than 0",p);
                    [self runlevelforslot:p];
                }
                else if(cell.selected && [touch locationInNode:cell].x>0 && p==cell.cellno){
                    //NSLog(@"cell %d greater than 0",p);
                    [saveData reset_slot:p];
                    ((saveCell*)_savebkrnd.cells[p]).center.text=[@"lvl: " stringByAppendingString:[[saveData getlvlfromslot:p] stringValue]];
                    [saveData arch];
                    [cell showLabels];
                }
                else if(!cell.selected && p==cell.cellno){
                    [cell fadeLabels];
                }
            }
        }
    }
}

-(levelBase*)setupscenefromslot:(int)slot{
    levelBase*temp;
    int lvl=[[saveData getlvlfromslot:slot] intValue];
    
    switch (lvl) {
        case 0:
            temp=[GameLevelScene alloc];
            [saveData editprogwithval:@"in progress" forsaveslot:slot];
            break;
        case 1:
            temp=[GameLevelScene alloc];
            break;
        case 2:
            temp=[GameLevelScene2 alloc];
            break;
        case 3:
            temp=[GameLevelScene3 alloc];
            break;
            
        default:
            break;
    }
    return temp;
}

-(void)runlevelforslot:(int)p{
    CGSize nextSceneSize=CGSizeMake(self.view.bounds.size.width/1.5,self.view.bounds.size.height/1.5-10);
    [saveData editcurrslot:p];
    __block levelBase*preload;
    __weak MenuScene *weakself = self;
    __weak SKTransition*weakmenutolvl1tran=menutolvl1tran;
    __weak SKSpriteNode*weakshipflamesright2=shipflamesright2;
    __weak SKSpriteNode*weakshipflamesleft2=shipflamesleft2;
    __weak SKAction *weakflameflicker=flameflicker;
    __weak SKSpriteNode *weaksamusgunship=samusgunship;
    __weak SKAction *weakshipflyac=shipflyac;
    __weak NSArray *weaktexturesforlvl=texturesforlvl[p];
    __weak saveCellManager *weaksavebkrnd=_savebkrnd;
    
    preload=[saveData getseenbossfromslot:p] ? [[self setupscenefromslot:p] initNearBossWithSize:nextSceneSize andVol:[saveData getvolume]] : [[self setupscenefromslot:p] initWithSize:nextSceneSize andVol:[saveData getvolume]];
    
    preload.scaleMode = SKSceneScaleModeAspectFill;
    self.userInteractionEnabled=NO;
    
    [SKTextureAtlas preloadTextureAtlasesNamed:weaktexturesforlvl withCompletionHandler:^(NSError*error,NSArray*foundatlases){
        NSLog(@"preloaded lvl");
        [weaksavebkrnd runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.3],[SKAction waitForDuration:1.0]]] completion:^{
            [weakshipflamesright2 runAction:weakflameflicker];
            [weakshipflamesleft2 runAction:weakflameflicker];
            [weaksamusgunship runAction:weakshipflyac completion:^{ [weakself.view presentScene:preload transition:weakmenutolvl1tran];}];
        }];
    }];
}

/*- (void)dealloc {
 NSLog(@"MENU SCENE DEALLOCATED");
 }*/

@end
