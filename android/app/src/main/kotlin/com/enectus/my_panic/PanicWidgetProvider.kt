package com.enectus.my_panic

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

/**
 * Home screen widget provider for the 1x1 Panic Button widget.
 *
 * Tapping the widget triggers the panic flow via PanicActionReceiver,
 * the same path used by the notification PANIC button.
 */
class PanicButtonWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            updatePanicButtonWidget(context, appWidgetManager, widgetId)
        }
    }

    companion object {
        fun updatePanicButtonWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_panic_button)
            views.setOnClickPendingIntent(
                R.id.widget_panic_button_root,
                createPanicPendingIntent(context, widgetId)
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

/**
 * Home screen widget provider for the 4x1 Status Bar widget.
 *
 * Shows armed/disarmed status. The whole widget area opens the app,
 * while the SOS button triggers panic.
 */
class PanicStatusWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            updateStatusWidget(context, appWidgetManager, widgetId)
        }
    }

    companion object {
        fun updateStatusWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int
        ) {
            val prefs = TriggerEnginePlugin.getPrefs(context)
            val isArmed = prefs.getBoolean("armed", false)

            val views = RemoteViews(context.packageName, R.layout.widget_panic_status)

            // Update status text based on armed state
            if (isArmed) {
                views.setTextViewText(R.id.widget_status_subtitle, "System Armed")
                views.setInt(R.id.widget_status_root, "setBackgroundResource",
                    R.drawable.widget_background_armed)
            } else {
                views.setTextViewText(R.id.widget_status_subtitle, "System Disarmed")
                views.setInt(R.id.widget_status_root, "setBackgroundResource",
                    R.drawable.widget_background_disarmed)
            }

            // Tapping the status area opens the app
            val openIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val openPendingIntent = PendingIntent.getActivity(
                context, 100 + widgetId, openIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_status_root, openPendingIntent)

            // Tapping SOS button triggers panic
            views.setOnClickPendingIntent(
                R.id.widget_status_panic_btn,
                createPanicPendingIntent(context, widgetId)
            )

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

/**
 * Home screen widget provider for the 2x1 Quick Panic widget.
 *
 * Compact widget — tapping anywhere triggers panic.
 */
class PanicQuickWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            updateQuickWidget(context, appWidgetManager, widgetId)
        }
    }

    companion object {
        fun updateQuickWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int
        ) {
            val prefs = TriggerEnginePlugin.getPrefs(context)
            val isArmed = prefs.getBoolean("armed", false)

            val views = RemoteViews(context.packageName, R.layout.widget_panic_quick)

            if (isArmed) {
                views.setTextViewText(R.id.widget_quick_text, "PANIC")
                views.setTextColor(R.id.widget_quick_text, 0xFFE53935.toInt())
                views.setInt(R.id.widget_quick_root, "setBackgroundResource",
                    R.drawable.widget_background_armed)
            } else {
                views.setTextViewText(R.id.widget_quick_text, "DISARMED")
                views.setTextColor(R.id.widget_quick_text, 0xFFA69D9C.toInt())
                views.setInt(R.id.widget_quick_root, "setBackgroundResource",
                    R.drawable.widget_background_disarmed)
            }

            views.setOnClickPendingIntent(
                R.id.widget_quick_root,
                createPanicPendingIntent(context, widgetId)
            )

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

// ── Shared helper ──────────────────────────────────────────────────────────

/**
 * Creates a PendingIntent that triggers the panic flow.
 *
 * Uses PanicActionReceiver (same as notification PANIC button) so the trigger
 * goes through the same debounced, event-channel path.
 */
private fun createPanicPendingIntent(context: Context, widgetId: Int): PendingIntent {
    val intent = Intent(context, PanicActionReceiver::class.java).apply {
        action = PanicActionReceiver.ACTION_PANIC_TRIGGERED
        putExtra("source", "widget")
    }
    return PendingIntent.getBroadcast(
        context, 200 + widgetId, intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
}

/**
 * Utility to refresh all widget instances — called from TriggerEnginePlugin
 * when armed state changes.
 */
object PanicWidgetUpdater {
    fun updateAllWidgets(context: Context) {
        val appWidgetManager = AppWidgetManager.getInstance(context)

        // Update 1x1 Panic Button widgets
        val buttonIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, PanicButtonWidgetProvider::class.java)
        )
        for (id in buttonIds) {
            PanicButtonWidgetProvider.updatePanicButtonWidget(context, appWidgetManager, id)
        }

        // Update 4x1 Status widgets
        val statusIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, PanicStatusWidgetProvider::class.java)
        )
        for (id in statusIds) {
            PanicStatusWidgetProvider.updateStatusWidget(context, appWidgetManager, id)
        }

        // Update 2x1 Quick widgets
        val quickIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, PanicQuickWidgetProvider::class.java)
        )
        for (id in quickIds) {
            PanicQuickWidgetProvider.updateQuickWidget(context, appWidgetManager, id)
        }
    }
}
