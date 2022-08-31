//
//  ContributorView.swift
//  RepoWatcher
//
//  Created by Peter Hartnett on 8/31/22.
//

import Foundation
import SwiftUI
import WidgetKit

struct ContributorView : View {
    let repo: Repository
    
    var body: some View{
        VStack{
            HStack{
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2),
                      alignment: .leading,
                      spacing: 20){
                ForEach(repo.contributors) { contributor in
                    HStack{
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width:50, height: 50)
                            .clipShape(Circle())
                        VStack(alignment: .leading){
                            Text("\(contributor.login)")
                                .font(.caption).bold()
                                .minimumScaleFactor(0.7)
                                .lineLimit(2)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }.padding()
    }
}


