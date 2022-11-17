package com.example.flutter_tectoy_sample

import android.util.Log
import androidx.annotation.NonNull
import br.com.itfast.tectoy.Dispositivo
import br.com.itfast.tectoy.TecToy
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.flutter.it4r/it4r"
    private lateinit var channel: MethodChannel
    private var tecToy: TecToy? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        tecToy = TecToy(Dispositivo.V2_PRO, context)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        //Recebendo dados do Flutter
        channel.setMethodCallHandler{call, result ->
            if(call.method == "Printy"){
                val argument = call.arguments as Map<String, String>
                val name = argument["arguments"]
                tecToy!!.imprimir(name.toString())
                result.success("FROM JAVA")
            }
        }
    }

}
