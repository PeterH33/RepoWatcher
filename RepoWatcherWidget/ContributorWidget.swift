//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Peter Hartnett on 8/30/22.
//

import SwiftUI
import WidgetKit

struct ContributorProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> ()) {
        let entry = ContributorEntry(date: .now)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
           
            let nextUpdate = Date().addingTimeInterval(43200)
            let entry = ContributorEntry(date: .now)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        
    }
}

struct ContributorEntry: TimelineEntry {
    let date: Date
}


struct ContributorEntryView : View {
    var entry: ContributorEntry
    
    var body: some View {
        Text(entry.date.formatted())
    }
}


struct ContributorWidget: Widget {
    let kind: String = "ContributorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            ContributorEntryView(entry: entry)
        }
        .configurationDisplayName("Contributors")
        .description("Keep an eye on a GitHub repository and its top followers")
        .supportedFamilies([ .systemLarge])
    }
}


struct ContributorWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContributorEntryView(entry: ContributorEntry(date: .now))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        
    }
}


