//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Peter Hartnett on 8/29/22.
//

import Foundation

//Apple recommends creating network managers as singletons, same with sound providers, this makes me happy as that is my natural inclination.
class NetworkManager{
    //for singleton, the shared network manager is static 
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    
    private init(){
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(atUrl urlString: String) async throws -> Repository {
        
        //Make sure the URL is a real url
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        //run a async url session
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //check that the response is good
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        //Try to decode the data that was pulled
        do{
            return try decoder.decode(Repository.self, from: data)
        } catch {
            //This error will probably show if there is a mistype in the repositories names.
            throw NetworkError.invalidRepoDATA
        }
        
    }
    
    //This function is setup to get an image from a urlSession, but if it gets nothing back from the session, it just returns nil because it means we just don't have an image so we will put in a placeholder instead.
    func downloadImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else {return nil}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }
}



enum NetworkError: Error{
    case invalidURL
    case invalidResponse
    case invalidRepoDATA
}

enum RepoURL{
    static let swiftNews = "https://api.github.com/repos/sallen0400/swift-news"
    static let publish = "https://api.github.com/repos/johnsundell/publish"
    static let google = "https://api.github.com/repos/google/GoogleSignIn-iOS"
    static let Instafilter = "https://api.github.com/repos/PeterH33/InstaFilter"
}
