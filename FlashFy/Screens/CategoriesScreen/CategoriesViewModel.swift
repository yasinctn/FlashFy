//
//  CategoriesViewModel.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import Foundation

protocol CategoriesViewOutput {
    func getCategory(_ index: Int) -> Category?
    var categoryCount: Int { get }
    func setSelectedCategory(category: Category?)
}

final class CategoriesViewModel {
    
    weak var view: CategoriesViewInput?
    private(set) var categories: [Category] = [.business,
                                               .entertainment,
                                               .general,
                                               .health,
                                               .science,
                                               .sports,
                                               .technology]
    
    init(view: CategoriesViewInput? = nil) {
        self.view = view
    }
}

extension CategoriesViewModel : CategoriesViewOutput {
    
    var categoryCount: Int {
        categories.count
    }
  
    func getCategory(_ index: Int) -> Category? {
        categories[safe: index]
    }
    
    func setSelectedCategory(category: Category?) {
        view?.selectedCategory = category
    }
}
