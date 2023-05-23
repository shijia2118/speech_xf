#import "SpeechXfPlugin.h"
#import "IATConfig.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "ToastView.h"
#import "SpeechXfStream.h"

@implementation SpeechXfPlugin

SpeechXfStream *streamInstance;
NSString *type = @"";

NSObject<FlutterPluginRegistrar> *flutterPluginRegistrar;

NSString *pcmFilePath = @"";


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    flutterPluginRegistrar = registrar;
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"xf_speech_to_text"
            binaryMessenger:[registrar messenger]];
  SpeechXfPlugin* instance = [[SpeechXfPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  
    FlutterEventChannel *eventChanel = [FlutterEventChannel eventChannelWithName:@"xf_speech_to_text_stream" binaryMessenger:[registrar messenger]];
    streamInstance = [SpeechXfStream sharedInstance];
    [eventChanel setStreamHandler:[streamInstance streamHandler]];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    

    if ([@"init" isEqualToString:call.method]){
        //初始化SDK
        [self init : call.arguments];
    } else if([@"open_native_ui_dialog" isEqualToString:call.method]){
        type = @"1";
        //开启带内置UI的语音识别
        [self openNativeUiDialog: call.arguments];
    } else if([@"start_listening" isEqualToString:call.method]){
        type = @"2";
        //开启无UI的语音识别
        [self startListening:call.arguments];
    } else if([@"stop_listening" isEqualToString:call.method]){
        //停止语音识别
        [_iFlySpeechRecognizer stopListening];
    } else if([@"cancel_listening" isEqualToString:call.method]){
        //取消语音识别
        [_iFlySpeechRecognizer cancel];
    } else if([@"upload_user_words" isEqualToString:call.method]){
        //上传用户热词
        [self uploadUserWords:call.arguments];
    } else if([@"audio_recognizer" isEqualToString:call.method]){
        // 音频流识别
        [self audioRecognizer:call.arguments];
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

/**
 * 上传用户热词
 */
- (void) uploadUserWords:(NSDictionary*) args {
    [_iFlySpeechRecognizer stopListening];
    NSString *userwords = args[@"contents"];
    
    _uploader = [[IFlyDataUploader alloc] init];
    [_uploader setParameter:@"uup" forKey:[IFlySpeechConstant SUBJECT]];
    [_uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:userwords];
    
    [_uploader uploadDataWithCompletionHandler:
     ^(NSString * grammerID, IFlySpeechError *error)
    {
        if (error.errorCode == 0) {
            //上传成功
            [ToastView showToastWithMessage:NSLocalizedString(@"上传成功", nil) duration:2];
        } else {
            [ToastView showToastWithMessage:[NSString stringWithFormat:@"%@:%d", NSLocalizedString(@"上传失败", nil), error.errorCode] duration:2];
        }
    } name:@"userwords" data:[iFlyUserWords toString]];
}

/**
 * 开始语音识别
 */
- (void)startListening :(NSDictionary*) args{
    if(_iFlySpeechRecognizer == nil){
        [self initRecognizer : (NSDictionary*) args];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //Set microphone as audi`o source
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //Set result type
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    BOOL ret =  [_iFlySpeechRecognizer startListening];
    if(!ret){
        NSLog(@"启动识别服务失败,请稍后重试");
    }
}

/**
 * 音频流识别
 */
-(void) audioRecognizer:(NSDictionary*) args{
    if(_iFlySpeechRecognizer == nil){
        [self initRecognizer:args];
    }

    [_iFlySpeechRecognizer cancel];

    [_iFlySpeechRecognizer setDelegate:self];
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];    //设置音频为外部来源
    
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    
    
    
    if (ret) {
        
        NSString *pcmFileName = args[@"path"];
        NSString* key = [flutterPluginRegistrar lookupKeyForAsset:[@"assets/" stringByAppendingString:pcmFileName]];
        pcmFilePath = [[NSBundle mainBundle] pathForResource:key ofType:nil];


       
        //set the category of AVAudioSession
        [IFlyAudioSession initRecordingAudioSession];

        _pcmRecorder.delegate = self;

        //start recording
        BOOL ret = [_pcmRecorder start];
        NSLog(@"%s[OUT],录制成功 ret=%d",__func__,ret);
    } else {
        NSLog(@"%s[OUT],录制失败",__func__);
    }
}



/**
 * 初始化识别器
 */
-(void) initRecognizer :(NSDictionary*) args{
    NSLog(@"%s",__func__);
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    }
        
    //清除参数
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
    //设置听写模式
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    _iFlySpeechRecognizer.delegate = self;
        
    if (_iFlySpeechRecognizer != nil) {
        NSString *language = args[@"language"];
        NSString *vadBos = args[@"vadBos"];
        NSString *vadEos = args[@"vadEos"];
        NSString *ptt = args[@"ptt"];
        
        IATConfig *instance = [IATConfig sharedInstance];
        if (language == nil){
            language = @"zh_cn";
        }
        if(vadBos == nil){
            vadBos = instance.vadBos;
        }
        if(vadEos == nil){
            vadEos = instance.vadEos;
        }
        if(ptt == nil){
            ptt = instance.dot;
        }
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点检测时间
        [_iFlySpeechRecognizer setParameter:vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点检测时间
        [_iFlySpeechRecognizer setParameter:vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //设置网络超时时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置语言
        [_iflyRecognizerView setParameter:language forKey:[IFlySpeechConstant LANGUAGE]];
        //设置标点
        [_iflyRecognizerView setParameter:ptt forKey:[IFlySpeechConstant ASR_PTT]];
    }
    if (_pcmRecorder == nil){
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    _pcmRecorder.delegate = self;
    [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    [_pcmRecorder setSaveAudioPath:nil];    //not save the
}

/**
 * 语音识别结果处理
 */
-(void) handleResult:(NSArray *)results isLast:(BOOL)isLast{
    if (results != nil){
        NSMutableString *resultString = [[NSMutableString alloc] init];
        NSDictionary *dic = [results objectAtIndex:0];
            
        for (NSString *key in dic) {
            [resultString appendFormat:@"%@",key];
        }
        
        NSString * resultFromJson =  nil;
            
        resultFromJson = [ISRDataHelper stringFromJson:resultString];
            
        NSLog(@"resultFromJson=%@",resultFromJson);
        
        NSMutableDictionary *resdic = [NSMutableDictionary dictionaryWithCapacity:1];
        [resdic setObject: [NSNumber numberWithBool:YES] forKey:@"success"];
        [resdic setObject: [NSNumber numberWithBool:isLast] forKey:@"isLast"];
        [resdic setObject:resultFromJson forKey:@"result"];
        [resdic setObject:type forKey:@"type"];
        [streamInstance streamHandler].eventSink(resdic);
    }
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    [self handleResult:results isLast:isLast];
}

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"%s",__func__);
    NSString *text ;
    if (error.errorCode != 0 ) {
        text = [NSString stringWithFormat:@"Error：%d %@", error.errorCode,error.errorDesc];
       
        NSMutableDictionary *resdic = [NSMutableDictionary dictionaryWithCapacity:1];
        [resdic setObject: [NSNumber numberWithBool:NO] forKey:@"success"];
        [resdic setObject:@"" forKey:@"result"];
        [resdic setObject:type forKey:@"type"];
        [resdic setObject:text forKey:@"error"];
        [streamInstance streamHandler].eventSink(resdic);

    }
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    [self handleResult:resultArray isLast:isLast];
}

//会话取消回调
- (void) onCancel{
    NSLog(@"error");
    type = @"";
}

/*!
 *  音量回调0-30
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    NSLog(@"volume:%d",volume);
}

/*!
 *  开始语音 */
- (void)onBeginOfSpeech {
    NSLog(@"onBeginOfSpeech");
}

/*!
 *  结束语音
 */
- (void)onEndOfSpeech {
        NSLog(@"onEndOfSpeech");
    type = @"";
    [_pcmRecorder stop];
}


- (void)onIFlyRecorderBuffer:(const void *)buffer bufferSize:(int)size {
//    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    //写入音频数据
    NSData *data = [NSData dataWithContentsOfFile:pcmFilePath];    //从文件中读取音频
    int ret = [self.iFlySpeechRecognizer writeAudio:data];//写入音频，让SDK识别。建议将音频数据分段写入。
    
//    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret) {
        [self.iFlySpeechRecognizer stopListening];
    }
}

- (void)onIFlyRecorderError:(IFlyPcmRecorder *)recoder theError:(int)error {
    NSLog(@"error");
}

@end
