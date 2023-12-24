//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 21/06/2023.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {} // only instance

    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        
        let endPoint = baseUrl + "/\(username)/followers?per_page=99&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // ok response
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume() // starts networkCall
    }
    
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        
        let endPoint = baseUrl + "/\(username)"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
