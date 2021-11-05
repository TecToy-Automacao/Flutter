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
  private static IStateLamp mService;
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

  //connect
  protected Lamp mMyApp;
  private ServiceConnection con = new ServiceConnection() {
    @Override
    public void onServiceConnected(ComponentName name, IBinder service) {
      mService = IStateLamp.Stub.asInterface(service);
      Log.d("darren", "Service Connected.");
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
      Log.d("darren", "Service Disconnected.");
      mService = null;
    }
  };
  private Activity mCurrentActivity = null;
  public Activity getCurrentActivity () {
    return mCurrentActivity ;
  }
  public void setCurrentActivity (Activity mCurrentActivity) {
    this . mCurrentActivity = mCurrentActivity ;
  }
  public void connectService() {
    Intent intent = new Intent();
    intent.setPackage("com.sunmi.statuslampmanager");
    intent.setAction("com.sunmi.statuslamp.service");
    // startService(intent);
    // bindService(intent, con, Context.BIND_AUTO_CREATE);
   // mCurrentActivity.startService(intent);
   // mCurrentActivity.bindService(intent, con, Context.BIND_AUTO_CREATE);

   // contextAplication.startService(intent)
  }

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

        System.out.println();
        break;
      case roxo:
        try {
          mService.controlLamp(0, "Led-3");
          mService.controlLampForLoop(0,500000,100,"Led-1");
          System.out.println("LED-3");
        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;
      case verde:
        try {
          mService.closeAllLamp();
          mService.controlLamp(0, "Led-2");
        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;
      case azul:
        try {
          mService.closeAllLamp();
          mService.controlLamp(0, "Led-3");
        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;
      case amarelo:
        try {
          mService.closeAllLamp();
          mService.controlLamp(0, "Led-2");
          mService.controlLampForLoop(0,50000,100,"Led-1");

        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;
      case azulclaro:
        try {
          mService.closeAllLamp();
          mService.controlLamp(0, "Led-3");
          mService.controlLampForLoop(0,500000,100,"Led-2");
        } catch (RemoteException e) {
          e.printStackTrace();
        }
         break;
      case desligar:
        try {
          mService.closeAllLamp();
        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;
      case vermelho:
        try {
          mService.closeAllLamp();
          mService.controlLamp(0, "Led-1");
        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
