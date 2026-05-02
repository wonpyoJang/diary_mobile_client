package com.cassette.diary_mobile_client

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/// 연속 기록(스트릭)·오늘의 감정·이번 주 분포 요약.
class DiaryStatsWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.diary_stats_widget)

            val streak = widgetData.getString("crepas_streak", "0") ?: "0"
            views.setTextViewText(R.id.stats_streak, "${streak}일")

            val today = widgetData.getString("crepas_today", "—") ?: "—"
            views.setTextViewText(R.id.stats_today, today)

            val weekJson = widgetData.getString("crepas_week_json", "[]") ?: "[]"
            views.setTextViewText(R.id.stats_week, formatWeekSummary(weekJson))

            val open = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
            )
            views.setOnClickPendingIntent(R.id.stats_widget_root, open)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun formatWeekSummary(json: String): String {
        return try {
            val arr = JSONArray(json)
            if (arr.length() == 0) return "—"
            buildString {
                for (i in 0 until minOf(arr.length(), 5)) {
                    val o = arr.getJSONObject(i)
                    val name = o.optString("emotion", "?")
                    val c = o.optInt("count", 0)
                    if (i > 0) append("\n")
                    append("$name $c")
                }
            }
        } catch (_: Exception) {
            "—"
        }
    }
}
