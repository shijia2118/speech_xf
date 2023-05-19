//
//  IATConfig.m
//  speech_xf
//
//  Created by jia shi on 2023/5/19.
//

#define PUTONGHUA   @"mandarin"
#define YUEYU       @"cantonese"
#define ENGLISH     @"en_us"
#define CHINESE     @"zh_cn";
#define SICHUANESE  @"lmz";

#define RIYU  @"ja_jp";
#define EYU  @"ru-ru";
#define FAYU  @"fr_fr";
#define XBY  @"es_es";
#define HANYU  @"ko_kr";

#import "IATConfig.h"

@implementation IATConfig

-(id)init {
    self  = [super init];
    if (self) {
        [self defaultSetting];
        return  self;
    }
    return nil;
}


+(IATConfig *)sharedInstance {
    static IATConfig  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[IATConfig alloc] init];
    });
    return instance;
}


-(void)defaultSetting {
    _speechTimeout = @"30000";
    _vadEos = @"3000";
    _vadBos = @"3000";
    _dot = @"1";
    _sampleRate = @"16000";
    _language = CHINESE;
    _accent = PUTONGHUA;
    _haveView = NO;
    _accentNickName = [[NSArray alloc] initWithObjects:NSLocalizedString(@"K_LangCant", nil), NSLocalizedString(@"K_LangChin", nil), NSLocalizedString(@"K_LangEng", nil), NSLocalizedString(@"K_LangSzec", nil),NSLocalizedString(@"K_LangJapa", nil),NSLocalizedString(@"K_LangRuss", nil),NSLocalizedString(@"K_LangFren", nil),NSLocalizedString(@"K_LangSpan", nil),NSLocalizedString(@"K_LangKor", nil), nil];
    
    _isTranslate = NO;
}
+(NSString *)french{
    return FAYU;
}
+(NSString *)spanish{
    return XBY;
}
+(NSString *)korean{
    return HANYU;
}
+(NSString *)japanese{
    return RIYU;
}
+(NSString *)russian{
    return EYU;
}

+(NSString *)mandarin {
    return PUTONGHUA;
}
+(NSString *)cantonese {
    return YUEYU;
}
+(NSString *)chinese {
    return CHINESE;
}
+(NSString *)english {
    return ENGLISH;
}
+(NSString *)sichuanese {
    return SICHUANESE;
}

+(NSString *)lowSampleRate {
    return @"8000";
}

+(NSString *)highSampleRate {
    return @"16000";
}

+(NSString *)isDot {
    return @"1";
}

+(NSString *)noDot {
    return @"0";
}

@end
