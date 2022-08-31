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
        ContributorEntry(date: .now, repo: Repository.placeHolderB)
    }

    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> ()) {
        let entry = ContributorEntry(date: .now, repo: Repository.placeHolderB)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task{
            let nextUpdate = Date().addingTimeInterval(43200)
            
            do{
                //get Repo
                let repoToShow = RepoURL.swiftNews
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                //Attach /contributor to the last url to get them
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                
                //Just take top 4
                var topFour = Array(contributors.prefix(4))
                
                //Get the top 4 avatars
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                repo.contributors = topFour
                let entry = ContributorEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct ContributorEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}


struct ContributorEntryView : View {
    var entry: ContributorEntry
    
    var body: some View {
        VStack{
            RepoMediumView(repo: entry.repo)
            ContributorView(repo: entry.repo)
            Spacer()
           
        }
        
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
        ContributorEntryView(entry: ContributorEntry(date: .now, repo: Repository.placeHolderB))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        
    }
}



