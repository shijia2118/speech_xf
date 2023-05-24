#import <Flutter/Flutter.h>
#import "IFlyMSC/IFlyMSC.h"

@interface SpeechXfPlugin : NSObject<FlutterPlugin,IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,IFlyPcmRecorderDelegate,IFlySpeechSynthesizerDelegate>

@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer; //不带UI的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView; //带UI的识别对象

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音录制对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//热词上传对象

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer; //语音合成对象

@end
