package com.example.methodchannel_example

import android.os.Handler
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.methodchannel/interop"
        private const val METHOD_PLATFORM_VERSION = "getPlatformVersion"
        private const val METHOD_GET_NUMBER = "getNumber"
        private const val METHOD_GET_LIST = "getList"
        private const val METHOD_CALL_ME = "callMe"
    }

    private val handler: Handler = Handler()
    private var pendingResult: MethodChannel.Result? = null
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            if (methodCall.method == METHOD_PLATFORM_VERSION) {
                result.success("Android")
            }
            else if (methodCall.method == METHOD_GET_NUMBER) {
                pendingResult = result
                handler.postDelayed({
                    pendingResult?.success(2020)
                    //pendingResult?.error("getNumber", "error message", 2020) <== error case
                }, 5000)
            }
            else if (methodCall.method == METHOD_GET_LIST) {
                val name = methodCall.argument<String>("name").toString()
                val age = methodCall.argument<Int>("age")
                Log.d("Android", "name = ${name}, age = $age")

                val list = listOf("data0", "data1", "data2")
                result.success(list)
            }
            else if (methodCall.method == METHOD_CALL_ME) {
                channel.invokeMethod("callMe", listOf("a", "b"))
                result.success(null)
            }
            else
                result.notImplemented()
        }
    }
}
