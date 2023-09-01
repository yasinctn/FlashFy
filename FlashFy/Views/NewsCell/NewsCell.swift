//
//  NewsCell.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import UIKit
import SDWebImage

final class NewsCell: UITableViewCell {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsDateLabel: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    
    static let identifier = "newsCell"
    private(set) var sourceUrl: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for presentedCell: NewsCellPresenter) {
        if let imageUrl = URL(string: presentedCell.imageUrl ?? "") {
            newsImageView.sd_setImage(with:imageUrl)
        }else {
            newsImageView.image = UIImage(named: "FlashNews")
        }
        newsTitleLabel.text = presentedCell.title
        newsDateLabel.text = presentedCell.date
        sourceUrl = URL(string: presentedCell.sourceUrl ?? "")
        newsImageView.layer.cornerRadius = 25
        view.layer.cornerRadius = 25

    }
}
