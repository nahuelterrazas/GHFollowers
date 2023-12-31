//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 21/06/2023.
//

import UIKit

class NetworkManager {
    
    static let shared   = NetworkManager()
    private let baseUrl = "https://api.github.com/users"
    let cache           = NSCache<NSString, UIImage>()
    let decoder                 = JSONDecoder()

    
    private init() {
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endPoint = baseUrl + "/\(username)/followers?per_page=99&page=\(page)"
        
        guard let url = URL(string: endPoint) else { throw GFError.invalidUsername }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw GFError.invalidResponse }
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    
    func getUserInfo(for username: String) async throws -> User {
        
        let endPoint = baseUrl + "/\(username)"
        
        guard let url = URL(string: endPoint) else { throw GFError.invalidUsername }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    
    func downloadImage(from url: String) async -> UIImage? {
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey) { return image }
        
        guard let url = URL(string: url) else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            self.cache.setObject(image, forKey: cacheKey)
            return image
        } catch{
            return nil
        }
    }
}
