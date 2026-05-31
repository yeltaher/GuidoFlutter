package com.codepulse.guido.guido

import android.content.pm.ActivityInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.codepulse.guido/orientation"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                if (call.method == "forceLandscape") {
                    // Forza l'orientamento orizzontale reale, ignorando il blocco rotazione di sistema ed evitando il letterboxing
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                    result.success(null)
                } else if (call.method == "forcePortrait") {
                    // Ripristina l'orientamento verticale standard
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("ORIENTATION_ERROR", e.message, null)
            }
        }
    }
}
