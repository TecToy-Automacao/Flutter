package com.lampsdk.lampsdk;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.audiofx.DynamicsProcessing;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;


import androidx.annotation.NonNull;

import com.sunmi.statuslampmanager.IStateLamp;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collection;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** LampsdkPlugin */
public class LampsdkPlugin implements FlutterPlugin, MethodCallHandler {

  private static final Object BIND_AUTO_CREATE = 0x0001;
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Context contextAplication;

  // VARIAVEIS
  private final String roxo = "roxo";
  private final String verde = "verde";
  private final String azul = "azul";
  private final String amarelo = "amarelo";
  private final String azulclaro = "azulclaro";
  private final String vermelho = "vermelho";
  private final String desligar = "desligar";
  private final String init = "init";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "lampsdk");
    channel.setMethodCallHandler(this);
    contextAplication = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    switch (call.method){
      case init:
        Lamp.getInstance().connectService(contextAplication);
        break;
      case roxo:
          Lamp.getInstance().closeAllLamp();
          Lamp.getInstance().controlLamp(0, "Led-3");
          Lamp.getInstance().controlLampForLoop(0,500000,100,"Led-1");
        break;
      case verde:
        Lamp.getInstance().closeAllLamp();
        Lamp.getInstance().controlLamp(0, "Led-2");
        break;
      case azul:
        Lamp.getInstance().closeAllLamp();
        Lamp.getInstance().controlLamp(0, "Led-3");
        break;
      case vermelho:
        Lamp.getInstance().closeAllLamp();
        Lamp.getInstance().controlLamp(0, "Led-1");
        break;
      case azulclaro:
        Lamp.getInstance().closeAllLamp();
        Lamp.getInstance().controlLamp(0, "Led-3");
        Lamp.getInstance().controlLampForLoop(0,500000,100,"Led-2");
        break;
      case desligar:
        Lamp.getInstance().closeAllLamp();
        break;
      case amarelo:
        Lamp.getInstance().closeAllLamp();
        Lamp.getInstance().controlLamp(0, "Led-2");
        Lamp.getInstance().controlLampForLoop(0,50000,100,"Led-1");
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
