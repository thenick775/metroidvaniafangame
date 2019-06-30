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
            mydat.seenbossarr=[[NSMutableArray alloc] initWithArray:@[@NO,@NO,@NO]];
            mydat.progarr=[[NSMutableArray alloc] initWithArray:@[@"empty",@"empty",@"empty"]];
        }
    });
    return mydat;
}

- (id)initWithCoder:(NSCoder *)aDecoder {//decode requred fields
    saveData *mydat = [saveData sharedInstance];
    
    [mydat setLvlarr:[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"LVL_key"]];
    [mydat setSeenbossarr:[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"Bultype_key"]];
    [mydat setProgarr:[aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:@"Prog_key"]];
    return mydat;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {//encode required fields
    saveData *mydat = [saveData sharedInstance];
    
    [aCoder encodeObject:mydat.lvlarr forKey:@"LVL_key"];
    [aCoder encodeObject:mydat.seenbossarr forKey:@"Bultype_key"];
    [aCoder encodeObject:mydat.progarr forKey:@"Prog_key"];
}

+(void)printcurr{//convience print
    saveData *mydat = [saveData sharedInstance];
    NSLog(@"%@\n%@\n%@",mydat.lvlarr,mydat.seenbossarr,mydat.progarr);
}

+(void)arch{//used to archive the singleton
    NSError* _Nullable __autoreleasing theerror;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[saveData sharedInstance] requiringSecureCoding:YES error:&theerror] forKey:@"Tot_dat_key"];
    if(theerror!=nil)
        NSLog(@"%@",theerror);
}

+(void)unarch{//used to unarchive the singleton
    NSError* _Nullable __autoreleasing theerror;
    NSData *mydat=[[NSUserDefaults standardUserDefaults] objectForKey:@"Tot_dat_key"];
    if(mydat!=nil){
        NSLog(@"unarchiving");
        [NSKeyedUnarchiver unarchivedObjectOfClass:[saveData class] fromData:mydat error:&theerror];
        if(theerror!=nil)
            NSLog(@"%@",theerror);
    }
    else
        NSLog(@"no data to unarchive");
}

+(void)editlvlwithval:(NSNumber*)val forsaveslot:(int)slot{//initial, I may change these to use objectatindex
    [saveData sharedInstance].lvlarr[slot]=val;//[NSNumber numberWithInteger:val];
}
+(void)editprogwithval:(NSString*)val forsaveslot:(int)slot{
    [saveData sharedInstance].progarr[slot]=val;
}
+(void)editseenbosswithval:(BOOL)val forsaveslot:(int)slot{
    [saveData sharedInstance].seenbossarr[slot]=[NSNumber numberWithBool:val];
}
+(void)editcurrslot:(int)slot{
    [saveData sharedInstance].currentslot=slot;
}
+(NSNumber*)getlvlfromslot:(int)slot{
    return [saveData sharedInstance].lvlarr[slot];//[[saveData sharedInstance].lvlarr[slot] integerValue];
}
+(BOOL)getseenbossfromslot:(int)slot{
    return [[saveData sharedInstance].seenbossarr[slot] boolValue];
}
+(NSString*)getprogfromslot:(int)slot{
    return [saveData sharedInstance].progarr[slot];
}
+(int)getcurrslot{
    return [saveData sharedInstance].currentslot;
}


+ (BOOL)supportsSecureCoding{return YES;}//here to support NSSecureCoding

+(void)reset_slot:(int)slot{
    saveData *mydat=[saveData sharedInstance];
    mydat.lvlarr[slot]=@0;
    mydat.seenbossarr[slot]=@NO;
    mydat.progarr[slot]=@"empty";
    [saveData arch];
}

+(void)delete_vals{//for developer testing at the moment, reset functions should be implemented
    NSLog(@"in delete vals");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Tot_dat_key"];
}


@end
