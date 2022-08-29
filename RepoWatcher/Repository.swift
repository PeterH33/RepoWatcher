//
//  Repository.swift
//  RepoWatcher
//
//  Created by Peter Hartnett on 8/29/22.
//

import Foundation

//using decodable as we are not sending any info
//Using the decodable system with JSON and converting from snake case it is critically important that the variable names here are spelled exactly right, we will get a data error throw if they are wrong at all.
struct Repository: Decodable{
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    static let placeHolder = Repository(name: "Your Repo",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: true,
                                        forks: 65,
                                        watchers: 123,
                                        openIssues: 55,
                                        pushedAt: "2021-08-09T18:19:30Z")
}

struct Owner: Decodable{
    let avatarUrl: String
}
