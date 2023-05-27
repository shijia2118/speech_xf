//
//  SpeechVolumeStream.m
//  speech_xf
//
//  Created by jia shi on 2023/5/21.
//

#import <Foundation/Foundation.h>
#import "SpeechVolumeStream.h"

@implementation SpeechVolumeStream

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SpeechVolumeStream *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[SpeechVolumeStream alloc] init];
        SpeechVolumeStreamHanlder * volumeStreamHandler = [[SpeechVolumeStreamHanlder alloc] init];
        manager.volumeStreamHandler = volumeStreamHandler;
    });
    
    return manager;
}

@end

@implementation SpeechVolumeStreamHanlder

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)volumeEventSink {
    self.volumeEventSink = volumeEventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.volumeEventSink = nil;
    return nil;
}

@end

