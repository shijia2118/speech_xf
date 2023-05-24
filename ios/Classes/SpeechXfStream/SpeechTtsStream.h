//
//  SpeechTtsStream.h
//  speech_xf
//
//  Created by jia shi on 2023/5/24.
//

#ifndef SpeechTtsStream_h
#define SpeechTtsStream_h


#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


NS_ASSUME_NONNULL_BEGIN
@class SpeechTtsStreamHanlder;
@interface SpeechTtsStream : NSObject
+ (instancetype)sharedInstance ;
@property (nonatomic, strong) SpeechTtsStreamHanlder* ttsStreamHandler;

@end

@interface SpeechTtsStreamHanlder : NSObject<FlutterStreamHandler>
@property (nonatomic, strong,nullable) FlutterEventSink ttsEventSink;

@end
NS_ASSUME_NONNULL_END




#endif /* SpeechTtsStream_h */
