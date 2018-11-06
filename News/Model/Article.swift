//
//  Article.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//
import Foundation


struct Response: Codable {
    
    let articles : [Article]
    
}
struct Article: Codable {
    
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?

}
