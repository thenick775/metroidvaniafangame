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
}

@end

@implementation saveCellManager

-(instancetype)initWithRect:(CGRect)rect andRad:(int)rad{
    self=[super init];
    if(self!=nil){
    
        self.path=(CGPathRef)CFAutorelease(CGPathCreateWithRoundedRect(rect,rad,rad,nil));
        self.alpha=0;
        self.fillColor=[SKColor darkGrayColor];
        self.zPosition=5;
        
        float width=self.frame.size.width*0.75;
        float height=self.frame.size.height*0.29;
        float pad=self.frame.size.height*0.02;
        float halfw=self.frame.size.width/2;
        float halfh=self.frame.size.height/2;
        float ratioheight=self.frame.size.height*0.3;
    
        saveCell*cell=[[saveCell alloc] initWithSize:CGSizeMake(width, height) andcorRad:12 forslot:0];
        cell.position=CGPointMake(self.frame.origin.x+halfw, self.frame.origin.y+ratioheight+pad+halfh);
        cell.fillColor=[SKColor blackColor];
        cell.zPosition=6;
        saveCell*cell1=[[saveCell alloc] initWithSize:CGSizeMake(width, height) andcorRad:12 forslot:1];
        cell1.position=CGPointMake(self.frame.origin.x+halfw, self.frame.origin.y+halfh);//CGPointZero;
        cell1.fillColor=[SKColor blackColor];
        cell1.zPosition=6;
        saveCell*cell2=[[saveCell alloc] initWithSize:CGSizeMake(width, height) andcorRad:12 forslot:2];
        cell2.position=CGPointMake(self.frame.origin.x+halfw, self.frame.origin.y-ratioheight-pad+halfh);
        cell2.fillColor=[SKColor blackColor];
        cell2.zPosition=6;
        self.cells=@[cell,cell1,cell2];
        [self addChild:self.cells[0]];
        [self addChild:self.cells[1]];
        [self addChild:self.cells[2]];
        
    }
    return self;
}

-(int)cgpointinslot:(CGPoint)point{
    int val=-1;
    if(CGRectContainsPoint(((saveCell*)self.cells[0]).frame, point)){
        val=0;
    }
    else if(CGRectContainsPoint(((saveCell*)self.cells[1]).frame, point)){
        val=1;
    }
    else if(CGRectContainsPoint(((saveCell*)self.cells[2]).frame, point)){
        val=2;
    }
    return val;
}

/*-(void)dealloc{
    NSLog(@"in saveCellManager dealloc");
}*/

@end


@implementation saveCell

-(instancetype)initWithSize:(CGSize)size andcorRad:(CGFloat)corrad forslot:(int)slot{
    self=[super init];
    if(self!=nil){
        self.path=(CGPathRef)CFAutorelease(CGPathCreateWithRoundedRect(CGRectMake(-size.width/2,-size.height/2, size.width, size.height), 12, 12, nil));
        self.left=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        self.left.zPosition=7;
        self.left.fontSize=16;
        self.center=self.left.copy;
        self.right=self.left.copy;
        self.left.text=[NSString stringWithFormat:@"save slot %d",slot];
        self.left.position=CGPointMake(self.frame.size.width*-0.33,0);
        self.center.text=[@"lvl: " stringByAppendingString:[[saveData getlvlfromslot:slot] stringValue]];
        self.right.text=[saveData getprogfromslot:slot];
        self.right.position=CGPointMake(self.frame.size.width*0.33,0);
        self.cellno=slot;
        [self addChild:self.left];
        [self addChild:self.center];
        [self addChild:self.right];
    }
    return self;
}

-(void)fadeLabels{
    self.selected=YES;
    __weak saveCell*weakself=self;
    SKAction*fadeac=[SKAction fadeOutWithDuration:0.25];
    NSTimeInterval waitdir=0;
    for(SKLabelNode*child in self.children){
        [child runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],fadeac]]];
        waitdir+=0.2;
    }
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],[SKAction runBlock:^{weakself.left.text=[weakself.right.text isEqualToString:@"empty"] ? @"start?":@"continue?";weakself.right.text=@"reset?";}]]]];
    waitdir+=0.05;
    
    [self.left runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],[SKAction fadeInWithDuration:0.25]]]];
    waitdir+=0.3;
    [self.right runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],[SKAction fadeInWithDuration:0.25]]]];
}

-(void)showLabels{
    self.selected=NO;
    __weak saveCell*weakself=self;
    SKAction*fadeac=[SKAction fadeInWithDuration:0.25];
    NSTimeInterval waitdir=0;
    
    
    [self.left runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],[SKAction fadeOutWithDuration:0.25]]]];
    waitdir+=0.25;
    [self.right runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],[SKAction fadeOutWithDuration:0.25]]]];
    waitdir+=0.25;
    
    __weak NSString*tmp=[saveData getprogfromslot:self.cellno];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],[SKAction runBlock:^{weakself.left.text=[NSString stringWithFormat:@"save slot %d",weakself.cellno];weakself.right.text=tmp;}]]]];
    waitdir+=0.05;
    
    for(SKLabelNode*child in self.children){
        [child runAction:[SKAction sequence:@[[SKAction waitForDuration:waitdir],fadeac]]];
        waitdir+=0.2;
    }
}

/*-(void)dealloc{
    NSLog(@"in savecell dealloc");
}*/
@end

