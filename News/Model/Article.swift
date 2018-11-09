//
//  Article.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//
import Foundation


struct ResponseArticle: Codable {
    
    let status: String
    let articles : [Article]
    let totalResults: Int
    
    struct Article: Codable, Hashable {
        
        let title: String
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: Date?
        
        var articleURL: URL? {
            if let url = url {
                return URL(string: url)
            }
            return nil
        }
        
        var imageURL : URL? {
            if let url = urlToImage {
                return URL(string: url)
            }
            return nil
        }
        
    }
}

