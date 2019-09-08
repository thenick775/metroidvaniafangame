//
//  enemyBase.m
//  Metroidvania
//
//  Created by nick vancise on 12/21/18.
//
#import "enemyBase.h"

@implementation enemyBase


-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray*)arr withHit:(int)hit{//default implementation
    self.health=self.health-hit;
    if(self.health<=0){
        //NSLog(@"healthisbelowzero");
        [self removeAllActions];
        [self removeAllChildren];
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
        //NSLog(@"%d",(int)arr.count);
    }
    
}

-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray*)arr{
    self.health=self.health-10;
    if(self.health<=0){
        [self removeAllActions];
        [self removeAllChildren];
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
    }
}

-(void)enemytoplayerandmelee:(GameLevelScene *)scene{}
@end
