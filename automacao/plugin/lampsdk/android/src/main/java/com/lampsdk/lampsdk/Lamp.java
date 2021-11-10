package com.lampsdk.lampsdk;

import android.app.Activity;
import android.app.Application;
import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Binder;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.content.ContextWrapper;

import com.sunmi.statuslampmanager.IStateLamp;

public class Lamp {



    private static IStateLamp mService;

    private static Lamp helper = new Lamp();

    private Lamp() {}

    public static Lamp getInstance() {
        return helper;
    }

    private void handleRemoteException(RemoteException e){
        //TODO process when get one exception
    }

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

    public void connectService(Context context) {
        Intent intent = new Intent();
        intent.setPackage("com.sunmi.statuslampmanager");
        intent.setAction("com.sunmi.statuslamp.service");
        context.startService(intent);
        context.bindService(intent, con, Service.BIND_AUTO_CREATE);
    }

    // Funçoes Lampada Led

    public void closeAllLamp(){
        if(mService == null){
            //TODO Service disconnection processing
            return;
        }
        try {
            mService.closeAllLamp();
        } catch (RemoteException e) {
            handleRemoteException(e);
        }
    }

    public void controlLamp(int status, String lamp){
        if(mService == null){
            //TODO Service disconnection processing
            return;
        }
        try {
            mService.controlLamp(status, lamp);
        } catch (RemoteException e) {
            handleRemoteException(e);
        }
    }

    public void controlLampForLoop(int status, int lightTime, int putoutTime, String lamp){
        if(mService == null){
            //TODO Service disconnection processing
            return;
        }
        try {
            mService.controlLampForLoop(status, lightTime, putoutTime, lamp);
        } catch (RemoteException e) {
            handleRemoteException(e);
        }
    }

}
