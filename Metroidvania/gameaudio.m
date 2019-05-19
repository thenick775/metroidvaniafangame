//
//  gameaudio.m
//  Metroidvania
//
//  Created by nick vancise on 10/25/18.
//  Base created by Patrick Collins
#import "gameaudio.h"

@implementation gameaudio{
    NSMutableArray*_musicQueue;  //for background music containing 1 or more tracks to be played
    int _currentQueueIterator;
}

-(void)runBkgrndMusicForlvl:(int)lvlnum andVol:(float)volume{
    _musicQueue=[[NSMutableArray alloc] init];
    _currentQueueIterator=0;
    self.currentVolume=volume;
    if(lvlnum==0){
        [_musicQueue addObject:[gameaudio setupSound:@"titlescreen_dystopian-future.wav" volume:self.currentVolume]];
    }
    else if(lvlnum==1){
        //self.bkgrndmusic=[gameaudio setupRepeatingSound:@"lvl1-lost-moon.wav" volume:self.currentVolume];
        [_musicQueue addObject:[gameaudio setupSound:@"lvl1-lost-moon.wav" volume:self.currentVolume]];
    }
    else if(lvlnum==2){
        [_musicQueue addObjectsFromArray:@[[gameaudio setupSound:@"11 Lonely.mp3" volume:self.currentVolume],[gameaudio setupSound:@"Trap Beat 2017, Dope Rap_Trap Instrumentalc.mp3" volume:self.currentVolume]]];
    }
    else if(lvlnum==3){
        [_musicQueue addObjectsFromArray:@[[gameaudio setupSound:@"254Beats-Trap-2017.mp3" volume:self.currentVolume],[gameaudio setupSound:@"Yung_Kartz_-_08_-_Aye.mp3" volume:self.currentVolume]]];
    }
    
    self.bkgrndmusic=_musicQueue[_currentQueueIterator];
    self.bkgrndmusic.delegate=self;
    self.currentVolume=self.currentVolume*100;
    [gameaudio playSound:self.bkgrndmusic];
}

-(void)switchBackgroundMusicTo:(NSString*)newsong{
    __weak NSString*weaknewsong=newsong;
    [gameaudio pauseSound:self.bkgrndmusic];
    self.bkgrndmusic=[gameaudio setupRepeatingSound:weaknewsong volume:0.7];
    [gameaudio playSound:self.bkgrndmusic];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{//for background music playing continuous tracks
    _currentQueueIterator++;
    if(_currentQueueIterator>=_musicQueue.count){
        _currentQueueIterator=0;
    }
    self.bkgrndmusic=_musicQueue[_currentQueueIterator];
    self.bkgrndmusic.delegate=self;
    self.bkgrndmusic.volume=player.volume;
    [gameaudio playSound:self.bkgrndmusic];
}


//class functions
// get a repeating sound
+(AVAudioPlayer*)setupRepeatingSound:(NSString*)file volume:(float)volume {
    AVAudioPlayer *s = [self setupSound:file volume:volume];
    s.numberOfLoops = -1;
    return s;
}

// setup a sound
+(AVAudioPlayer*)setupSound:(NSString*)file volume:(float)volume{
    NSError *error;
    NSURL *url = [[NSBundle mainBundle] URLForResource:file withExtension:nil];
    AVAudioPlayer *s = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    s.numberOfLoops = 0;
    s.volume = volume;
    [s prepareToPlay];
    return s;
}

// play a sound now
+(void)playSound:(AVAudioPlayer*)player {
    //__weak AVAudioPlayer*weakplayer=player;
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [/*weak*/player play];
    //});
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
