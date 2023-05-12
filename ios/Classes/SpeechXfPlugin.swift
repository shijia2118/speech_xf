import Flutter
import UIKit


public class SpeechXfPlugin: NSObject, FlutterPlugin, IFlyRecognizerViewDelegate {
   
    
   
    
    var iflyRecognizerView:IFlyRecognizerView? = nil //带界面的识别对象
    let uiView = UIView()
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xf_speech_to_text", binaryMessenger: registrar.messenger())
    let instance = SpeechXfPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method == "init"{
          //初始化sdk
          let data:Optional<Dictionary> = call.arguments as? Dictionary<String, String>
          if data != nil && data!["appId"] != nil {
              let initString = "appid=\(String(describing: data!["appId"]))"
              IFlySpeechUtility.createUtility(initString)
          }
      } else if call.method == "open_native_ui_dialog"{
          let data:Optional<Dictionary> = call.arguments as? Dictionary<String, String>
          var isDynamicCorrection:Bool? = data?["isDynamicCorrection"] as? Bool
          var language:String? = data?["language"] as? String
          var vadBos = data?["vadBos"] as? String
          var vadEos = data?["vadEos"] as? String
          var ppt = data?["ppt"] as? String
          
          if language == nil {
              language = "zh_cn"
          }
          if vadBos == nil {
              vadBos = "5000"
          }
          if vadEos == nil {
              vadEos = "1800"
          }
          if ppt == nil {
              ppt = "1"
          }
          

          //显示SDK内置对话框
          if iflyRecognizerView == nil {
              // UI显示居中
              iflyRecognizerView = IFlyRecognizerView(center: self.uiView.center)
          }

          iflyRecognizerView!.setParameter("", forKey: IFlySpeechConstant.params())
          // 设置听写模式
          iflyRecognizerView!.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
          
          // 动态修正(仅支持中文)
          if isDynamicCorrection != nil && isDynamicCorrection! && language == "zh_cn" {
              iflyRecognizerView!.setParameter("dwa", forKey: "wpgs")
          }
          
          iflyRecognizerView!.delegate = self

          if iflyRecognizerView != nil {
              // 设置最长录音时间
              iflyRecognizerView!.setParameter("60000", forKey: IFlySpeechConstant.speech_TIMEOUT())
              // Set VAD timeout of end of speech (EOS)
              iflyRecognizerView!.setParameter(vadEos, forKey: IFlySpeechConstant.vad_EOS())
              // 前端点超时
              iflyRecognizerView!.setParameter(vadBos, forKey: IFlySpeechConstant.vad_BOS())
              // 网络超时
              iflyRecognizerView!.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
              // 设置语言
              iflyRecognizerView!.setParameter(language, forKey: IFlySpeechConstant.language())
              // 设置标点
              iflyRecognizerView!.setParameter(ppt, forKey: IFlySpeechConstant.asr_PTT())
              // 开启语音识别
              iflyRecognizerView!.start()
          }

      }
  }
    
    /// 有UI识别回调
    public func onResult(_ resultArray: [Any]!, isLast: Bool) {
        if isLast {
            print(">>>>>>>>>\(String(describing: resultArray))")
        }
    }
    
    public func onCompleted(_ error: IFlySpeechError!) {
        
        print(">>>>>>>>>\(String(describing: error))")

    }
    
  
    
    
    
}
