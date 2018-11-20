//
//  Article.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//
import Foundation


struct ResponseArticle: Codable {
    
//    let status: String
    let articles : [Article]
//    let totalResults: Int
    
    init(from decoder:Decoder) throws {
        let codingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        articles = try codingContainer.decode([ResponseArticle.Article].self, forKey: .articles)
        
    }
    
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
            if let url = urlToImage, url.isValidURL {
                return URL(string: url)
            }
            return nil
        }
        
    }
}
extension ResponseArticle.Article {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        let dateString = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        let formatterFull = DateFormatter.iso8601Full
        let formatter = DateFormatter.iso8601ss
        if let date = formatter.date(from: dateString ?? "") {
            publishedAt = date
        } else {
            if let date = formatterFull.date(from: dateString ?? "") {
                publishedAt = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
//            throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            
        }
    }
}

