//
//  SpeechXfStream.m
//  speech_xf
//
//  Created by jia shi on 2023/5/21.
//

#import <Foundation/Foundation.h>
#import "SpeechTtsStream.h"

@implementation SpeechTtsStream

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SpeechTtsStream *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[SpeechTtsStream alloc] init];
        SpeechTtsStreamHanlder * ttsStreamHandler = [[SpeechTtsStreamHanlder alloc] init];
        manager.ttsStreamHandler = ttsStreamHandler;
    });
    
    return manager;
}

@end

@implementation SpeechTtsStreamHanlder

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)ttsEventSink {
    self.ttsEventSink = ttsEventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.ttsEventSink = nil;
    return nil;
}

@end

