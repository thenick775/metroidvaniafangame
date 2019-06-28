//
//  saveData.m
//  Metroidvania
//
//  Created by nick vancise on 6/23/19.
//

#import "saveData.h"

@implementation saveData


+ (instancetype)sharedInstance {//allocate once and only once, then we should be good to use this to retreive
    static saveData *mydat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mydat = [[saveData alloc] init];
        if(mydat!=nil){
            mydat.lvlarr=[[NSMutableArray alloc] initWithArray:@[@0,@0,@0]];
            mydat.bultypearr=[[NSMutableArray alloc] initWithArray:@[@"",@"",@""]];
            mydat.bulrangearr=[[NSMutableArray alloc] initWithArray:@[@0,@0,@0]];
        }
    });
    return mydat;
}

- (id)initWithCoder:(NSCoder *)aDecoder {//decode requred fields
    saveData *mydat = [saveData sharedInstance];
    
    [mydat setLvlarr:[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"LVL_key"]];
    [mydat setBultypearr:[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"Bultype_key"]];
    [mydat setBulrangearr:[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"Bulrange_key"]];
    return mydat;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {//encode required fields
    saveData *mydat = [saveData sharedInstance];
    
    [aCoder encodeObject:mydat.lvlarr forKey:@"LVL_key"];
    [aCoder encodeObject:mydat.bultypearr forKey:@"Bultype_key"];
    [aCoder encodeObject:mydat.bulrangearr forKey:@"Bulrange_key"];
}

+(void)printcurr{//convience print
    saveData *mydat = [saveData sharedInstance];
    NSLog(@"%@\n%@\n%@",mydat.lvlarr,mydat.bultypearr,mydat.bulrangearr);
}

+(void)arch{//used to archive the singleton
    NSError* _Nullable __autoreleasing theerror;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[saveData sharedInstance] requiringSecureCoding:YES error:&theerror] forKey:@"Tot_dat_key"];
    if(theerror!=nil)
        NSLog(@"%@",theerror);
}

+(void)unarch{//used to unarchive the singleton
    NSError* _Nullable __autoreleasing theerror;
    [NSKeyedUnarchiver unarchivedObjectOfClass:[saveData class] fromData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Tot_dat_key"] error:&theerror];
    if(theerror!=nil)
        NSLog(@"%@",theerror);
}

+(void)editlvlwithval:(NSInteger)val forsaveslot:(int)slot{//initial, I may change these to use objectatindex
    [saveData sharedInstance].lvlarr[slot]=[NSNumber numberWithInteger:val];
}
+(void)editbultypewithval:(NSString*)val forsaveslot:(int)slot{
    [saveData sharedInstance].bultypearr[slot]=val;
}
+(void)editbulrangewithval:(NSInteger)val forsaveslot:(int)slot{
    [saveData sharedInstance].bulrangearr[slot]=[NSNumber numberWithInteger:val];
}
+(NSInteger)getlvlfromslot:(int)slot{
    return (NSInteger)[saveData sharedInstance].lvlarr[slot];
}
+(NSInteger)getbulrangefromslot:(int)slot{
    return (NSInteger)[saveData sharedInstance].bulrangearr[slot];
}
+(NSString*)getbultypefromslot:(int)slot{
    return (NSString*)[saveData sharedInstance].bultypearr[slot];
}


+ (BOOL)supportsSecureCoding{return YES;}//here to support NSSecureCoding

@end
