//
//  WidgetBundle.swift
//  RepoWatcherWidgetExtension
//
//  Created by Peter Hartnett on 8/30/22.
//

import SwiftUI
import WidgetKit


//Wehn using a widget bundle you have to do some renaming of the various widgets and the structs therein so that they are all unique.
@main
struct RepoWatcherWidgets: WidgetBundle{
    var body: some Widget{
        CompactRepoWidget()
        ContributorWidget()
        bobWidget()
    }
}
