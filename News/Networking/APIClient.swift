//
//  APIClient.swift
//  News
//
//  Created by Andreea Hurjui on 05/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
     let baseURL : URL
     let apiKey :String
    
    static let sharedInstance : APIClient = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines")
        let apiKey = "b09b33b11bca4deca889f207fb765ab7"
        return APIClient(url: url!,apiKey: apiKey)
    }()
    
//    private enum ResourcePath {
//        case TopHeadlines
//        case Everything
//        case Sources
//        case TopHeadlinesFromSource(source: )
//    
//        
//        var description: String {
//            switch self {
//            case .TopHeadlines: return ""
//            case .Everything: return "/api/v1/stories"
//            case .Sources: return "/v2/sources"
//           
//            }
//        }
//    }
    
    init(url: URL, apiKey: String) {
        self.baseURL = url
        self.apiKey = apiKey
    }
  
    
    func getArticles(completion: @escaping ([Article])-> Void ){
        let headers = [
            "Content-Type":"application/x-www-form-urlencoded",
            "authorization" : "\(self.apiKey)"
        ]
        var parameters : [String:String] = [
            "country": "us"
        ]
        
       
        Alamofire.request(self.baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            
            if let data = response.result.value {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                print("data: \(data)")
                do {
                    let articleResponse = try decoder.decode(Response.self, from: data )
                    completion(articleResponse.articles)
                } catch {
                    NSLog("Error parsing articles: \(error.localizedDescription)")
                }
                
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available :(")
            }
            
        }
        
    }
}

