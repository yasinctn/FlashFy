//
//  CategoriesViewController.swift
//  FlashFy
//
//  Created by Yasin Cetin on 9.08.2023.
//

import UIKit

protocol CategoriesViewInput: AnyObject {
    var selectedCategory: Category? { get set }
}

final class CategoriesViewController: UIViewController {
    
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    
    var selectedCategory: Category?
    private var viewModel: CategoriesViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        viewModel = CategoriesViewModel(view: self)
    }
    
}

extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.categoryCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        if let category = viewModel?.getCategory(indexPath.row) {
            
            switch category {
               case .business,
                    .entertainment,
                    .general,
                    .health,
                    .science,
                    .sports,
                    .technology:
                categoryCell.configure(for: CategoryCellPresenter(category: category))
            }
        }
        return categoryCell
        
    }
    
    
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        viewModel?.setSelectedCategory(category: selectedCell.selectedCategory)
        performSegue(withIdentifier: "categoriesToNews", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoriesToNews" {
            let destination = segue.destination as! NewsViewController
            destination.selectedCategory = selectedCategory
            destination.title = "\((selectedCategory?.rawValue.capitalized) ?? "News")"
        }
    }
}


extension CategoriesViewController: CategoriesViewInput { }

private extension CategoriesViewController {
    
    func prepareCollectionView() {
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
}
