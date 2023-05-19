#import "SpeechXfPlugin.h"
#import "IATConfig.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"

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
        //开启带内置UI的语音识别
        [self openNativeUiDialog: call.arguments];
    } else if([@"start_listening" isEqualToString:call.method]){
        //开启无UI的语音识别
    } else if([@"stop_listening" isEqualToString:call.method]){
        //停止语音识别
    } else if([@"cancel_listening" isEqualToString:call.method]){
        //取消语音识别
    } else if([@"upload_user_words" isEqualToString:call.method]){
        //上传用户热词
    } else if([@"audio_recognizer" isEqualToString:call.method]){
        // 音频流识别
    } else {
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

/**
 * 开启带内置UI的语音听写
 */
- (void) openNativeUiDialog:(NSDictionary*) args {
    
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
        NSNumber *idcNum = args[@"isDynamicCorrection"];
        BOOL isDynamicCorrection = idcNum.boolValue;
        
        NSString *language = args[@"language"];
        NSString *vadBos = args[@"vadBos"];
        NSString *vadEos = args[@"vadEos"];
        NSString *ptt = args[@"ptt"];

        IATConfig *instance = [IATConfig sharedInstance];
        //设置录音超时时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点检测时间
        [_iflyRecognizerView setParameter:vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点检测时间
        [_iflyRecognizerView setParameter:vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //设置网络延迟
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率为8000
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        //设置语言
        [_iflyRecognizerView setParameter:language forKey:[IFlySpeechConstant LANGUAGE]];
        //设置标点
        [_iflyRecognizerView setParameter:ptt forKey:[IFlySpeechConstant ASR_PTT]];
        // 开始识别语音
        [_iflyRecognizerView start];
    }
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    NSLog(@">>>>>>>>>results:",results);
    NSLog(@">>>>>>>>>isLast:",isLast);
}

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"%s",__func__);
    NSString *text ;
    if (error.errorCode != 0 ) {
        text = [NSString stringWithFormat:@"Error：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"error=%@",text);
    }
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
        
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  nil;
        
    resultFromJson = [ISRDataHelper stringFromJson:resultString];//;[ISRDataHelper stringFromJson:resultString];
        
    NSLog(@"resultFromJson=%@",resultFromJson);
    
    if(isLast){
        NSLog(@"result>>>>%@",resultFromJson);
    }
        
       

}

@end
