import Flutter
import UIKit

public class SpeechXfPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "speech_xf", binaryMessenger: registrar.messenger())
    let instance = SpeechXfPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method == "init"{
          let data:Optional<Dictionary> = call.arguments as? Dictionary<String, String>
          if data != nil && data!["appId"] != nil {
              let initString = String(format: "appid=%@", data!["appId"]!)
              print(">>>>>>>>>>>\(initString)")
              
              
              
          }
      }
  }
}
