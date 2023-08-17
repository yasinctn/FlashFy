//
//  NewsViewModel.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import Foundation

protocol NewsViewOutput {
    func getArticle(_ index: Int) -> Article?
    var articleCount: Int { get }
    func getArticles() async
}

final class NewsViewModel {
    
    weak var view: NewsViewInput?
    private var networkService: NetworkServiceProtocol?
    
    var articles: [Article] = []
    
    init(view: NewsViewInput, networkService: NetworkServiceProtocol = NetworkService()) {
        self.view = view
        self.networkService = networkService
    }
    
}

// MARK: - News View Output

extension NewsViewModel: NewsViewOutput {
    func getArticles() async {
        do {
            if let articles = try await networkService?.fetchArticles(category: Category.general) {
                
                self.articles = articles
                
                DispatchQueue.main.async { [ weak self ] in
                    guard let self else { return }
                    self.view?.reloadData()
                }
            }
        
        }catch {
            print(error.localizedDescription)
        }
    }
    
    var articleCount: Int {
        articles.count
    }
    
    func getArticle(_ index: Int) -> Article? {
        articles[safe: index]
    }
}

