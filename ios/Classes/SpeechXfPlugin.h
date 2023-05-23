#import <Flutter/Flutter.h>
#import "IFlyMSC/IFlyMSC.h"

@interface SpeechXfPlugin : NSObject<FlutterPlugin,IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,IFlyPcmRecorderDelegate>

@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer; //不带UI的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView; //带UI的识别对象

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//PCM Recorder to be used to
@property (nonatomic, strong) IFlyDataUploader *uploader;//upload control



@end
