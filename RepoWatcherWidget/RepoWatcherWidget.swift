//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Peter Hartnett on 8/29/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data())
    }

    //you can do a network call for the snapshot placeholder data, but apple recommends that you don't do that as it slows down and shows blanks for a minute before the network call goes through.
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task{
           
            let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
            
            do{
                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.Instafilter)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData ?? Data())
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
                
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
            
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let avatarImageData: Data
}

struct RepoWatcherWidgetEntryView : View {
    var entry: Provider.Entry
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
        calculateDaysSinceLastActivity(from: entry.repo.pushedAt)
    }

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack{
                    Image(uiImage: (UIImage(data: entry.avatarImageData) ?? UIImage(named: "avatar"))!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(entry.repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                HStack{
                    StatLabel(value: entry.repo.watchers, systemImageName: "star.fill")
                    StatLabel(value: entry.repo.forks, systemImageName: "tuningfork")
                    StatLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                }
            }
            
            Spacer()
            
            VStack{
                Text("\(daysSinceLastActivity)")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width:90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(daysSinceLastActivity > 60 ? .pink : .green)
                Text("Days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        //NOTE: This padding is being hard coded to prevent ... in the stat lines
        .padding(5)
    }
    
//Note:    dats include lots of optionals, just something to keep in mind
    func calculateDaysSinceLastActivity(from dateString: String) -> Int{
        
        let lastActivityDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        
        return daysSinceLastActivity
    }
}

@main
struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RepoWatcherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        //NOTE: supportedFamilies modifier here, handy setting to restrict the size classes of the widgets.
        .supportedFamilies([.systemMedium])
    }
}

struct RepoWatcherWidget_Previews: PreviewProvider {
    static var previews: some View {
        RepoWatcherWidgetEntryView(entry: RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

fileprivate struct StatLabel: View {
    let value: Int
    let systemImageName: String
    var body: some View{
        Label{
            Text("\(value)")
                .font(.footnote)
                
                .lineLimit(1)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundColor(.green)
        }
        
    }
}
