//
//  spacepirate.m
//  Metroidvania
//
//  Created by nick vancise on 7/1/20.
//

#import "spacepirate.h"

@implementation spacepirate{
    SKTextureAtlas *_spacepirateatlas;
    NSMutableArray *_projectilesInAction;
    SKAction *_runf,*_jumpf,*_jumpb,*_crawlb,*_turnlr,*_fireregf,*_fireupf,*_firedownf,*_wallfiref,*_wallcrawlbb; //origionals
    SKAction *_wallcrawlbf,*_runb,*_crawlf,*_turnrl,*_wallfireb,*_fireregb,*_fireupb,*_firedownb,*_wallcrawlfb,*_wallcrawlff; //based on existing animations
}

-(instancetype)initWithPosition:(CGPoint)pos onWall:(BOOL)onwall{
    _spacepirateatlas=[SKTextureAtlas atlasNamed:@"spacepirate"];
    self = [super initWithTexture:[_spacepirateatlas textureNamed:@"spacepirate1.png"]];
    if(self!=nil){
        self.health=25;
        self.dx=0;
        self.dy=0;
        self.position=pos;
        self.dead=NO;
        _projectilesInAction=[[NSMutableArray alloc] init];
        
        SKAction *runfbase=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate1.png"],[_spacepirateatlas textureNamed:@"spacepirate2.png"],[_spacepirateatlas textureNamed:@"spacepirate3.png"],[_spacepirateatlas textureNamed:@"spacepirate4.png"],[_spacepirateatlas textureNamed:@"spacepirate5.png"],[_spacepirateatlas textureNamed:@"spacepirate6.png"],[_spacepirateatlas textureNamed:@"spacepirate7.png"],[_spacepirateatlas textureNamed:@"spacepirate8.png"],[_spacepirateatlas textureNamed:@"spacepirate9.png"]] timePerFrame:0.12 resize:YES restore:NO];
        
        _runf=[SKAction group:@[[SKAction moveByX:45 y:0 duration:0.9],runfbase]];
        _runb=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],[SKAction group:@[[SKAction moveByX:-45 y:0 duration:0.9],runfbase]],[SKAction scaleXTo:1 duration:0]]];
        
        SKAction *jumpbase=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate10.png"],[_spacepirateatlas textureNamed:@"spacepirate11.png"],[_spacepirateatlas textureNamed:@"spacepirate12.png"],[_spacepirateatlas textureNamed:@"spacepirate13.png"],[_spacepirateatlas textureNamed:@"spacepirate14.png"],[_spacepirateatlas textureNamed:@"spacepirate15.png"],[_spacepirateatlas textureNamed:@"spacepirate16.png"],[_spacepirateatlas textureNamed:@"spacepirate17.png"],[_spacepirateatlas textureNamed:@"spacepirate18.png"],[_spacepirateatlas textureNamed:@"spacepirate19.png"]] timePerFrame:0.12 resize:YES restore:NO];
        _jumpf=[SKAction group:@[jumpbase]];
        _jumpb=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],jumpbase,[SKAction scaleXTo:1 duration:0]]];
        
        SKAction *crawlbbase=[SKAction group:@[[SKAction sequence:@[[SKAction moveByX:0 y:-15 duration:0.25],[SKAction waitForDuration:1.35],[SKAction moveByX:0 y:15 duration:0.05]]],[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate20.png"],[_spacepirateatlas textureNamed:@"spacepirate21.png"],[_spacepirateatlas textureNamed:@"spacepirate22.png"],[_spacepirateatlas textureNamed:@"spacepirate23.png"],[_spacepirateatlas textureNamed:@"spacepirate24.png"],[_spacepirateatlas textureNamed:@"spacepirate25.png"],[_spacepirateatlas textureNamed:@"spacepirate26.png"],[_spacepirateatlas textureNamed:@"spacepirate27.png"],[_spacepirateatlas textureNamed:@"spacepirate28.png"],[_spacepirateatlas textureNamed:@"spacepirate29.png"],[_spacepirateatlas textureNamed:@"spacepirate30.png"],[_spacepirateatlas textureNamed:@"spacepirate31.png"]] timePerFrame:0.12 resize:YES restore:NO]]];
        
        _crawlb=[SKAction group:@[[SKAction moveByX:-40 y:0 duration:1.25],crawlbbase]];
        _crawlf=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],[SKAction group:@[[SKAction moveByX:40 y:0 duration:1.25],crawlbbase]],[SKAction scaleXTo:1 duration:0]]];
        
        _turnlr=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate32.png"],[_spacepirateatlas textureNamed:@"spacepirate33.png"],[_spacepirateatlas textureNamed:@"spacepirate34.png"],[_spacepirateatlas textureNamed:@"spacepirate35.png"],[_spacepirateatlas textureNamed:@"spacepirate36.png"],[_spacepirateatlas textureNamed:@"spacepirate37.png"],[_spacepirateatlas textureNamed:@"spacepirate38.png"],[_spacepirateatlas textureNamed:@"spacepirate39.png"],[_spacepirateatlas textureNamed:@"spacepirate40.png"],[_spacepirateatlas textureNamed:@"spacepirate41.png"],[_spacepirateatlas textureNamed:@"spacepirate42.png"],[_spacepirateatlas textureNamed:@"spacepirate43.png"]] timePerFrame:0.10 resize:YES restore:NO];
        _turnrl=_turnlr.reversedAction;
        
        __weak spacepirate*weakself=self;
        SKAction *fireregbase=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate44.png"],[_spacepirateatlas textureNamed:@"spacepirate45.png"],[_spacepirateatlas textureNamed:@"spacepirate46.png"],[_spacepirateatlas textureNamed:@"spacepirate47.png"],[_spacepirateatlas textureNamed:@"spacepirate48.png"],[_spacepirateatlas textureNamed:@"spacepirate49.png"],[_spacepirateatlas textureNamed:@"spacepirate50.png"]] timePerFrame:0.13 resize:YES restore:NO];
        _fireregf=[SKAction group:@[fireregbase,[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{[weakself fireProjectile:1];}]]]]];
        _fireregb=[SKAction group:@[[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],fireregbase,[SKAction scaleXTo:1 duration:0]]],[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{[weakself fireProjectile:0];}]]]]];
        
        _fireupf=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate51.png"],[_spacepirateatlas textureNamed:@"spacepirate52.png"],[_spacepirateatlas textureNamed:@"spacepirate53.png"],[_spacepirateatlas textureNamed:@"spacepirate54.png"],[_spacepirateatlas textureNamed:@"spacepirate55.png"],[_spacepirateatlas textureNamed:@"spacepirate56.png"],[_spacepirateatlas textureNamed:@"spacepirate57.png"]] timePerFrame:0.13 resize:YES restore:NO];
        _fireupb=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],_fireupf,[SKAction scaleXTo:1 duration:0]]];
        
        _firedownf=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate58.png"],[_spacepirateatlas textureNamed:@"spacepirate59.png"],[_spacepirateatlas textureNamed:@"spacepirate60.png"],[_spacepirateatlas textureNamed:@"spacepirate61.png"],[_spacepirateatlas textureNamed:@"spacepirate62.png"],[_spacepirateatlas textureNamed:@"spacepirate63.png"],[_spacepirateatlas textureNamed:@"spacepirate64.png"],[_spacepirateatlas textureNamed:@"spacepirate65.png"]] timePerFrame:0.13 resize:YES restore:NO];
        _firedownb=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],_firedownf,[SKAction scaleXTo:1 duration:0]]];
         
        SKAction *wallfirebase=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate66.png"],[_spacepirateatlas textureNamed:@"spacepirate67.png"],[_spacepirateatlas textureNamed:@"spacepirate68.png"],[_spacepirateatlas textureNamed:@"spacepirate69.png"],[_spacepirateatlas textureNamed:@"spacepirate70.png"],[_spacepirateatlas textureNamed:@"spacepirate71.png"],[_spacepirateatlas textureNamed:@"spacepirate72.png"]] timePerFrame:0.13 resize:YES restore:NO];
        _wallfiref=[SKAction group:@[wallfirebase,[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{[weakself fireProjectile:1];}]]]]];
        _wallfireb=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],[SKAction group:@[wallfirebase,[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction runBlock:^{[weakself fireProjectile:0];}]]]]],[SKAction scaleXTo:1 duration:0]]];
         
        SKAction *wallcrawlbbbase=[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate73.png"],[_spacepirateatlas textureNamed:@"spacepirate74.png"],[_spacepirateatlas textureNamed:@"spacepirate75.png"],[_spacepirateatlas textureNamed:@"spacepirate76.png"],[_spacepirateatlas textureNamed:@"spacepirate77.png"],[_spacepirateatlas textureNamed:@"spacepirate78.png"],[_spacepirateatlas textureNamed:@"spacepirate79.png"],[_spacepirateatlas textureNamed:@"spacepirate80.png"],[_spacepirateatlas textureNamed:@"spacepirate81.png"]] timePerFrame:0.12 resize:YES restore:NO];
        
        _wallcrawlbb=[SKAction group:@[[SKAction moveByX:0 y:-45 duration:0.9],wallcrawlbbbase]];
        _wallcrawlbf=[SKAction group:@[[SKAction moveByX:0 y:45 duration:0.9],wallcrawlbbbase.reversedAction]];
        _wallcrawlfb=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],_wallcrawlbb,[SKAction scaleXTo:1 duration:0]]];
        _wallcrawlff=[SKAction sequence:@[[SKAction scaleXTo:-1 duration:0],_wallcrawlbf,[SKAction scaleXTo:1 duration:0]]];
        
        if(onwall){
            
        } else{
            
        }
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[_runf,_runb,_jumpf,_jumpb,_crawlb,_crawlf,_turnlr,_turnrl,_fireregf,_fireregb,_fireupf,_fireupb,_firedownf,_firedownb,_wallfiref,_wallfireb,_wallcrawlbb,_wallcrawlbf,_wallcrawlfb,_wallcrawlff]]]];//test animations
 
    }
    return self;
}

-(void)fireProjectile:(int)direction{
    SKSpriteNode *proj1=[SKSpriteNode spriteNodeWithTexture:[_spacepirateatlas textureNamed:@"spacepirate_proj1"]];
    SKSpriteNode *proj2=[SKSpriteNode spriteNodeWithTexture:[_spacepirateatlas textureNamed:@"spacepirate_proj1"]];
    proj1.position=CGPointMake(direction>0 ? self.position.x+20:self.position.x-20,self.position.y-2);
    proj2.position=CGPointMake(direction>0 ? self.position.x+25:self.position.x-25,self.position.y+10);
    if(!direction){
        proj1.xScale=-1;
        proj2.xScale=-1;
    }
    SKAction *projac=[SKAction group:@[[SKAction moveByX:direction>0 ? 240:-240 y:0 duration:2.2],[SKAction repeatAction:[SKAction animateWithTextures:@[[_spacepirateatlas textureNamed:@"spacepirate_proj1"],[_spacepirateatlas textureNamed:@"spacepirate_proj2"]] timePerFrame:0.1 resize:YES restore:NO] count:10]]];
    
    __weak SKSpriteNode*weakproj1=proj1;
    __weak SKSpriteNode*weakproj2=proj2;
    __weak NSMutableArray *weakprokectilesinaction=_projectilesInAction;
    [self.parent addChild:proj1];
    [self.parent addChild:proj2];
    [_projectilesInAction addObject:proj1];
    [_projectilesInAction addObject:proj2];
    [proj1 runAction:projac completion:^{[weakproj1 removeAllActions];[weakproj1 removeFromParent];[weakprokectilesinaction removeObject:weakproj1];}];
    [proj2 runAction:projac completion:^{[weakproj2 removeAllActions];[weakproj2 removeFromParent];[weakprokectilesinaction removeObject:weakproj2];}];
    
}

-(void)enemytoplayerandmelee:(GameLevelScene *)scene{
    if(CGRectIntersectsRect(scene.player.frame,CGRectInset(self.frame,2,0))){//damage to player from self and projectiles
        [scene enemyhitplayerdmgmsg:25];
    }
    if(scene.player.meleeinaction && !scene.player.meleedelay && CGRectIntersectsRect([scene.player meleeBoundingBoxNormalized],self.frame)){
        [scene.player runAction:scene.player.meleedelayac];
        [self hitByMeleeWithArrayToRemoveFrom:scene.enemies];
    }
    //NSLog(@"proj in action: %lu",(unsigned long)_projectilesInAction.count);
    for(SKSpriteNode*tmp in _projectilesInAction.reverseObjectEnumerator){
        if(CGRectContainsPoint(scene.player.frame,tmp.position)){
            [scene enemyhitplayerdmgmsg:10];
            [tmp removeAllActions];
            [tmp removeFromParent];
            [_projectilesInAction removeObject:tmp];
        }
    }
}

-(void)dealloc{
NSLog(@"spacepirate deallocated");
}

@end
