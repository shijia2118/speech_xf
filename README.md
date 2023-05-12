# speech_xf

该插件集成了讯飞语音识别功能。支持Android和IOS平台

### 官网注册
* 1.注册账号
  请参阅[注册讯飞账号](https://console.xfyun.cn/)以获取更多信息。

* 2.创建应用并获取AppID

* 3.分别下载Android和IOS端的SDK


### Android端配置

* 1.在项目的android/app/main目录下新建Jnilibs目录，并拷贝libmsc.so。

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

### IOS端配置(真机测试，不支持模拟器)
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

### 使用
* 1.导入
* 2.初始化
