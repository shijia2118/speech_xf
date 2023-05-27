//
//  SpeechXfStream.m
//  speech_xf
//
//  Created by jia shi on 2023/5/21.
//

#import <Foundation/Foundation.h>
#import "SpeechXfStream.h"

@implementation SpeechXfStream

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SpeechXfStream *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[SpeechXfStream alloc] init];
        SpeechXfStreamHanlder * streamHandler = [[SpeechXfStreamHanlder alloc] init];
        manager.iatStreamHandler = streamHandler;
    });
    
    return manager;
}

@end

@implementation SpeechXfStreamHanlder

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.iatEventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.iatEventSink = nil;
    return nil;
}

@end

