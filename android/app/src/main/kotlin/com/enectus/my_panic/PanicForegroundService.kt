package com.enectus.my_panic

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import kotlin.math.sqrt

/**
 * Foreground service that keeps the persistent panic notification alive
 * and runs the shake detection accelerometer listener.
 *
 * Survives app kill via START_STICKY. Uses foregroundServiceType="location"
 * for battery optimization exemption.
 */
class PanicForegroundService : Service(), SensorEventListener {

    companion object {
        const val ACTION_START = "com.enectus.my_panic.ACTION_START_SERVICE"
        const val ACTION_STOP = "com.enectus.my_panic.ACTION_STOP_SERVICE"
        const val ACTION_UPDATE_STATE = "com.enectus.my_panic.ACTION_UPDATE_STATE"
        const val ACTION_SET_SHAKE_ENABLED = "com.enectus.my_panic.ACTION_SET_SHAKE_ENABLED"
        const val ACTION_SET_SHAKE_SENSITIVITY = "com.enectus.my_panic.ACTION_SET_SHAKE_SENSITIVITY"

        private const val CHANNEL_ID = "my_panic_foreground"
        private const val NOTIFICATION_ID = 1001

        @Volatile
        var isRunning = false
            private set
    }

    // ── Shake Detection State ──────────────────────────────────────────────
    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var shakeEnabled = false

    // Sensitivity thresholds
    private var magnitudeThreshold = 15.0  // m/s² (medium default)
    private var requiredCrossings = 4       // crossings in window (medium default)

    // Sliding window for shake detection (1 second at ~50 Hz)
    private val crossingTimestamps = mutableListOf<Long>()
    private val windowMs = 1000L
    private var lastShakeTime = 0L
    private val cooldownMs = 5000L  // 5-second cooldown between shake triggers

    private var isArmed = true

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                isRunning = true
                startForeground(NOTIFICATION_ID, buildNotification(armed = true))
            }

            ACTION_STOP -> {
                isRunning = false
                stopShakeDetection()
                stopForeground(STOP_FOREGROUND_REMOVE)
                stopSelf()
                return START_NOT_STICKY
            }

            ACTION_UPDATE_STATE -> {
                isArmed = intent.getBooleanExtra("armed", true)
                val notification = buildNotification(armed = isArmed)
                val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                nm.notify(NOTIFICATION_ID, notification)
            }

            ACTION_SET_SHAKE_ENABLED -> {
                val enabled = intent.getBooleanExtra("enabled", false)
                if (enabled) startShakeDetection() else stopShakeDetection()
            }

            ACTION_SET_SHAKE_SENSITIVITY -> {
                val level = intent.getStringExtra("level") ?: "medium"
                applySensitivity(level)
            }
        }

        return START_STICKY
    }

    // ── Notification ───────────────────────────────────────────────────────

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "MyPanic Safety Service",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Keeps MyPanic ready to send emergency alerts"
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setShowBadge(false)
            }
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(armed: Boolean): Notification {
        // Tap notification → open app
        val openIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val openPendingIntent = PendingIntent.getActivity(
            this, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // PANIC action button
        val panicIntent = Intent(this, PanicActionReceiver::class.java).apply {
            action = PanicActionReceiver.ACTION_PANIC_TRIGGERED
        }
        val panicPendingIntent = PendingIntent.getBroadcast(
            this, 1, panicIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val title = if (armed) "MyPanic — System Armed" else "MyPanic — Disarmed"
        val text = if (armed) "Tap PANIC in an emergency" else "System is currently disarmed"

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setOngoing(true)  // Cannot be swiped away
            .setContentIntent(openPendingIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)  // Visible on lockscreen
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .apply {
                if (armed) {
                    addAction(
                        android.R.drawable.ic_dialog_alert,
                        "🚨 PANIC",
                        panicPendingIntent
                    )
                }
            }
            .build()
    }

    // ── Shake Detection ────────────────────────────────────────────────────

    private fun startShakeDetection() {
        if (shakeEnabled) return
        if (accelerometer == null) return

        shakeEnabled = true
        sensorManager?.registerListener(
            this, accelerometer, SensorManager.SENSOR_DELAY_GAME
        )
    }

    private fun stopShakeDetection() {
        if (!shakeEnabled) return
        shakeEnabled = false
        sensorManager?.unregisterListener(this)
        crossingTimestamps.clear()
    }

    private fun applySensitivity(level: String) {
        when (level) {
            "low" -> {
                magnitudeThreshold = 20.0
                requiredCrossings = 5
            }
            "high" -> {
                magnitudeThreshold = 12.0
                requiredCrossings = 3
            }
            else -> { // medium
                magnitudeThreshold = 15.0
                requiredCrossings = 4
            }
        }
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type != Sensor.TYPE_ACCELEROMETER) return
        if (!shakeEnabled || !isArmed) return

        val x = event.values[0].toDouble()
        val y = event.values[1].toDouble()
        val z = event.values[2].toDouble()

        // Calculate magnitude (subtract gravity ~9.81)
        val magnitude = sqrt(x * x + y * y + z * z) - SensorManager.GRAVITY_EARTH

        if (magnitude > magnitudeThreshold) {
            val now = System.currentTimeMillis()
            crossingTimestamps.add(now)

            // Remove timestamps outside the 1-second window
            crossingTimestamps.removeAll { now - it > windowMs }

            // Check if enough crossings in the window
            if (crossingTimestamps.size >= requiredCrossings) {
                // Enforce cooldown
                if (now - lastShakeTime > cooldownMs) {
                    lastShakeTime = now
                    crossingTimestamps.clear()
                    onShakeDetected()
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed for shake detection
    }

    private fun onShakeDetected() {
        TriggerEnginePlugin.sendTriggerEvent(
            source = "shake",
            metadata = mapOf("trigger_method" to "shake_detection")
        )

        // If Flutter engine is not running, launch the app with trigger intent
        if (TriggerEnginePlugin.eventSink == null) {
            val intent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                putExtra("TRIGGER_SOURCE", "shake")
            }
            startActivity(intent)
        }
    }

    override fun onDestroy() {
        isRunning = false
        stopShakeDetection()
        super.onDestroy()
    }
}
