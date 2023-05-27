//
//  SpeechXfStream.h
//  speech_xf
//
//  Created by jia shi on 2023/5/21.
//

#ifndef SpeechXfStream_h
#define SpeechXfStream_h

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@class SpeechXfStreamHanlder;
@interface SpeechXfStream : NSObject
+ (instancetype)sharedInstance ;
@property (nonatomic, strong) SpeechXfStreamHanlder* iatStreamHandler;

@end

@interface SpeechXfStreamHanlder : NSObject<FlutterStreamHandler>
@property (nonatomic, strong,nullable) FlutterEventSink iatEventSink;

@end
NS_ASSUME_NONNULL_END



#endif /* SpeechXfStream_h */
