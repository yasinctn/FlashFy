//
//  SearchViewController.swift
//  FlashFy
//
//  Created by Yasin Cetin on 9.08.2023.
//

import UIKit

protocol SearchViewInput: AnyObject {
    func showAlert(message: String)
    func showAlertWithTextField()
    func reloadData()
    var sourceUrl: URL? { get set }
}

final class SearchViewController: UIViewController {

    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var searchButton: UIBarButtonItem!
    @IBOutlet private weak var filtrationButton: UIBarButtonItem!
    @IBOutlet private weak var foundNewsTableView: UITableView!
    
    private var viewModel: SearchViewOutput?
    var sourceUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel(view: self, networkService: NetworkService())
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        foundNewsTableView.isHidden = true
        infoLabel.isHidden = false
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        showAlertWithTextField()
    }
    
    @IBAction func filtrationButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.articleCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier) as! NewsCell
        
        if let article = viewModel?.getFoundArticle(indexPath.row) {
            cell.configure(for: NewsCellPresenter(title: article.title,
                                                  date: article.publishedAt,
                                                  imageUrl: article.urlToImage,
                                                  sourceUrl: article.url))
        }
        return cell
    }

}

// MARK: -  Table View Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! NewsCell
        viewModel?.setFoundNewsUrl(url: selectedCell.sourceUrl)
        performSegue(withIdentifier: "foundNewsToWeb", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "foundNewsToWeb" {
            let destination = segue.destination as! WebScreenViewController
            destination.selectedNewsUrl = sourceUrl
            
        }
    }
}

// MARK: -  Search View Input
extension SearchViewController: SearchViewInput, AlertPresentable {
    func showAlert(message: String) {
        presentAlert(message)
    }
    
    func reloadData() {
        foundNewsTableView.reloadData()
    }
    
    
    func showAlertWithTextField() {
        
        let alertController = UIAlertController(title: "Search News", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter subject"
        }
        let findAction = UIAlertAction(title: "Find", style: .default) { [ weak self ] findAction in
            guard let self else { return }
            if let textField = alertController.textFields{
                if let text = textField[0].text{
                    self.viewModel?.setKeyword(enteredKeyword: text)
                    foundNewsTableView.isHidden = false
                    infoLabel.isHidden = true
                    Task {
                        await self.viewModel?.searchNews(keyword: self.viewModel?.getKeyword())
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(findAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
}

// MARK: - Private Methods
private extension SearchViewController {
    func prepareTableView() {
        foundNewsTableView.dataSource = self
        foundNewsTableView.delegate = self
    }
}
