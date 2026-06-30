#import <Flutter/Flutter.h>

@class IFlySpeechRecognizer;
@class IFlyRecognizerView;
@class IFlyPcmRecorder;
@class IFlyDataUploader;
@class IFlySpeechSynthesizer;
@protocol IFlySpeechRecognizerDelegate;
@protocol IFlyRecognizerViewDelegate;
@protocol IFlyPcmRecorderDelegate;
@protocol IFlySpeechSynthesizerDelegate;

@interface SpeechXfPlugin : NSObject<FlutterPlugin,IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,IFlyPcmRecorderDelegate,IFlySpeechSynthesizerDelegate>

@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer; //不带UI的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView; //带UI的识别对象

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音录制对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//热词上传对象

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer; //语音合成对象

@end
