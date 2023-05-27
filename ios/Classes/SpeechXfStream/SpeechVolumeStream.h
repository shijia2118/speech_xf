//
//  SpeechVolumeStream.h
//  speech_xf
//
//  Created by jia shi on 2023/5/24.
//

#ifndef SpeechVolumeStream_h
#define SpeechVolumeStream_h


#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


NS_ASSUME_NONNULL_BEGIN
@class SpeechVolumeStreamHanlder;
@interface SpeechVolumeStream : NSObject
+ (instancetype)sharedInstance ;
@property (nonatomic, strong) SpeechVolumeStreamHanlder* volumeStreamHandler;

@end

@interface SpeechVolumeStreamHanlder : NSObject<FlutterStreamHandler>
@property (nonatomic, strong,nullable) FlutterEventSink volumeEventSink;

@end
NS_ASSUME_NONNULL_END




#endif /* SpeechVolumeStream_h */
