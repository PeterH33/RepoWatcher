//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Peter Hartnett on 8/29/22.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repo: Repository.placeHolder, bottomRepo: Repository.placeHolderB)
    }

    //you can do a network call for the snapshot placeholder data, but apple recommends that you don't do that as it slows down and shows blanks for a minute before the network call goes through.
    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repo: Repository.placeHolder, bottomRepo: Repository.placeHolderB)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task{
           
            let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
            
            do{
                //Get top repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                //get second repo in large widget if its in large size.
                var bottomRepo: Repository?
                if context.family == .systemLarge{
                    bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.google)
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                }
                
                //create entries and timeline
                let entry = CompactRepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
                
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
            
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
    
}

struct CompactRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CompactRepoEntry
    

    var body: some View {
        switch family{
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                if let bottomRepo = entry.bottomRepo{
                    RepoMediumView(repo: bottomRepo)
                }
            }
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemSmall:
            EmptyView()
        case .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
    

}


struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
            CompactRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on one or two GitHub repositories")
        //NOTE: supportedFamilies modifier here, handy setting to restrict the size classes of the widgets.
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct CompactRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        CompactRepoEntryView(entry: CompactRepoEntry(date: Date(), repo: Repository.placeHolder, bottomRepo: Repository.placeHolderB))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        CompactRepoEntryView(entry: CompactRepoEntry(date: Date(), repo: Repository.placeHolder, bottomRepo: Repository.placeHolderB))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


