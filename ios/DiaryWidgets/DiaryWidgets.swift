// Xcode에서 Widget Extension 타깃을 추가한 뒤 이 폴더의 파일을 타깃에 포함하고,
// Signing & Capabilities에서 App Groups → group.com.crepas.diary 를 켠다.
// Flutter의 HomeWidget.updateWidget(iOSName:) 과 kind 문자열이 일치해야 한다.

import SwiftUI
import WidgetKit

private let appGroupId = "group.com.crepas.diary"

private let quickKinds: [(label: String, emotion: String)] = [
  ("행복", "happiness"),
  ("평온", "calmness"),
  ("슬픔", "sadness"),
  ("분노", "anger"),
  ("따스", "warmth"),
  ("희망", "hope"),
]

struct DiaryQuickEmotionWidget: Widget {
  let kind: String = "DiaryQuickEmotionWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: DiaryQuickProvider()) { _ in
      DiaryQuickEmotionEntryView()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("빠른 감정")
    .description("탭 한 번으로 오늘 감정을 기록합니다.")
    .supportedFamilies([.systemMedium])
  }
}

private struct DiaryQuickProvider: TimelineProvider {
  func placeholder(in context: Context) -> Entry { Entry(date: Date()) }
  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    completion(Entry(date: Date()))
  }
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    completion(Timeline(entries: [Entry(date: Date())], policy: .never))
  }

  struct Entry: TimelineEntry {
    let date: Date
  }
}

private struct DiaryQuickEmotionEntryView: View {
  var body: some View {
    HStack(spacing: 4) {
      ForEach(Array(quickKinds.enumerated()), id: \.offset) { _, item in
        if let url = URL(string: "cassette-diary://widget/quick-emotion?emotion=\(item.emotion)") {
          Link(destination: url) {
            Text(item.label)
              .font(.caption2)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 6)
          }
        }
      }
    }
    .padding(6)
  }
}

struct DiaryStatsWidget: Widget {
  let kind: String = "DiaryStatsWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: DiaryStatsProvider()) { _ in
      DiaryStatsEntryView()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("감정 요약")
    .description("연속 기록과 오늘·이번 주 감정 요약.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

private struct DiaryStatsProvider: TimelineProvider {
  func placeholder(in context: Context) -> Entry { Entry(date: Date()) }
  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    completion(Entry(date: Date()))
  }
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    completion(Timeline(entries: [Entry(date: Date())], policy: .atEnd))
  }

  struct Entry: TimelineEntry {
    let date: Date
  }
}

private struct DiaryStatsEntryView: View {
  private var defaults: UserDefaults? {
    UserDefaults(suiteName: appGroupId)
  }

  var body: some View {
    let streak = defaults?.string(forKey: "crepas_streak") ?? "0"
    let today = defaults?.string(forKey: "crepas_today") ?? "—"
    let week = defaults?.string(forKey: "crepas_week_json") ?? "[]"

    VStack(alignment: .leading, spacing: 4) {
      Text("연속 \(streak)일")
        .font(.headline)
      Text("오늘: \(today)")
        .font(.caption)
        .lineLimit(2)
      Text(shortWeek(week))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(4)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(8)
  }

  private func shortWeek(_ json: String) -> String {
    guard let data = json.data(using: .utf8),
          let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    else { return "—" }
    return arr.prefix(5).compactMap { row -> String? in
      guard let e = row["emotion"] as? String, let c = row["count"] as? Int else { return nil }
      return "\(e) \(c)"
    }.joined(separator: "\n")
  }
}

@main
struct DiaryWidgetsBundle: WidgetBundle {
  var body: some Widget {
    DiaryQuickEmotionWidget()
    DiaryStatsWidget()
  }
}
