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
    var readMoreBtn : UIButton { get }
}
extension ArticleViewModelView {
    var imageImageView: UIImageView? { return nil }
}
class ArticleViewModel {
    
    var title : String
    var date : String
    var imageURL : URL? 
    var description : String
    var isExpanded : Bool = false
    
    func isStringLink(string: String) -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && string.characters.count > 0) else { return false }
        if detector!.numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count)) > 0 {
            return true
        }
        return false
    }
    
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
        
//        if let url = article.urlToImage?.isValidURL  {
            imageURL =  article.imageURL
//        }
        
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
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.blue]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        
        if let imageURL = imageURL {
            view.imageImageView?.sd_setShowActivityIndicatorView(true)
            view.imageImageView?.sd_setIndicatorStyle(.gray)
            _ = view.imageImageView?.sd_setImage(with: imageURL, completed: nil)
            view.imageImageView?.isHidden = false
        } else {
            view.imageImageView?.isHidden =  true 
        }
//        view.descriptionLbl.isHidden = isExpanded
        if isExpanded {
            view.descriptionLbl.numberOfLines = 0
            view.readMoreBtn.setTitle("Read Less", for: .normal)
        } else {
            view.descriptionLbl.numberOfLines = 1
            view.readMoreBtn.setTitle("Read More", for: .normal)
        }
        view.titleLbl.attributedText = NSAttributedString(string: "\(title)", attributes: titleAttributes)
        view.dateLbl.text = date
        view.descriptionLbl.attributedText = NSMutableAttributedString(string: "\(description)", attributes: subtitleAttributes)
        
    }
}
