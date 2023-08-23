//
//  SearchViewModel.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import Foundation

protocol SearchViewOutput {
    func setKeyword(enteredKeyword: String)
    func getKeyword() -> String
    func searchNews(keyword: String?) async
    func setFoundNewsUrl(url: URL?)
    func getFoundArticle(_ index: Int) -> Article?
    var articleCount: Int { get }
}

final class SearchViewModel {
    weak var view: SearchViewInput?
    
    private var networkService: NetworkServiceProtocol?
    private var keyword: String = ""
    private var foundArticles: [Article] = []
    
    
    init(view: SearchViewInput?, networkService: NetworkServiceProtocol?) {
        self.view = view
        self.networkService = networkService
    }
}
// MARK: - Search View Output
extension SearchViewModel: SearchViewOutput {
    
    func setKeyword(enteredKeyword: String) {
        self.keyword = enteredKeyword
    }
    
    func getKeyword() -> String {
        return keyword
    }
    
    func searchNews(keyword q: String?) async {
        do {
            if let articles = try await networkService?.fetchArticles(keyword: q) {
                self.foundArticles = articles
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.view?.reloadData()
                }
            }
        
        }catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                let error = error as! NetworkError
                switch error {
                case .invalidURL:
                    self.view?.showAlert(message: "Invalid URL \n Please check your entered keyword")
                case .invalidResponse:
                    self.view?.showAlert(message: "Invalid Response \n Please check your internet connection")
                case .invalidData:
                    self.view?.showAlert(message: "Invalid Data")
                }
            }
        }
    }
    
    func setFoundNewsUrl(url: URL?) {
        view?.sourceUrl = url
    }
    
    func getFoundArticle(_ index: Int) -> Article? {
        foundArticles[safe: index]
    }
    
    var articleCount: Int {
        foundArticles.count
    } 
}
