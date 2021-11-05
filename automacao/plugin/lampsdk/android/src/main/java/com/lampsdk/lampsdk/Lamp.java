package com.lampsdk.lampsdk;

import android.app.Activity;
import android.app.Application;
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

public class Lamp extends Application {
    private Activity mCurrentActivity = null;
    @Override
    public void onCreate () {
        super .onCreate() ;
    }
    public Activity getCurrentActivity () {
        return mCurrentActivity ;
    }
    public void setCurrentActivity (Activity mCurrentActivity) {
        this . mCurrentActivity = mCurrentActivity ;
    }
}
