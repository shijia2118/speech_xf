# speech_xf

该插件集成了讯飞语音识别功能,支持Android和IOS平台

### **官网注册**
* 1.注册账号
  请参阅[注册讯飞账号](https://console.xfyun.cn/)以获取更多信息。

* 2.创建应用并获取AppID

* 3.分别下载Android和IOS端的SDK


### **Android端配置**

* 1.在项目的android/app/main目录下新建Jnilibs目录，并将demo/libs下的arm64-v8a和armeabi-v7a两个目录拷贝进去。

* 2.添加用户权限
  在工程 AndroidManifest.xml 文件中添加如下权限

```XML
<!--连接网络权限，用于执行云端语音能力 -->
<uses-permission android:name="android.permission.INTERNET"/>
<!--获取手机录音机使用权限，听写、识别、语义理解需要用到此权限 -->
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<!--读取网络信息状态 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<!--获取当前wifi状态 -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<!--允许程序改变网络连接状态 -->
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/>
<!--读取手机信息权限 -->
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<!--读取联系人权限，上传联系人需要用到此权限 -->
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<!--外存储写权限，构建语法需要用到此权限 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<!--外存储读权限，构建语法需要用到此权限 -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<!--配置权限，用来记录应用配置信息 -->
<uses-permission android:name="android.permission.WRITE_SETTINGS"/>
<!--手机定位信息，用来为语义等功能提供定位，提供更精准的服务-->
<!--定位信息是敏感信息，可通过Setting.setLocationEnable(false)关闭定位请求 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<!--如需使用人脸识别，还要添加：摄像头权限，拍照需要用到 -->
<uses-permission android:name="android.permission.CAMERA" />
```

* 3.添加混淆
  如需在打包或者生成APK的时候进行混淆，请在proguard.pro中添加如下代码：

```ProGuard
-keep class com.iflytek.**{*;}
-keepattributes Signature
```

### **IOS端配置**
1.在info.plist中添加以下权限
```
<key>NSMicrophoneUsageDescription</key>
<string></string>
<key>NSLocationUsageDescription</key>
<string></string>
<key>NSLocationAlwaysUsageDescription</key>
<string></string>
<key>NSContactsUsageDescription</key>
<string></string>
```

**注：建议真机测试。如果非要用模拟器，则使用Xcode打开项目。在Build Settings中找到Excluded Architectures,在debug中添加支持arm64架构。**

### **添加依赖**
```
dependencies:
  speech_xf: ^0.0.5

```

### **使用**

* 1.初始化
```
  void initSdk() async {
    await SpeechXf.init('这里是你在讯飞平台申请的appid');
  }
  ```

  * 2.使用内置界面
  ```
  await SpeechXf.openNativeUIDialog(
    isDynamicCorrection: true,
    language: settingResult['language'],
    vadBos: settingResult['vadBos'],
    vadEos: settingResult['vadEos'],
    ptt: settingResult['ptt'],
  );
  ```

  * 3.无界面语音识别
  ```
  await SpeechXf.startListening(
    isDynamicCorrection: false,
    language: settingResult['language'],
    vadBos: settingResult['vadBos'],
    vadEos: settingResult['vadEos'],
    ptt: settingResult['ptt'],
  );
  ```

  * 4.停止
  ```
  await SpeechXf.stopListening();
  ```

  * 5.取消
  ```
   await SpeechXf.cancelListening();
  ```

  * 6.语音听写结果监听
  ```
  SpeechXf().onResult().listen((event) {
    if (event.error != null) {
      showToast(event.error!, position: ToastPosition.bottom);
    } else {
      if (event.result != null) {
        speechController.text = speechController.text + event.result!;
      }
      if (event.isLast == true) {
        showToast('结束说话...', position: ToastPosition.bottom);
      }
    }
  });
  ```

  * 7.上传用户热词
  ```
  await SpeechXf.uploadUserWords(userWords);
  ```

  * 8.音频流识别
  ```
  await SpeechXf.audioRecognizer('iattest.wav');
  ```

  * 9.开始语音合成
  ```
  await SpeechXf.startSpeaking();
  ```

  * 10.取消语音合成
  ```
  await SpeechXf.stopSpeaking();
  ```

  * 11.暂停语音合成
  ```
  await SpeechXf.pauseSpeaking();
  ```

  * 12.继续语音合成
  ```
  await SpeechXf.resumeSpeaking();
  ```

  * 13.循环播放
  ```
  SpeechXf().onCompeleted().listen((event) async {
      await startSpeaking();
    });
  ```

  * 14.销毁语音合成器
  ```
  SpeechXf.ttsDestroy();
  ```

  * 15.销毁语音识别器
  ```
  SpeechXf.iatDestroy();
  ```
