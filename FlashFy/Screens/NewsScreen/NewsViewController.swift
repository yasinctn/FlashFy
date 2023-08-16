//
//  NewsViewController.swift
//  FlashFy
//
//  Created by Yasin Cetin on 9.08.2023.
//

import UIKit

protocol NewsViewInput: AnyObject {
    func reloadData()
}

final class NewsViewController: UIViewController {

    @IBOutlet private weak var newsTableView: UITableView!
    
    private var viewModel: NewsViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsViewModel(view: self, networkService: NetworkService())
        prepareTableView()
        
        Task {
            await viewModel?.getArticles()
        }
    }
    
}

//MARK: - Table View Data Source

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.articleCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier) as! NewsCell
        
        if let article = viewModel?.getArticle(indexPath.row) {
            cell.configure(for: NewsCellPresenter(title: article.title,
                                                  date: article.publishedAt,
                                                  imageUrl: article.urlToImage,
                                                  sourceUrl: article.url))
        }
        return cell
    }
}

// MARK: - Table View Delegate

extension NewsViewController: UITableViewDelegate {
    
}

// MARK: - Table View Input

extension NewsViewController: NewsViewInput {
    func reloadData() {
        newsTableView.reloadData()
    }
}

// MARK: - Private Methods

private extension NewsViewController {
    func prepareTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
}
