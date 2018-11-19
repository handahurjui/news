//
//  ArticleModelView.swift
//  News
//
//  Created by Andreea Hurjui on 13/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import Foundation
//import UIKit
import SDWebImage

protocol ArticleViewModelView {
    var titleLbl :  UILabel { get }
    var dateLbl: UILabel { get }
    var imageImageView : UIImageView? { get }
    var descriptionLbl : UILabel { get }
}
extension ArticleViewModelView {
    var imageImageView: UIImageView? { return nil }
}
class ArticleViewModel {
    
    var title : String
    var date : String
    var imageURL : URL?
    var description : String
    
    init(article: ResponseArticle.Article) {
        title = article.title
        
        if let articleDate =  article.publishedAt {
            date = DateFormatter.yyyyMMdd.string(from:articleDate)
        } else {
            date = ""
        }
        let noOfDays = abs(Calendar.current.dateComponents([.day], from: Date(), to: article.publishedAt ?? Date()).day!)
        
        if (noOfDays > 7) && (noOfDays <= 30)  {
            date += "  Published almost a month ago! "
        } else if (noOfDays >= 1 ) && (noOfDays <= 7 ) {
            date += "  Published almost a week ago!"
        } else {
            date += "  Published today!"
        }
       
        description = article.description ?? ""
        imageURL = article.imageURL
        
        
//        articleImageView.sd_setShowActivityIndicatorView(true)
//        articleImageView.sd_setIndicatorStyle(.gray)
//        if article.urlToImage == nil {
//            articleImageView.isHidden = true
//        } else {
//            articleImageView.isHidden = false
//            articleImageView.sd_setImage(with: article.imageURL, completed: nil)
//        }
    }
    func configure (view: ArticleViewModelView) {
        if let imageURL = imageURL {
            _ = view.imageImageView?.sd_setImage(with: imageURL, completed: nil)
            view.imageImageView?.isHidden = false
        } else {
            view.imageImageView?.isHidden =  true 
        }
        
        view.titleLbl.text = title
        view.dateLbl.text = date
        view.descriptionLbl.text = description
        
    }
}
