//
//  joystick.m
//  Metroidvania
//
//  Created by nick vancise on 1/17/19.
//

#import "joystick.h"

@implementation joystick{
    SKShapeNode*_fingertracker;
}

-(instancetype)initWithPos:(CGPoint)pos{
    self=[joystick shapeNodeWithCircleOfRadius:35];
    if(self!=nil){
        //NSLog(@"creating joystick");
        self.position=pos;
        self.zPosition=15;
        self.strokeColor=[UIColor whiteColor];
        self.fillColor=[UIColor clearColor];
        _fingertracker=[SKShapeNode shapeNodeWithCircleOfRadius:5.0];
        _fingertracker.zPosition=16;
        _fingertracker.fillColor=[UIColor redColor];
        _fingertracker.constraints=@[[SKConstraint positionX:[SKRange rangeWithValue:0 variance:28] Y:[SKRange rangeWithValue:0 variance:25]]];
        _fingertracker.position=CGPointZero;
        [self addChild:_fingertracker];
        
        
    }
    return self;
}

-(BOOL)shouldGoForeward:(CGPoint)pos{
    CGPoint temp=[self convertPoint:pos fromNode:self.parent];
    if(temp.x>0 && temp.y<12 && pos.x<self.parent.frame.size.width/2){
        return YES;
    }
    else return NO;
}
-(BOOL)shouldGoBackward:(CGPoint)pos{
    CGPoint temp=[self convertPoint:pos fromNode:self.parent];
    if(temp.x<0 && temp.y<12 && pos.x<self.parent.frame.size.width/2){
        return YES;
    }
    else return NO;
}
-(BOOL)shouldJumpForeward:(CGPoint)pos{
    CGPoint temp=[self convertPoint:pos fromNode:self.parent];
    if(temp.x>14 && temp.y>12 && pos.x<self.parent.frame.size.width/2){
        return YES;
    }
    else return NO;
}
-(BOOL)shouldJumpBackward:(CGPoint)pos{
    CGPoint temp=[self convertPoint:pos fromNode:self.parent];
    if(temp.x<-14 && temp.y>12 && pos.x<self.parent.frame.size.width/2){
        return YES;
    }
    else return NO;
}
-(BOOL)shouldJump:(CGPoint)pos{
    CGPoint temp=[self convertPoint:pos fromNode:self.parent];
    if(temp.y>12 && temp.x>-14 && temp.x<14 && pos.x<self.parent.frame.size.width/2){
        return YES;
    }
    else return NO;
}
-(void)moveFingertrackerto:(CGPoint)pos{
    if(pos.x<self.parent.frame.size.width/2){
    SKAction*tmp=[SKAction moveTo:[self convertPoint:pos fromNode:self.parent] duration:0.2];
    [_fingertracker runAction:tmp];
    }
}
-(void)resetFingertracker{
    [_fingertracker removeAllActions];
    [_fingertracker runAction:[SKAction moveTo:CGPointZero duration:0.15]];
}


/*-(void)dealloc{
    NSLog(@"joystick deallocated");
}*/

@end
