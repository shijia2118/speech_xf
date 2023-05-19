#import "SpeechXfPlugin.h"
#import "IATConfig.h"
#import "IFlyMSC/IFlyMSC.h"

@implementation SpeechXfPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"xf_speech_to_text"
            binaryMessenger:[registrar messenger]];
  SpeechXfPlugin* instance = [[SpeechXfPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]){
        //初始化SDK
        [self init : call.arguments];
    } else if([@"open_native_ui_dialog" isEqualToString:call.method]){
        //带UI的识别单例
        if (_iflyRecognizerView == nil) {
            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:[UIApplication sharedApplication].keyWindow.center];
        }
            
        //清除参数
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
        //设置语音识别结果应用为普通文本领域
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];

        
        _iflyRecognizerView.delegate = self;
        
        if (_iflyRecognizerView != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //set timeout of recording
            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点检测时间
            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点检测时间
            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //set network timeout
            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];

            //设置采样率为8000
            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];

            //set language
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //set accent
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            //set whether or not to show punctuation in recognition results
            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

/**
 * 初始化SDK
 */
- (void) init:(NSDictionary*) args {
    NSString *appId = args[@"appId"];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", appId];
    [IFlySpeechUtility createUtility:initString];
    NSLog(@"SDK初始化成功!");
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    NSLog(@"resultsFromJson=%@","");
}

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"resultsFromJson=%@","");

}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    NSLog(@"resultsFromJson=%@","");

}

@end
