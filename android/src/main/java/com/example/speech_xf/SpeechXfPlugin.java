package com.example.speech_xf;

import android.content.Context;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.example.speech_xf.Utils.JsonParser;
import com.iflytek.cloud.ErrorCode;
import com.iflytek.cloud.InitListener;
import com.iflytek.cloud.LexiconListener;
import com.iflytek.cloud.RecognizerListener;
import com.iflytek.cloud.RecognizerResult;
import com.iflytek.cloud.Setting;
import com.iflytek.cloud.SpeechConstant;
import com.iflytek.cloud.SpeechError;
import com.iflytek.cloud.SpeechRecognizer;
import com.iflytek.cloud.SpeechUtility;
import com.iflytek.cloud.ui.RecognizerDialog;
import com.iflytek.cloud.ui.RecognizerDialogListener;


import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Objects;

import io.flutter.BuildConfig;
import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.FlutterMain;

/** SpeechXfPlugin */
public class SpeechXfPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware ,EventChannel.StreamHandler{

  private MethodChannel channel;
  public static EventChannel.EventSink mEventSink = null;

  private Context mContext;

  private final String TAG = "============>xf_log:";
  private SpeechRecognizer mIat;
  private Toast mToast;
  int ret = 0;// 函数调用返回值
  String language = "zh_cn";
  String vadBos = "5000";
  String vadEos = "1800";
  String ptt = "1";
  Boolean isDynamicCorrection = false;

  private final HashMap<String, String> mIatResults = new LinkedHashMap<>();

  String type = "";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "xf_speech_to_text");
    channel.setMethodCallHandler(this);

    EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "xf_speech_to_text_stream");
    eventChannel.setStreamHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "init":
        /// 初始化SDK
        Setting.setShowLog(BuildConfig.DEBUG); //日志
        String appId = call.argument("appId");
        SpeechUtility.createUtility(mContext, SpeechConstant.APPID + "=" + appId);
        break;
      case "open_native_ui_dialog":
        type = "1";
        mIatResults.clear();
        /// 显示SDK内置对话框
        if(mIat!=null){
          mIat.setParameter(SpeechConstant.PARAMS, null);
        }
        RecognizerDialog mIatDialog = new RecognizerDialog(mContext, mInitListener);
        // 是否开启动态修正
        // 注意：使用动态修正功能需到控制台-流式听写-高级功能处点击开通；
        // 动态修正仅支持中文,默认不开启。
        // 设置语言
        language = call.argument("language");
        mIatDialog.setParameter(SpeechConstant.LANGUAGE,language);
        isDynamicCorrection = call.argument("isDynamicCorrection");
        if (isDynamicCorrection != null && isDynamicCorrection&& Objects.equals(language, "zh_cn")) {
          mIatDialog.setParameter("dwa", "wpgs");
        }
        //前端点超时
        vadBos = call.argument("vadBos");
        mIatDialog.setParameter(SpeechConstant.VAD_BOS,vadBos);
        // 后端点超时
        vadEos = call.argument("vadEos");
        mIatDialog.setParameter(SpeechConstant.VAD_EOS,vadEos);
        // 标点符号 0-无标点 1-有标点
        ptt = call.argument("ptt");
        mIatDialog.setParameter(SpeechConstant.ASR_PTT,ptt);

        mIatDialog.setListener(mRecognizerDialogListener);
        mIatDialog.show();
        break;
      case "start_listening":
        type = "2";
        mIatResults.clear();

        /// 开始听写(无UI)
        mIat = SpeechRecognizer.createRecognizer(mContext, mInitListener);
        isDynamicCorrection = call.argument("isDynamicCorrection");
        if (isDynamicCorrection == null) {
          isDynamicCorrection = false;
        }
        language = call.argument("language");
        vadBos = call.argument("vadBos");
        vadEos = call.argument("vadEos");
        ptt = call.argument("ptt");
        setParam();
        // 不显示听写对话框
        ret = mIat.startListening(mRecognizerListener);
        if (ret != ErrorCode.SUCCESS) {
          showTip("听写失败,错误码：" + ret + ",请点击网址https://www.xfyun.cn/document/error-code查询解决方案");
        }
        break;
      case "stop_listening":
        /// 暂停听写
        if(mIat!=null)
        mIat.stopListening();
        break;
      case "cancel_listening":
        /// 取消听写
        if(mIat!=null)
          mIat.cancel();
        break;
      case "upload_user_words":
        /// 上传用户级词表
        /// 与应用级热词相对。
        /// 一般上传后10分钟左右生效，影响的范围是，当前 appId 应用的当前设备——即同一应用，不同设备里上传的热词互不干扰；
        /// 同一设备，不同appId的应用上传的热词互不干扰。
        if(mIat == null){
          mIat = SpeechRecognizer.createRecognizer(mContext, mInitListener);
        }
        String contents = call.argument("contents");
        // 指定引擎类型
        mIat.setParameter(SpeechConstant.ENGINE_TYPE, SpeechConstant.TYPE_CLOUD);
        mIat.setParameter(SpeechConstant.TEXT_ENCODING, "utf-8");
        ret = mIat.updateLexicon("userword", contents, mLexiconListener);
        if (ret != ErrorCode.SUCCESS)
          showTip("上传热词失败,错误码：" + ret + ",请点击网址https://www.xfyun.cn/document/error-code查询解决方案");
        break;
      case "audio_recognizer":
        /// 音频流识别
        mIatResults.clear();
        if(mIat == null){
          mIat = SpeechRecognizer.createRecognizer(mContext, mInitListener);
        }
        // 设置参数
        setParam();
        // 设置音频来源为外部文件
        mIat.setParameter(SpeechConstant.AUDIO_SOURCE, "-1");
        ret = mIat.startListening(mRecognizerListener);
        if (ret != ErrorCode.SUCCESS) {
          showTip("识别失败,错误码：" + ret + ",请点击网址https://www.xfyun.cn/document/error-code查询解决方案");
          return;
        }
        try {
          String fileName = call.argument("path");
          String key = FlutterMain.getLookupKeyForAsset("assets/"+fileName); // 获取 assets 中文件的 key
          InputStream open = mContext.getAssets().open(key);
          byte[] buff = new byte[1280];
          while (open.available() > 0) {
            int read = open.read(buff);
            mIat.writeAudio(buff, 0, read);
          }
          mIat.stopListening();
        } catch (IOException e) {
          mIat.cancel();
          showTip("读取音频流失败");
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * 初始化监听器。
   */
  private final InitListener mInitListener = new InitListener() {

    @Override
    public void onInit(int code) {
      Log.d(TAG, "SpeechRecognizer init() code = " + code);
      if (code != ErrorCode.SUCCESS) {
        Toast.makeText(
                mContext,
                "初始化失败，错误码：" + code + ",请点击网址https://www.xfyun.cn/document/error-code查询解决方案",
                Toast.LENGTH_SHORT
                ).show();
      }
    }
  };

  /**
   * 听写UI监听器
   */
  private final RecognizerDialogListener mRecognizerDialogListener = new RecognizerDialogListener() {
    // 返回结果
    public void onResult(RecognizerResult results, boolean isLast) {
      String recognizerResult =  getRecognizerResult(results);
      if(isLast){
        HashMap<String,Object> map =new HashMap<>();
        map.put("result", recognizerResult);
        map.put("success", true);
        map.put("isLast", true);
        map.put("type", type);
        mEventSink.success(map);
      }
    }

    // 识别回调错误
    public void onError(SpeechError error) {
      HashMap<String,Object> map = new HashMap<>();
      map.put("error", error.getPlainDescription(true));
      map.put("success", false);
      map.put("type", type);
      mEventSink.success(map);
    }
  };

  /**
   * 听写监听器。
   */
  private final RecognizerListener mRecognizerListener = new RecognizerListener() {

    @Override
    public void onBeginOfSpeech() {
      // 此回调表示：sdk内部录音机已经准备好了，用户可以开始语音输入
//        showTip("开始说话");
    }

    @Override
    public void onError(SpeechError error) {
      HashMap<String,Object> map = new HashMap<>();
      map.put("error", error.getPlainDescription(true));
      map.put("success", false);
      map.put("type", type);
      mEventSink.success(map);
    }

    @Override
    public void onEndOfSpeech() {
      // 此回调表示：检测到了语音的尾端点，已经进入识别过程，不再接受语音输入
//        showTip("结束说话");
    }

    @Override
    public void onResult(RecognizerResult results, boolean isLast) {
      String recognizerResult =  getRecognizerResult(results);
      if(isLast){
        HashMap<String,Object> map =new HashMap<>();
        map.put("result",recognizerResult);
        map.put("success", true);
        map.put("isLast", isLast);
        map.put("type", type);
        mEventSink.success(map);
      }
    }

    @Override
    public void onVolumeChanged(int volume, byte[] data) {
//        showTip("当前正在说话，音量大小 = " + volume + " 返回音频数据 = " + data.length);
    }

    @Override
    public void onEvent(int eventType, int arg1, int arg2, Bundle obj) {
    }
  };

  /**
   * 读取动态修正返回结果示例代码
   * @param recognizerResult:转写后的字符串
   */
  private String getRecognizerResult(RecognizerResult recognizerResult) {
    String text = JsonParser.parseIatResult(recognizerResult.getResultString());

    String sn = null;
    String pgs = null;
    String rg = null;
    // 读取json结果中的sn字段
    try {
      JSONObject resultJson = new JSONObject(recognizerResult.getResultString());
      sn = resultJson.optString("sn");
      pgs = resultJson.optString("pgs");
      rg = resultJson.optString("rg");
    } catch (JSONException e) {
      e.printStackTrace();
    }
    //如果pgs是rpl就在已有的结果中删除掉要覆盖的sn部分
    if (pgs != null && pgs.equals("rpl")) {
      String[] strings = rg.replace("[", "").replace("]", "").split(",");
      int begin = Integer.parseInt(strings[0]);
      int end = Integer.parseInt(strings[1]);
      for (int i = begin; i <= end; i++) {
        mIatResults.remove(i+"");
      }
    }

    mIatResults.put(sn, text);
    StringBuilder resultBuffer = new StringBuilder();
    for (String key : mIatResults.keySet()) {
      resultBuffer.append(mIatResults.get(key));
    }
    Log.d(TAG,resultBuffer.toString());
    return resultBuffer.toString();
  }

  /**
   * 上传联系人/词表监听器。
   */
  private final LexiconListener mLexiconListener = (lexiconId, error) -> {
    if (error != null) {
      showTip(error.toString());
    } else {
      showTip("上传成功");
    }
  };


  private void showTip(final String str) {
    if (mToast != null) {
      mToast.cancel();
    }
    mToast = Toast.makeText(mContext, str, Toast.LENGTH_SHORT);
    mToast.show();
  }

  /**
   * 参数设置
   */
  public void setParam() {
    // 清空参数
    mIat.setParameter(SpeechConstant.PARAMS, null);
    // 设置听写引擎
    mIat.setParameter(SpeechConstant.ENGINE_TYPE, SpeechConstant.TYPE_CLOUD);
    // 设置返回结果格式
    mIat.setParameter(SpeechConstant.RESULT_TYPE, "json");
    // 设置动态修正
    mIat.setParameter("dwa", "wpgs");
    // 设置语言
    mIat.setParameter(SpeechConstant.LANGUAGE, language);

    // 设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
    mIat.setParameter(SpeechConstant.VAD_BOS, vadBos);

    // 设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入， 自动停止录音
    mIat.setParameter(SpeechConstant.VAD_EOS, vadEos);

    // 设置标点符号,设置为"0"返回结果无标点,设置为"1"返回结果有标点
    mIat.setParameter(SpeechConstant.ASR_PTT, ptt);

    // 设置音频保存路径，保存音频格式支持pcm、wav.
    mIat.setParameter(SpeechConstant.AUDIO_FORMAT, "wav");
    String path = mContext.getExternalFilesDir("msc").getAbsolutePath() + "/iat.wav";
    Log.d(TAG,"path=="+path);
    mIat.setParameter(SpeechConstant.ASR_AUDIO_PATH,path);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    /// 注意：上下文context须在此获取，否则无法显示自带UI.
    mContext = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    mEventSink = events;
  }

  @Override
  public void onCancel(Object arguments) {

  }
}