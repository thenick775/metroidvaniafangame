//
//  enemyBase.m
//  Metroidvania
//
//  Created by nick vancise on 12/21/18.
//
#import "enemyBase.h"

@implementation enemyBase


-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray*)arr{//default implementation
    self.health--;
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

@end
