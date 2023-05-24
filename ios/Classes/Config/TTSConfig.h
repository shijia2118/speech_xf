//
//  TTSConfig.h
//  speech_xf
//
//  Created by jia shi on 2023/5/24.
//

#ifndef TTSConfig_h
#define TTSConfig_h


#import <Foundation/Foundation.h>
#import "IFlyMSC/IFlyMSC.h"

@interface TTSConfig : NSObject

+(TTSConfig *)sharedInstance;

@property (nonatomic) NSString *speed;
@property (nonatomic) NSString *volume;
@property (nonatomic) NSString *pitch;
@property (nonatomic) NSString *sampleRate;
@property (nonatomic) NSString *vcnName;
@property (nonatomic) NSString *engineType;// the engine type of Text-to-Speech:"auto","local","cloud"


@property (nonatomic,strong) NSArray *vcnNickNameArray;

@property (nonatomic,strong) NSArray *vcnIdentiferArray;

@property (nonatomic,strong) NSArray *xttsNickNameArray;
@property (nonatomic,strong) NSArray *xttsIdentiferArray;

@end



#endif /* TTSConfig_h */
