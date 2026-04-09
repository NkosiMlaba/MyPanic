package com.enectus.my_panic

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        TriggerEnginePlugin.registerWith(flutterEngine, this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleTriggerIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleTriggerIntent(intent)
    }

    /**
     * If the app was launched from a notification action, QS tile, or shake
     * when Flutter wasn't running, the trigger source is passed as an intent
     * extra. Forward it to Flutter via the EventChannel once it's available.
     */
    private fun handleTriggerIntent(intent: Intent?) {
        val triggerSource = intent?.getStringExtra("TRIGGER_SOURCE") ?: return
        // Clear the extra so it doesn't re-trigger on config changes
        intent.removeExtra("TRIGGER_SOURCE")

        // Send the event — the EventChannel sink may not be ready immediately
        // after cold start, so we post with a small delay
        window.decorView.postDelayed({
            TriggerEnginePlugin.sendTriggerEvent(
                source = triggerSource,
                metadata = mapOf("trigger_method" to "${triggerSource}_cold_start")
            )
        }, 500)
    }
}
