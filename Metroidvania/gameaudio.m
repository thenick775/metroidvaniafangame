//
//  gameaudio.m
//  Metroidvania
//
//  Created by nick vancise on 10/25/18.
//  Base created by Patrick Collins

#import "gameaudio.h"

@implementation gameaudio

-(void)runBkgrndMusicForlvl:(int)lvlnum{
    if(lvlnum==0)
        self.bkgrndmusic=[gameaudio setupRepeatingSound:@"titlescreen_dystopian-future.wav" volume:0.7];
    else if(lvlnum==1)
        self.bkgrndmusic=[gameaudio setupRepeatingSound:@"lvl1-lost-moon.wav" volume:0.6];
    else if(lvlnum==2)
        self.bkgrndmusic=[gameaudio setupRepeatingSound:@"lvl2_newbit2.wav" volume:0.8];
    
    [gameaudio playSound:self.bkgrndmusic];
}

-(void)switchBackgroundMusicTo:(NSString*)newsong{
    __weak NSString*weaknewsong=newsong;
    [gameaudio pauseSound:self.bkgrndmusic];
    self.bkgrndmusic=[gameaudio setupRepeatingSound:weaknewsong volume:0.7];
    [gameaudio playSound:self.bkgrndmusic];
}




//class functions
// get a repeating sound
+(AVAudioPlayer*)setupRepeatingSound:(NSString*)file volume:(float)volume {
    __weak NSString*weakfile=file;
    AVAudioPlayer *s = [self setupSound:weakfile volume:volume];
    s.numberOfLoops = -1;
    return s;
}

// setup a sound
+(AVAudioPlayer*)setupSound:(NSString*)file volume:(float)volume{
    NSError *error;
    __weak NSString*weakfile=file;
    __weak NSURL *url = [[NSBundle mainBundle] URLForResource:weakfile withExtension:nil];
    AVAudioPlayer *s = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    s.numberOfLoops = 0;
    s.volume = volume;
    [s prepareToPlay];
    return s;
}

// play a sound now through GCD
+(void)playSound:(AVAudioPlayer*)player {
    __weak AVAudioPlayer*weakplayer=player;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakplayer play];
    });
}

// play a sound later through GCD
+(void)playSound:(AVAudioPlayer*)player afterDelay:(float)delaySeconds {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [player play];
    });
}

// pause a currently running sound (mostly for background music)
+(void)pauseSound:(AVAudioPlayer*)player {
    [player pause];
}

/*-(void)dealloc{
    NSLog(@"soundmanager deallocated");
}*/

@end
