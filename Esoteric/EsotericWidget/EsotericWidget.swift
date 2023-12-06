//
//  EsotericWidget.swift
//  EsotericWidget
//
//  Created by Alex on 22.11.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, power: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: .now, power: 1)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {

        var calendar = Calendar.current
        calendar.timeZone = .current
        let now = Date()
        let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        
        let midnight = nextMidnight
        DayConterService().checkIfMissDay()
        let entry = SimpleEntry(date: midnight, power: 1)
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let power: Int
}

struct EsotericWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack {

        
        }
    }
}

extension View {
    public func containerBackgroundForWidget<Background>(@ViewBuilder background: @escaping () -> Background) -> some View where Background: View {
        modifier(ContainerBackgroundForWidgetmodifier(background: background))
    }
}

struct ContainerBackgroundForWidgetmodifier<Background>: ViewModifier where Background: View {
    let background: () -> Background
    func body(content: Content) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content
                .containerBackground(for: .widget) {
                    background()
                }
        } else {
            ZStack {
                background()
                content
                    .padding()
            }
        }
    }
}

struct EsotericWidget: Widget {
    let kind: String = "EsotericaWidget"

    var body: some WidgetConfiguration {

            StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ZStack {
                ContainerRelativeShape()
                    .containerBackgroundForWidget { Color.black }
                SmallWidget()
            }
        }
            .configurationDisplayName("Esoterica")
            .description("Youre power")
            .contentMarginsDisabled()
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    EsotericWidget()
} timeline: {
    SimpleEntry(date: .now, power: 1)
}
