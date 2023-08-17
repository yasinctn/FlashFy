//
//  CategoriesViewController.swift
//  FlashFy
//
//  Created by Yasin Cetin on 9.08.2023.
//

import UIKit

protocol CategoriesViewInput: AnyObject {
    
}

final class CategoriesViewController: UIViewController {
    
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    
    private var viewModel: CategoriesViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        viewModel = CategoriesViewModel(view: self)
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CategoriesViewController: CategoriesViewInput {
    
}

private extension CategoriesViewController {
    
    func prepareCollectionView() {
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
}
