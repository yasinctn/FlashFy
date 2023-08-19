//
//  WebViewModel.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import Foundation

protocol WebViewOutput {
    func getRequest(url: URL?) -> URLRequest?
}

final class WebViewModel {
    
    private weak var view: WebScreenInput?
    private let networkService: NetworkServiceProtocol?
    
    init(view: WebScreenInput?, networkService: NetworkServiceProtocol?) {
        self.view = view
        self.networkService = networkService
    }
}

// MARK: - Web View Output

extension WebViewModel: WebViewOutput {
    func getRequest(url: URL?) -> URLRequest? {
        guard let url else { return nil }
        return URLRequest(url: url)
    }
}


