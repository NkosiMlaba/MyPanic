package com.enectus.my_panic

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Registers the MethodChannel and EventChannel for the trigger engine.
 *
 * All native trigger features (foreground service, shake detection, QS tile)
 * communicate with Flutter through this single plugin.
 */
object TriggerEnginePlugin {
    private const val METHOD_CHANNEL = "com.enectus.my_panic/trigger_engine"
    private const val EVENT_CHANNEL = "com.enectus.my_panic/trigger_events"
    private const val PREFS_NAME = "my_panic_trigger_prefs"

    // Static event sink accessible by PanicForegroundService and PanicActionReceiver
    @Volatile
    var eventSink: EventChannel.EventSink? = null
        private set

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null

    fun registerWith(flutterEngine: FlutterEngine, context: Context) {
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL
        ).apply {
            setMethodCallHandler { call, result ->
                handleMethodCall(call.method, call.arguments, context, result)
            }
        }

        eventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL
        ).apply {
            setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
        }
    }

    private fun handleMethodCall(
        method: String,
        arguments: Any?,
        context: Context,
        result: MethodChannel.Result
    ) {
        when (method) {
            "startForegroundService" -> {
                val intent = Intent(context, PanicForegroundService::class.java).apply {
                    action = PanicForegroundService.ACTION_START
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
                result.success(null)
            }

            "stopForegroundService" -> {
                val intent = Intent(context, PanicForegroundService::class.java).apply {
                    action = PanicForegroundService.ACTION_STOP
                }
                context.startService(intent)
                result.success(null)
            }

            "updateNotificationState" -> {
                val args = arguments as? Map<*, *>
                val armed = args?.get("armed") as? Boolean ?: false
                val intent = Intent(context, PanicForegroundService::class.java).apply {
                    action = PanicForegroundService.ACTION_UPDATE_STATE
                    putExtra("armed", armed)
                }
                context.startService(intent)

                // Also write to SharedPreferences for QS tile to read
                getPrefs(context).edit().putBoolean("armed", armed).apply()
                result.success(null)
            }

            "setShakeEnabled" -> {
                val args = arguments as? Map<*, *>
                val enabled = args?.get("enabled") as? Boolean ?: false
                val intent = Intent(context, PanicForegroundService::class.java).apply {
                    action = PanicForegroundService.ACTION_SET_SHAKE_ENABLED
                    putExtra("enabled", enabled)
                }
                context.startService(intent)
                result.success(null)
            }

            "setShakeSensitivity" -> {
                val args = arguments as? Map<*, *>
                val level = args?.get("level") as? String ?: "medium"
                val intent = Intent(context, PanicForegroundService::class.java).apply {
                    action = PanicForegroundService.ACTION_SET_SHAKE_SENSITIVITY
                    putExtra("level", level)
                }
                context.startService(intent)
                result.success(null)
            }

            "updateQSTileState" -> {
                val args = arguments as? Map<*, *>
                val armed = args?.get("armed") as? Boolean ?: false
                val loggedIn = args?.get("loggedIn") as? Boolean ?: false
                getPrefs(context).edit()
                    .putBoolean("armed", armed)
                    .putBoolean("is_logged_in", loggedIn)
                    .apply()
                // Request tile update if API supports it
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    PanicQSTileService.requestListeningState(context)
                }
                result.success(null)
            }

            "isForegroundServiceRunning" -> {
                result.success(PanicForegroundService.isRunning)
            }

            else -> result.notImplemented()
        }
    }

    fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    /**
     * Send a trigger event to Flutter via the EventChannel.
     * Called from PanicActionReceiver, PanicForegroundService, and PanicQSTileService.
     */
    fun sendTriggerEvent(source: String, metadata: Map<String, Any>? = null) {
        val event = HashMap<String, Any?>().apply {
            put("source", source)
            put("timestamp", System.currentTimeMillis())
            if (metadata != null) put("metadata", metadata)
        }
        eventSink?.success(event)
    }
}
