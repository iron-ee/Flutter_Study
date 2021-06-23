package com.cos.native_example

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import androidx.annotation.NonNull
import  io.flutter.embedding.engine.FlutterEngine
import  io.flutter.plugin.common.MethodChannel
import android.util.Base64
import android.app.AlertDialog

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.flutter.dev/info"
    private val CHANNEL2 = "com.flutter.dev/encrypto"
    private val CHANNEL3 = "com.flutter.dev/dialog"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    if(call.method == "getDeviceInfo") {
                        val deviceInfo = getDeviceInfo()
                        result.success(deviceInfo)
                    }
                }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)
                .setMethodCallHandler { call, result ->  
                    if (call.method == "getEncrypto") {
                        val data = call.arguments.toString().toByteArray(); // 플러터에서 보낸 데이터
                        val changeText = Base64.encodeToString(data, Base64.DEFAULT)  // 데이터를 Base64로 인코딩하기
                        result.success(changeText)
                    } else if (call.method == "getDecode") {
                        val changedText = Base64.decode(call.arguments.toString(), Base64.DEFAULT)  // Base64 데이터를 디코딩하기
                        result.success(String(changedText))
                    }
                }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL3)
                .setMethodCallHandler { call, result ->  
                    if (call.method == "showDialog") {
                        AlertDialog.Builder(this)   // 안드로이드 알림 창을 띄우기
                                .setTitle("Flutter")
                                .setMessage("네이티브에서 출력하는 창입니다.")
                                .show()
                    }
                }
    }
}

private fun getDeviceInfo(): String{
    val sb = StringBuffer()
    sb.append(Build.DEVICE + "\n")
    sb.append(Build.BRAND + "\n")
    sb.append(Build.MODEL + "\n")
    return sb.toString()
}
