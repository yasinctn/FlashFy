//
//  Article.swift
//  FlashFy
//
//  Created by Yasin Cetin on 15.08.2023.
//

import Foundation

struct Article: Codable {
    
    let author: String
    let title: String
    let description: String
    let url: URL
    let urlToImage: URL
    let publishedAt: String
    let content: String
    
    struct source {
        let id: String
        let name: String
    }
}
