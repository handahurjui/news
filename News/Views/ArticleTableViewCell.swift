//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import UIKit

import SDWebImage

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleDateLbl: UILabel!
    @IBOutlet weak var articleDescriptionLbl: UILabel!
    
    var article : ResponseArticle.Article? {
        didSet {
             guard let article = article else { return }
            
            articleTitleLbl.text =  article.title
            articleDescriptionLbl.text = article.description
            articleDateLbl.text = DateFormatter.yyyyMMdd.string(from: article.publishedAt!)
            articleImageView.sd_setShowActivityIndicatorView(true)
            articleImageView.sd_setIndicatorStyle(.gray)
            if article.urlToImage == nil {
                articleImageView.isHidden = true
            } else {
                articleImageView.isHidden = false
                articleImageView.sd_setImage(with: article.imageURL, completed: nil)
            }
            
        }
       
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        articleImageView.sd_cancelCurrentImageLoad()
        articleTitleLbl.text = nil
        articleDateLbl.text = nil
        articleDescriptionLbl.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
