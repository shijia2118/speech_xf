//
//  TTSConfig.m
//  speech_xf
//
//  Created by jia shi on 2023/5/24.
//

#import "TTSConfig.h"

@implementation TTSConfig

-(id)init {
    self  = [super init];
    if (self) {
        [self defaultSetting];
        return  self;
    }
    return nil;
}

+(TTSConfig *)sharedInstance {
    static TTSConfig  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[TTSConfig alloc] init];
    });
    return instance;
}


-(void)defaultSetting {
    _speed = @"50";
    _volume = @"50";
    _pitch = @"50";
    _sampleRate = @"16000";
    _engineType = @"cloud";
    _vcnName = @"xiaoyan";

    _xttsNickNameArray=@[NSLocalizedString(@"xiaoyan", nil)];
    _xttsIdentiferArray=@[@"xiaoyan"];

    _vcnNickNameArray = @[
                          NSLocalizedString(@"xiaoyan", nil),
                          NSLocalizedString(@"xiaoyu", nil),
                          NSLocalizedString(@"xiaoyan2", nil),
                          NSLocalizedString(@"xiaoqi", nil),
                          NSLocalizedString(@"xiaofeng", nil),
                          NSLocalizedString(@"xiaoxin", nil),
                          NSLocalizedString(@"xiaokun", nil),
                          NSLocalizedString(@"English", nil),
                          NSLocalizedString(@"Vietnamese", nil),
                          NSLocalizedString(@"Hindi", nil),
                          NSLocalizedString(@"Spanish", nil),
                          NSLocalizedString(@"Russian", nil),
                          NSLocalizedString(@"French", nil)];
    
    _vcnIdentiferArray = @[@"xiaoyan",@"xiaoyu",@"vixy",@"vixq",@"vixf",@"vixx",@"vixk",@"catherine",@"XiaoYun",@"Abha",@"Gabriela",@"Allabent",@"Mariane"];
}


@end

