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
    func getArticles(category: Category?, country: Country?) async
    func setNewsUrl(url: URL?)
    func setSelectedCountry(country: Country?)
    func getCountries() -> [Country]
}

final class NewsViewModel {
    
    weak var view: NewsViewInput?
    private var networkService: NetworkServiceProtocol?
    
    var articles: [Article] = []
    let countries: [Country] = [
        .ae, .ar, .at, .au, .be, .bg, .br, .ca, .ch, .cn, .co, .cu, .cz, .de, .eg, .fr, .gb, .gr, .hk,
        .hu, .id, .ie, .il, .it, .jp, .kr, .lt, .lv, .ma, .mx, .my, .ng, .nl, .no, .nz, .ph, .pl, .pt,
        .ro, .rs, .ru, .sa, .se, .sg, .si, .sk, .th, .tr, .tw, .ua, .us, .ve, .za
    ]
    
    init(view: NewsViewInput, networkService: NetworkServiceProtocol = NetworkService()) {
        self.view = view
        self.networkService = networkService
    }
    
}

// MARK: - News View Output

extension NewsViewModel: NewsViewOutput {
    
    func setNewsUrl(url: URL?) {
        view?.newsUrl = url
    }
    
    func getArticles(category selectedCategory: Category?, country selectedCountry: Country?) async {
        do {
            if let articles = try await networkService?.fetchArticles(category: selectedCategory, country: selectedCountry) {
                self.articles = articles
                
                DispatchQueue.main.async { [ weak self ] in
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
                    self.view?.showAlert(message: "Invalid URL \n Please check your selection")
                case .invalidResponse:
                    self.view?.showAlert(message: "Invalid Response \n Please check your internet connection")
                case .invalidData:
                    self.view?.showAlert(message: "invalid Data")
                }
            }
        }
    }
    
    var articleCount: Int {
        articles.count
    }
    
    func getArticle(_ index: Int) -> Article? {
        articles[safe: index]
    }
    
    func setSelectedCountry(country: Country?) {
        view?.selectedCountry = country
    }
    
    func getCountries() -> [Country] {
        return countries
    }
    
    
}

