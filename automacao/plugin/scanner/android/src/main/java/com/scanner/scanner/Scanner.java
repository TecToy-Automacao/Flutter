package com.scanner.scanner;

import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.view.KeyEvent;

import com.sunmi.scanner.IScanInterface;

public class Scanner {


    private  IScanInterface scanInterface;

    private static Scanner helper = new Scanner();

    private Scanner() {}

    public static Scanner getInstance() {
        return helper;
    }

    private void handleRemoteException(RemoteException e){
        //TODO process when get one exception
    }

    private ServiceConnection conn = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            scanInterface = IScanInterface.Stub.asInterface(service);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            scanInterface = null;
        }
    };

    public void bindScannerService(Context context) {
        Intent intent = new Intent();
        intent.setPackage("com.sunmi.scanner");
        intent.setAction("com.sunmi.scanner.IScanInterface");
        context.bindService(intent, conn, Service.BIND_AUTO_CREATE);
    }



    // Funçoes Scanner

    public void stop(){
        if(scanInterface == null){
            //TODO Service disconnection processing
            return;
        }
        try {
            scanInterface.stop();
        } catch (RemoteException e) {
            handleRemoteException(e);
        }
    }

    public void scan(){
        if(scanInterface == null){
            //TODO Service disconnection processing
            return;
        }
        try {
            scanInterface.scan();
        } catch (RemoteException e) {
            handleRemoteException(e);
        }
    }

}
