#import "SpeechXfPlugin.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "ToastView.h"
#import "TTSConfig.h"
#import "IATConfig.h"
#import "SpeechTtsStream.h"
#import "SpeechXfStream.h"
#import "SpeechVolumeStream.h"

@implementation SpeechXfPlugin

SpeechXfStream *streamInstance;
SpeechTtsStream *ttsStreamInstance;
SpeechVolumeStream *volumeStreamInstance;


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
  
    FlutterEventChannel *iatEventChanel = [FlutterEventChannel eventChannelWithName:@"xf_speech_to_text_stream" binaryMessenger:[registrar messenger]];
    streamInstance = [SpeechXfStream sharedInstance];
    [iatEventChanel setStreamHandler:[streamInstance iatStreamHandler]];
    
    FlutterEventChannel *ttsEventChanel = [FlutterEventChannel eventChannelWithName:@"xf_text_to_speech_stream" binaryMessenger:[registrar messenger]];
    ttsStreamInstance = [SpeechTtsStream sharedInstance];
    [ttsEventChanel setStreamHandler:[ttsStreamInstance ttsStreamHandler]];
    
    FlutterEventChannel *volumeEventChanel = [FlutterEventChannel eventChannelWithName:@"volume_stream" binaryMessenger:[registrar messenger]];
    volumeStreamInstance = [SpeechVolumeStream sharedInstance];
    [volumeEventChanel setStreamHandler:[volumeStreamInstance volumeStreamHandler]];
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
    } else if([@"start_speaking" isEqualToString:call.method]){
        // 开始语音合成
        type = @"3";
        [self startSpeaking:call.arguments];
    } else if([@"stop_speaking" isEqualToString:call.method]){
        // 取消语音合成
        [self stopSpeaking];
    } else if([@"pause_speaking" isEqualToString:call.method]){
        // 暂停语音合成
        [self pauseSpeaking];
    } else if([@"resume_speaking" isEqualToString:call.method]){
        // 继续语音合成
        [self resumeSpeaking];
    } else if([@"is_speaking" isEqualToString:call.method]) {
        // 获取播放状态
        if(_iFlySpeechSynthesizer != nil) {
            BOOL isSpeaking = [_iFlySpeechSynthesizer isSpeaking];
            if(isSpeaking) {
                result([NSNumber numberWithBool:YES]);
            } else {
                result([NSNumber numberWithBool:NO]);
            }
        }
    } else if([@"tts_destroy" isEqualToString:call.method ]){
        if([_iFlySpeechSynthesizer isSpeaking]){
            [_iFlySpeechSynthesizer stopSpeaking];
        }
        _iFlySpeechSynthesizer = nil;
        type = @"";
    } else if([@"iat_destroy" isEqualToString:call.method ]){
        [_iflyRecognizerView cancel];
        [_iFlySpeechRecognizer destroy];
        type = @"";
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
    
    //开始语音识别
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    if (ret) {
        //从flutter端获取音频文件
        NSString *pcmFileName = args[@"path"];
        NSString* key = [flutterPluginRegistrar lookupKeyForAsset:[@"assets/" stringByAppendingString:pcmFileName]];
        pcmFilePath = [[NSBundle mainBundle] pathForResource:key ofType:nil];

        //初始化录音环境,主要用于识别录音器。
        [IFlyAudioSession initRecordingAudioSession];

        _pcmRecorder.delegate = self;

        //开始录制
        BOOL pcmRet = [_pcmRecorder start];
        NSLog(@"%s[OUT],Success,Recorder ret=%d",__func__,pcmRet);
    } else {
        NSLog(@"%s[OUT],语音识别失败",__func__);
    }
}



/**
 * 初始化语音听写识别器
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
 * 开始语音合成
 */
- (void) startSpeaking:(NSDictionary*) args {
    [self initSynthesizer:args];
    NSString *content = args[@"content"];
    [_iFlySpeechSynthesizer startSpeaking:content];
}

/**
 * 取消语音合成
 */
- (void) stopSpeaking {
    if(_iFlySpeechSynthesizer != nil){
        [_iFlySpeechSynthesizer stopSpeaking];
    }
}

/**
 * 暂停语音合成
 */
- (void) pauseSpeaking {
    if(_iFlySpeechSynthesizer != nil){
        [_iFlySpeechSynthesizer pauseSpeaking];
    }
}

/**
 * 继续语音合成
 */
- (void) resumeSpeaking {
    if(_iFlySpeechSynthesizer != nil){
        [_iFlySpeechSynthesizer resumeSpeaking];
    }
}




/**
 * 初始化语音合成识别器
 */
- (void)initSynthesizer:(NSDictionary*) args {
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    NSString *volume = args[@"volume"];
    NSString *pitch = args[@"pitch"];
    NSString *speed = args[@"speed"];
    NSString *voiceName = args[@"voiceName"];

    //TTS单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    [_iFlySpeechSynthesizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD] forKey:[IFlySpeechConstant ENGINE_TYPE]];

    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:volume forKey:[IFlySpeechConstant VOLUME]];
    
    //音调，范围（0~100）
    [_iFlySpeechSynthesizer setParameter:pitch forKey:[IFlySpeechConstant PITCH]];
    
    //语速
    [_iFlySpeechSynthesizer setParameter:speed forKey:[IFlySpeechConstant SPEED]];
    
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:voiceName forKey: [IFlySpeechConstant VOICE_NAME]];
    NSLog(@"发音人：%@",instance.vcnName);
    
    //合成、识别、唤醒、评测、声纹等业务采样率。
    [_iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: nil];

    //输入文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
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
        [streamInstance iatStreamHandler].iatEventSink(resdic);
    }
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    [self handleResult:results isLast:isLast];
}

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"%s",__func__);
    NSString *text ;
    if (error.errorCode != 0 ) {
        if([type isEqual: @"3"]){
            [ToastView showToastWithMessage:error.description duration:2];
            return;
        }
        text = [NSString stringWithFormat:@"Error：%d %@", error.errorCode,error.errorDesc];
       
        NSMutableDictionary *resdic = [NSMutableDictionary dictionaryWithCapacity:1];
        [resdic setObject: [NSNumber numberWithBool:NO] forKey:@"success"];
        [resdic setObject:@"" forKey:@"result"];
        [resdic setObject:text forKey:@"error"];
        [streamInstance iatStreamHandler].iatEventSink(resdic);

    }else{
        if([type isEqual:@"3"]){
            if(ttsStreamInstance != nil){
                [ttsStreamInstance ttsStreamHandler].ttsEventSink(@"onCompleted");
            }
        }
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
- (void) onVolumeChanged: (int)volume {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@(volume) forKey:@"volume"]; // 使用@(volume)将整型转换为NSNumber对象
    [volumeStreamInstance volumeStreamHandler].volumeEventSink(dictionary);
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

/**
 * 开始语音合成
 */
- (void)onSpeakBegin {
    NSLog(@"===============>开始语音合成");
}

/**
 * 缓冲进度
 */
- (void)onBufferProgress:(int)progress message:(NSString *)msg{
    
}

/**
 * 播放进度
 */
- (void)onSpeakProgress:(int)progress beginPos:(int)beginPos endPos:(int)endPos{
//    NSLog(@"speak progress %2d%%, beginPos=%d, endPos=%d", progress,beginPos,endPos);
}




- (void)onIFlyRecorderBuffer:(const void *)buffer bufferSize:(int)size {
    
    NSData *fullAudioData = [NSData dataWithContentsOfFile:pcmFilePath]; // 从文件中读取完整的音频数据
    NSInteger totalLength = fullAudioData.length;
    NSInteger segmentLength = 1024; // 定义每个片段的长度，这里使用 1024 字节作为示例

    for (NSInteger offset = 0; offset < totalLength; offset += segmentLength) {
        NSInteger length = MIN(segmentLength, totalLength - offset);
        NSData *segmentData = [fullAudioData subdataWithRange:NSMakeRange(offset, length)];
        [self.iFlySpeechRecognizer writeAudio:segmentData];
    }

    // 音频数据写入结束时调用 stopListening 方法
    [self.iFlySpeechRecognizer stopListening];

}

- (void)onIFlyRecorderError:(IFlyPcmRecorder *)recoder theError:(int)error {
    NSLog(@"error");
}

@end
