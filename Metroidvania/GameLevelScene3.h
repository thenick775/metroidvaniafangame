//
//  GameLevelScene3.h
//  Metroidvania
//
//  Created by nick vancise on 10/29/18.
//

#import "levelBase.h"

@interface GameLevelScene3 : levelBase

@property (nonatomic,strong) TMXLayer*background;
@property (nonatomic,strong) TMXLayer*foreground;
@property (nonatomic,strong) NSMutableArray*doors;

@end
