//
//  gameaudio.h
//  Metroidvania
//
//  Created by nick vancise on 10/25/18.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface gameaudio : NSObject <AVAudioPlayerDelegate>


-(void)runBkgrndMusicForlvl:(int)lvlnum andVol:(float)volume;
@property(nonatomic,strong) AVAudioPlayer*bkgrndmusic;
@property(nonatomic,assign) float currentVolume;    // % out of 100;

+(AVAudioPlayer*)setupRepeatingSound:(NSString*)file volume:(float)volume;
+(AVAudioPlayer*)setupSound:(NSString*)file volume:(float)volume;
+(void)playSound:(AVAudioPlayer*)player;
+(void)playSound:(AVAudioPlayer*)player afterDelay:(float)delaySeconds;
+(void)pauseSound:(AVAudioPlayer*)player;

@end
