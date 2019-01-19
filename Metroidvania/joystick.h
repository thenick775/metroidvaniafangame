//
//  joystick.h
//  Metroidvania
//
//  Created by nick vancise on 1/17/19.
//

#import <SpriteKit/SpriteKit.h>

@interface joystick : SKShapeNode

-(instancetype)initWithPos:(CGPoint)pos;
-(BOOL)shouldGoForeward:(CGPoint)pos;
-(BOOL)shouldGoBackward:(CGPoint)pos;
-(BOOL)shouldJumpForeward:(CGPoint)pos;
-(BOOL)shouldJumpBackward:(CGPoint)pos;
-(BOOL)shouldJump:(CGPoint)pos;
-(void)moveFingertrackerto:(CGPoint)pos;
-(void)resetFingertracker;

@end
