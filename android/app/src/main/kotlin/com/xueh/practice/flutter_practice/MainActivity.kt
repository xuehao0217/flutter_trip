package com.xueh.practice.flutter_practice

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
//import org.devio.flutter.splashscreen.flutter_splash_screen.SplashScreen;
class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
//        SplashScreen.show(this, true);
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
    }
}
