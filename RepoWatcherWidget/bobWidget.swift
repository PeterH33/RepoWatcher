//
//  bobWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Peter Hartnett on 8/30/22.
//

import SwiftUI
import WidgetKit

struct bobProvider: TimelineProvider {
    func placeholder(in context: Context) -> bobEntry {
        bobEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (bobEntry) -> ()) {
        let entry = bobEntry(date: .now)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        
        let nextUpdate = Date().addingTimeInterval(42000)
        let entry = bobEntry(date: .now)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
        
    }
}

struct bobEntry: TimelineEntry {
    let date: Date
}


struct bobEntryView : View {
    var entry: bobEntry
    
    var body: some View {
        Text(entry.date.formatted())
    }
}


struct bobWidget: Widget {
    let kind: String = "bobWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: bobProvider()) { entry in
            bobEntryView(entry: entry)
        }
        .configurationDisplayName("Display name")
        .description("Description")
        .supportedFamilies([ .systemLarge]) //specify the supported families
    }
}


struct bobWidget_Previews: PreviewProvider {
    static var previews: some View {
        bobEntryView(entry: bobEntry(date: .now))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        
    }
}
