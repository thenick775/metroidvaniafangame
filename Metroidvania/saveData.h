//
//  saveData.h
//  Metroidvania
//
//  Created by nick vancise on 6/23/19.
//


#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

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

@end

@interface saveCellManager : SKShapeNode

@property (nonatomic,strong) NSArray*cells;
-(instancetype)initWithRect:(CGRect)rect andRad:(int)rad;
-(int)cgpointinslot:(CGPoint)point;

@end

@interface saveCell : SKShapeNode

@property (nonatomic,strong) SKLabelNode*center;
@property (nonatomic,strong) SKLabelNode*left;
@property (nonatomic,strong) SKLabelNode*right;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) int cellno;

-(void)fadeLabels;
-(void)showLabels;
-(instancetype)initWithSize:(CGSize)size andcorRad:(CGFloat)corrad forslot:(int)slot;

@end
