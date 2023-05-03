package com.example.speech_xf;

import android.content.Context;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.example.speech_xf.Utils.JsonParser;
import com.iflytek.cloud.ErrorCode;
import com.iflytek.cloud.InitListener;
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

import java.util.HashMap;
import java.util.LinkedHashMap;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SpeechXfPlugin */
public class SpeechXfPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  private MethodChannel channel;
  private Context mContext;
  private final String TAG = "============>xf_log:";
  private final HashMap<String, String> mIatResults = new LinkedHashMap<>(); // 用HashMap存储听写结果
  private SpeechRecognizer mIat;
  private Toast mToast;
  int ret = 0;// 函数调用返回值

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "xf_speech_to_text");
    channel.setMethodCallHandler(this);
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
        /// 显示SDK内置对话框
        RecognizerDialog mIatDialog = new RecognizerDialog(mContext, mInitListener);
        // 是否开启动态修正
        // 注意：使用动态修正功能需到控制台-流式听写-高级功能处点击开通；
        // 动态修正仅支持中文,默认不开启。
        Boolean isDynamicCorrection = call.argument("isDynamicCorrection");
        if (isDynamicCorrection != null && isDynamicCorrection) {
          mIatDialog.setParameter("dwa", "wpgs");
        }
        // 设置语言
        String language = call.argument("language");
        mIatDialog.setParameter(SpeechConstant.LANGUAGE,language);
        //前端点超时
        String vadBos = call.argument("vadBos");
        mIatDialog.setParameter(SpeechConstant.VAD_BOS,vadBos);
        // 后端点超时
        String vadEos = call.argument("vadEos");
        mIatDialog.setParameter(SpeechConstant.VAD_EOS,vadEos);
        // 标点符号 0-无标点 1-有标点
        String ptt = call.argument("ptt");
        mIatDialog.setParameter(SpeechConstant.ASR_PTT,ptt);

        Log.d(TAG,"language:"+language+"\n"+"vadBos:"+vadBos+"\n"+"vadEos:"+vadEos+"\n"+"ptt:"+ptt);
        mIatResults.clear();
        mIatDialog.setListener(mRecognizerDialogListener(result));
        mIatDialog.show();
        showTip("请开始说话...");
        break;
      case "start_listening":
        /// 开始听写(无UI)
        mIat = SpeechRecognizer.createRecognizer(mContext, mInitListener);
        isDynamicCorrection = call.argument("isDynamicCorrection");
        if (isDynamicCorrection != null && isDynamicCorrection) {
          mIat.setParameter("dwa", "wpgs");
        }
        // 设置语言
        language = call.argument("language");
        mIat.setParameter(SpeechConstant.LANGUAGE,language);
        //前端点超时
        vadBos = call.argument("vadBos");
        mIat.setParameter(SpeechConstant.VAD_BOS,vadBos);
        // 后端点超时
        vadEos = call.argument("vadEos");
        mIat.setParameter(SpeechConstant.VAD_EOS,vadEos);
        // 标点符号 0-无标点 1-有标点
        ptt = call.argument("ptt");
        mIat.setParameter(SpeechConstant.ASR_PTT,ptt);
        mIatResults.clear();
        // 不显示听写对话框
        ret = mIat.startListening(mRecognizerListener(result));
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
        /// 这是与


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
  private RecognizerDialogListener mRecognizerDialogListener(Result result){
    return new RecognizerDialogListener() {
      // 返回结果
      public void onResult(RecognizerResult results, boolean isLast) {
        String recognizerResult = getRecognizerResult(results);
        if(isLast){
          result.success(recognizerResult);
        }
      }

      // 识别回调错误
      public void onError(SpeechError error) {
        Toast.makeText(
                mContext,
                error.getPlainDescription(true),
                Toast.LENGTH_SHORT
        ).show();
      }
    };
  }

  /**
   * 听写监听器。
   */
  private RecognizerListener mRecognizerListener(Result result){
    return new RecognizerListener() {

      @Override
      public void onBeginOfSpeech() {
        // 此回调表示：sdk内部录音机已经准备好了，用户可以开始语音输入
        showTip("开始说话");
      }

      @Override
      public void onError(SpeechError error) {
        // Tips：
        // 错误码：10118(您没有说话)，可能是录音机权限被禁，需要提示用户打开应用的录音权限。
        android.util.Log.d(TAG, "onError " + error.getPlainDescription(true));
        showTip(error.getPlainDescription(true));
      }

      @Override
      public void onEndOfSpeech() {
        // 此回调表示：检测到了语音的尾端点，已经进入识别过程，不再接受语音输入
        showTip("结束说话");
      }

      @Override
      public void onResult(RecognizerResult results, boolean isLast) {
        android.util.Log.d(TAG, results.getResultString());
        String recognizerResult =  getRecognizerResult(results);
        if (isLast) {
          android.util.Log.d(TAG, "onResult 结束");
          result.success(recognizerResult);
        }
      }

      @Override
      public void onVolumeChanged(int volume, byte[] data) {
        showTip("当前正在说话，音量大小 = " + volume + " 返回音频数据 = " + data.length);
      }

      @Override
      public void onEvent(int eventType, int arg1, int arg2, Bundle obj) {
        // 以下代码用于获取与云端的会话id，当业务出错时将会话id提供给技术支持人员，可用于查询会话日志，定位出错原因
        // 若使用本地能力，会话id为null
        //	if (SpeechEvent.EVENT_SESSION_ID == eventType) {
        //		String sid = obj.getString(SpeechEvent.KEY_EVENT_SESSION_ID);
        //		Log.d(TAG, "session id =" + sid);
        //	}
      }
    };
  }

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
//    if(isLast){
//      result.success(resultBuffer.toString());
//    }
    return resultBuffer.toString();
  }

  private void showTip(final String str) {
    if (mToast != null) {
      mToast.cancel();
    }
    mToast = Toast.makeText(mContext, str, Toast.LENGTH_SHORT);
    mToast.show();
  }

  /// 设置参数
  private void setParams(){

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
}