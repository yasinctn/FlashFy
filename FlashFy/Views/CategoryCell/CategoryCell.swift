//
//  CategoryCell.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    
    static let identifier = "categoryCell"
    private(set) var selectedCategory: Category = .general
    
    func configure(for presentedCell: CategoryCellPresenter) {
        categoryImageView.image = UIImage(named: presentedCell.category.rawValue.capitalized)
        categoryTitleLabel.text = presentedCell.category.rawValue.capitalized
        selectedCategory = presentedCell.category
        categoryImageView.layer.cornerRadius = 20
        view.layer.cornerRadius = 20
        
    }
}
