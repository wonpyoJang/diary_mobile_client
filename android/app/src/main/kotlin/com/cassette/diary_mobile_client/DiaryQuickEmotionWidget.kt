package com.cassette.diary_mobile_client

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/// 홈 화면 위젯: 감정 6종 탭 → 딥링크로 앱에서 즉시 저장.
class DiaryQuickEmotionWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val emotions = listOf(
            "happiness",
            "calmness",
            "sadness",
            "anger",
            "warmth",
            "hope",
        )
        val ids = intArrayOf(
            R.id.emotion_0,
            R.id.emotion_1,
            R.id.emotion_2,
            R.id.emotion_3,
            R.id.emotion_4,
            R.id.emotion_5,
        )

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.diary_quick_emotion_widget)
            emotions.forEachIndexed { index, name ->
                val uri = Uri.parse("cassette-diary://widget/quick-emotion?emotion=$name")
                val pi = launchPendingIntent(context, uri, /* requestCode */ 100 + index)
                views.setOnClickPendingIntent(ids[index], pi)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun launchPendingIntent(context: Context, uri: Uri, requestCode: Int): PendingIntent {
        val intent = Intent(context, MainActivity::class.java)
        intent.data = uri
        intent.action = Intent.ACTION_VIEW
        var flags = PendingIntent.FLAG_UPDATE_CURRENT
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            flags = flags or PendingIntent.FLAG_IMMUTABLE
        }
        return PendingIntent.getActivity(context, requestCode, intent, flags)
    }
}
