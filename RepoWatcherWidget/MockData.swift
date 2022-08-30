//
//  MockData.swift
//  RepoWatcher
//
//  Created by Peter Hartnett on 8/29/22.
//

import Foundation

extension Repository{
    static let placeHolder = Repository(name: "Your Repo",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: true,
                                        forks: 65,
                                        watchers: 123,
                                        openIssues: 55,
                                        pushedAt: "2021-08-09T18:19:30Z",
                                        avatarData: Data())
    
    static let placeHolderB = Repository(name: "Second Repo",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: false,
                                        forks: 20,
                                        watchers: 999,
                                        openIssues: 0,
                                        pushedAt: "2022-08-09T18:19:30Z",
                                        avatarData: Data())
}
