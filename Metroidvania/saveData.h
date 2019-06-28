//
//  saveData.h
//  Metroidvania
//
//  Created by nick vancise on 6/23/19.
//


#import <Foundation/Foundation.h>

@interface saveData : NSObject <NSSecureCoding>


@property (strong,nonatomic) NSMutableArray*lvlarr;      //will use these to store all levels data at once, since encoding is easy.
@property (strong,nonatomic) NSMutableArray*bultypearr;  //These should not be accessed directly
@property (strong,nonatomic) NSMutableArray*bulrangearr;

+(instancetype)sharedInstance;
+(void)editlvlwithval:(NSInteger)val forsaveslot:(int)slot;
+(void)editbultypewithval:(NSString*)val forsaveslot:(int)slot;
+(void)editbulrangewithval:(NSInteger)val forsaveslot:(int)slot;
+(NSInteger)getlvlfromslot:(int)slot;
+(NSInteger)getbulrangefromslot:(int)slot;
+(NSString*)getbultypefromslot:(int)slot;
+(void)printcurr;
+(void)arch;
+(void)unarch;

@end
