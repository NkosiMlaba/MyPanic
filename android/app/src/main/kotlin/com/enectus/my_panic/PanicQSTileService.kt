package com.enectus.my_panic

import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.widget.Toast
import androidx.annotation.RequiresApi

/**
 * Android Quick Settings tile for triggering panic from the notification shade.
 *
 * Works from the lockscreen — the user can pull down QS and tap without
 * unlocking. Reads armed/loggedIn state from SharedPreferences to update
 * tile appearance.
 *
 * If the app process is dead when tapped, it launches MainActivity with
 * a trigger intent extra.
 */
@RequiresApi(Build.VERSION_CODES.N)
class PanicQSTileService : TileService() {

    companion object {
        /**
         * Request the system to re-query tile state.
         * Called when armed/loggedIn state changes in Flutter.
         */
        fun requestListeningState(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                TileService.requestListeningState(
                    context,
                    ComponentName(context, PanicQSTileService::class.java)
                )
            }
        }

        private const val DEBOUNCE_MS = 5000L

        @Volatile
        private var lastTriggerTime = 0L
    }

    override fun onStartListening() {
        super.onStartListening()
        updateTileState()
    }

    override fun onClick() {
        super.onClick()

        val prefs = TriggerEnginePlugin.getPrefs(this)
        val isLoggedIn = prefs.getBoolean("is_logged_in", false)
        val isArmed = prefs.getBoolean("armed", false)

        if (!isLoggedIn) {
            Toast.makeText(this, "Please log in to MyPanic first", Toast.LENGTH_SHORT).show()
            return
        }

        if (!isArmed) {
            Toast.makeText(this, "MyPanic system is not armed", Toast.LENGTH_SHORT).show()
            return
        }

        // Debounce
        val now = System.currentTimeMillis()
        if (now - lastTriggerTime < DEBOUNCE_MS) return
        lastTriggerTime = now

        // Send trigger event to Flutter
        TriggerEnginePlugin.sendTriggerEvent(
            source = "qs_tile",
            metadata = mapOf("trigger_method" to "quick_settings_tile")
        )

        // Launch app to show countdown screen
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("TRIGGER_SOURCE", "qs_tile")
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            // API 34+: must use PendingIntent variant
            val pendingIntent = PendingIntent.getActivity(
                this, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            startActivityAndCollapse(pendingIntent)
        } else {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        }
    }

    private fun updateTileState() {
        val tile = qsTile ?: return
        val prefs = TriggerEnginePlugin.getPrefs(this)
        val isLoggedIn = prefs.getBoolean("is_logged_in", false)
        val isArmed = prefs.getBoolean("armed", false)

        tile.state = when {
            !isLoggedIn -> Tile.STATE_UNAVAILABLE
            isArmed -> Tile.STATE_ACTIVE
            else -> Tile.STATE_INACTIVE
        }

        tile.label = "MyPanic"
        tile.contentDescription = when (tile.state) {
            Tile.STATE_ACTIVE -> "MyPanic: Armed — Tap for emergency"
            Tile.STATE_INACTIVE -> "MyPanic: Disarmed"
            else -> "MyPanic: Not logged in"
        }

        tile.updateTile()
    }
}
