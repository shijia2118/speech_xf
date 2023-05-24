//
//  IATConfig.h
//  speech_xf
//
//  Created by jia shi on 2023/5/19.
//

#import <Foundation/Foundation.h>

@interface IATConfig : NSObject

+(IATConfig *)sharedInstance;

+(NSString *)french;
+(NSString *)spanish;
+(NSString *)korean;
+(NSString *)japanese;
+(NSString *)russian;
+(NSString *)mandarin;
+(NSString *)cantonese;
+(NSString *)sichuanese;
+(NSString *)chinese;
+(NSString *)english;
+(NSString *)lowSampleRate;
+(NSString *)highSampleRate;
+(NSString *)isDot;
+(NSString *)noDot;



@property (nonatomic, strong) NSString *speechTimeout;
@property (nonatomic, strong) NSString *vadEos;
@property (nonatomic, strong) NSString *vadBos;

@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *accent;

@property (nonatomic, strong) NSString *dot;
@property (nonatomic, strong) NSString *sampleRate;

@property (nonatomic) BOOL  isTranslate;//whether or not to open translation



@property (nonatomic, assign) BOOL haveView;
@property (nonatomic, strong) NSArray *accentIdentifer;
@property (nonatomic, strong) NSArray *accentNickName;


@end
