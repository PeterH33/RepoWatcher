//
//  Repository.swift
//  RepoWatcher
//
//  Created by Peter Hartnett on 8/29/22.
//

import Foundation

//using decodable as we are not sending any info
//Using the decodable system with JSON and converting from snake case it is critically important that the variable names here are spelled exactly right, we will get a data error throw if they are wrong at all.
struct Repository{
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    var avatarData: Data
    var contributors: [Contributor] = []
    
}

//This structure can break out our JSON decoding data and let us manipulate things in the repository as well.
extension Repository{
    struct CodingData: Decodable{
        let name: String
        let owner: Owner
        let hasIssues: Bool
        let forks: Int
        let watchers: Int
        let openIssues: Int
        let pushedAt: String
        
        var repo: Repository{
            Repository(name: name,
                       owner: owner,
                       hasIssues: hasIssues,
                       forks: forks,
                       watchers: watchers,
                       openIssues: openIssues,
                       pushedAt: pushedAt,
                       avatarData: Data())
        }
    }
}

struct Owner: Decodable{
    let avatarUrl: String
}
