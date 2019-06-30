//
//  saveData.h
//  Metroidvania
//
//  Created by nick vancise on 6/23/19.
//


#import <Foundation/Foundation.h>

@interface saveData : NSObject <NSSecureCoding>


@property (strong,nonatomic) NSMutableArray*lvlarr;      //will use these to store all levels data at once, since encoding is easy.
@property (strong,nonatomic) NSMutableArray*seenbossarr;  //These should not be accessed directly
@property (strong,nonatomic) NSMutableArray*progarr;
@property (assign,nonatomic) int currentslot;

+(instancetype)sharedInstance;
+(void)editlvlwithval:(NSNumber*)val forsaveslot:(int)slot;
+(void)editprogwithval:(NSString*)val forsaveslot:(int)slot;
+(void)editseenbosswithval:(BOOL)val forsaveslot:(int)slot;
+(void)editcurrslot:(int)slot;
+(NSNumber*)getlvlfromslot:(int)slot;
+(BOOL)getseenbossfromslot:(int)slot;
+(NSString*)getprogfromslot:(int)slot;
+(int)getcurrslot;
+(void)printcurr;
+(void)arch;
+(void)unarch;
+(void)reset_slot:(int)slot;
+(void)delete_vals;//for developer testing at the moment

@end
