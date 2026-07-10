package com.freshpickkart.customer

import android.content.Intent
import com.google.firebase.auth.FirebaseAuth
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.freshpickkart.customer/firebase"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, _ ->
            if (call.method == "forceRecaptchaV2") {
                FirebaseAuth.getInstance()
                    .firebaseAuthSettings
                    .forceRecaptchaV2FlowForPhoneAuth(true)
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
    }
}
