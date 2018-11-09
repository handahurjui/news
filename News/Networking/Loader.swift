//
//  Loader.swift
//  News
//
//  Created by Andreea Hurjui on 08/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import Foundation

class Loader {
    
    typealias LoaderCompletion = (_ articles:[ResponseArticle.Article]) ->()
    
    let networkClient = APIClient.sharedInstance
    var hasMore : Bool = false
    var page = 1
    var isLoading : Bool = false
    let endpoint : APIClient.Endpoints
    
    init(_ endpoint: APIClient.Endpoints = .TopHeadlines) {
        self.endpoint = endpoint
    }
    
    func load(endpoint: APIClient.Endpoints,page: Int = 1,source: String = "abc-news" , completion: @escaping LoaderCompletion) {
        if isLoading { return }
        
        isLoading = true
        networkClient.getArticles(withEndpoint: endpoint, page: page, source: source)  { [weak self] articles in
            guard let strongSelf = self else { return }
            strongSelf.hasMore = articles.count > 0
            
            strongSelf.isLoading = false
            completion(articles)
            
        }
        
        
        
    }
    
    func next(endpoint: APIClient.Endpoints,source: String = "abc-news" ,completion: @escaping (_ articles:[ResponseArticle.Article]) ->()) {
        if isLoading {
            return
        }
        
        page = page + 1
        load(endpoint: endpoint, page: page, completion: completion)
    }
}
