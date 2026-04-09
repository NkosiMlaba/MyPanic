package com.enectus.my_panic

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * BroadcastReceiver that handles the PANIC action button tap from the
 * persistent notification and routes it to Flutter via the EventChannel.
 *
 * If the Flutter engine is not running (app was killed), it launches
 * MainActivity with a trigger intent extra.
 *
 * Includes a 5-second debounce to prevent multiple rapid taps.
 */
class PanicActionReceiver : BroadcastReceiver() {

    companion object {
        const val ACTION_PANIC_TRIGGERED = "com.enectus.my_panic.ACTION_PANIC_TRIGGERED"
        private const val DEBOUNCE_MS = 5000L

        @Volatile
        private var lastTriggerTime = 0L
    }

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != ACTION_PANIC_TRIGGERED) return

        // Debounce: ignore rapid taps within 5 seconds
        val now = System.currentTimeMillis()
        if (now - lastTriggerTime < DEBOUNCE_MS) return
        lastTriggerTime = now

        // Try sending via EventChannel first (Flutter engine running)
        TriggerEnginePlugin.sendTriggerEvent(
            source = "notification",
            metadata = mapOf("trigger_method" to "notification_action")
        )

        // Always bring app to foreground — the countdown screen needs to be visible
        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("TRIGGER_SOURCE", "notification")
        }
        context.startActivity(launchIntent)
    }
}
