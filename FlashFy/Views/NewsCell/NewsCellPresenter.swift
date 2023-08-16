//
//  NewsCellPresenter.swift
//  FlashFy
//
//  Created by Yasin Cetin on 15.08.2023.
//

import Foundation

struct NewsCellPresenter {
    var title: String?
    var date: String?
    var imageUrl: String?
    var sourceUrl: String?
    
    init(title: String? = nil, date: String? = nil, imageUrl: String? = nil, sourceUrl: String? = nil) {
        self.title = title
        self.date = date
        self.imageUrl = imageUrl
        self.sourceUrl = sourceUrl
    }
}
