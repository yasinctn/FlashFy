//
//  NetworkService.swift
//  FlashFy
//
//  Created by Yasin Cetin on 15.08.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchArticles(category: Category?, country: Country?) async throws -> [Article]
    func fetchArticles(keyword q: String?) async throws -> [Article]
}

final class NetworkService: NetworkServiceProtocol {
    
    func fetchArticles(keyword q: String?) async throws -> [Article] {
        let apiKey = getApiKey()
        let endpoint = "https://newsapi.org/v2/everything?qInTitle=\(q ?? "")&apiKey=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
    
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(NewsResponse.self, from: data)
            return response.articles
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    
   
    func fetchArticles(category: Category?, country: Country?) async throws -> [Article] {
        
        let apiKey = getApiKey()
        let endpoint = "https://newsapi.org/v2/top-headlines?country=\(country ?? .us)&category=\(category ?? .general)&apiKey=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
    
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(NewsResponse.self, from: data)
            return response.articles
        } catch {
            throw NetworkError.invalidData
        }

    }
    
    
    
}

// MARK: - Private Methods

private extension NetworkService {
    func getApiKey() -> String {
        if let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let configDictionary = NSDictionary(contentsOfFile: configPath) as? [String: Any] {
           
            if let apiKey = configDictionary["APIKey"] as? String {
                return apiKey
            } else {
                print("API Key not found.")
            }
        } else {
            print("Config.plist not found")
        }
        return ""
    }
}
