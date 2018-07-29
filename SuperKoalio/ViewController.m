//
//  ViewController.m
//  Metroidvania
//
//  Created by Jake Gundersen on 12/27/13.
//  Modified by Nick VanCise

#import "ViewController.h"
#import "MenuScene.h"

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
  NSLog(@"in view");
  [super viewDidAppear:animated];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsFPS = YES;
  skView.showsNodeCount = YES;
  skView.showsDrawCount =YES;
  
  // Create and configure the scene.
  /*SKScene * scene = [GameLevelScene sceneWithSize:CGSizeMake((CGFloat)skView.bounds.size.width/1.2, ((CGFloat)skView.bounds.size.height/1.2))];  //was skView.bounds.size
  scene.scaleMode = SKSceneScaleModeAspectFill;*/
  // Present the scene.
  SKScene *menuscenep=[[MenuScene alloc] initWithSize:skView.bounds.size];
  [skView presentScene:menuscenep];
  
  
}

- (BOOL)shouldAutorotate
{
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}




@end
