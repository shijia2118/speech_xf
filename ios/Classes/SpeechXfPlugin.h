#import <Flutter/Flutter.h>
#import "IFlyMSC/IFlyMSC.h"

@interface SpeechXfPlugin : NSObject<FlutterPlugin,IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate>

@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer; //不带UI的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView; //带UI的识别对象


@end
