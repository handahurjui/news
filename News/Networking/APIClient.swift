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
    
     let baseURL : String
     let apiKey :String
    
    static let sharedInstance : APIClient = {
        let url = "https://newsapi.org/v2"
        let apiKey = "b09b33b11bca4deca889f207fb765ab7"
        return APIClient(url: url,apiKey: apiKey)
    }()
    
    private enum ResourcePath: CustomStringConvertible {
        case TopHeadlinesFromSource(source: String)
    
        var description: String {
            switch self {
            case .TopHeadlinesFromSource(let source): return "/v2/sources?q=\(source)"
            }
        }
    }
    
    enum Endpoints: CustomStringConvertible {
        case TopHeadlines
        case Everything
        case Sources
        
        var description: String {
            switch self {
            case .TopHeadlines: return "top-headlines"
            case .Everything: return "everything"
            case .Sources: return "sources"
            }
        }
    }
    
    init(url: String, apiKey: String) {
        self.baseURL = url
        self.apiKey = apiKey
    }
  
    func getSources(withEndpoint: Endpoints, completion: @escaping ([ResponseSource.Source])-> Void){
        let urlString = baseURL + "/" + withEndpoint.description
        
        let headers = [
            "Content-Type":"application/x-www-form-urlencoded",
            "authorization": "\(apiKey)"
        ]
     
//        var request = NSMutableURLRequest(url: URL(string: urlString)!)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue("\(apiKey)", forHTTPHeaderField: "authorization")
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                print("data: \(data)")
                do {
                    let sourcesResponse = try decoder.decode(ResponseSource.self, from: data )
                    completion(sourcesResponse.sources)
                } catch {
                    NSLog("Error parsing articles: \(error.localizedDescription)")
                }
                
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available :(")
            }
        }
    }
    func getArticles(withEndpoint: Endpoints,page: Int = 1,source: String = "abc-news" , completion: @escaping ([ResponseArticle.Article])-> Void ){
        let urlString =  baseURL + "/" + withEndpoint.description
        
        let headers = [
            "Content-Type":"application/x-www-form-urlencoded",
            "authorization" : "\(self.apiKey)"
        ]
        var parameters : [String:Any] = [
            //            "country": "\(withSource)"
            "page": page,
            "sources": source
        ]
        
        
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            
            if let data = response.result.value {
                let decoder = JSONDecoder()
                
//                                decoder.dateDecodingStrategy = .iso8601
//                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                print("data: \(data)")
                
                do {
                    let articleResponse = try decoder.decode(ResponseArticle.self, from: data )
                    completion(articleResponse.articles)
               
                } catch {
                    NSLog("Error parsing posts: \(error.localizedDescription)")
                }
                
                
//                do {
//                    let articleResponse = try decoder.decode(ResponseArticle.self, from: data )
//                    completion(articleResponse.articles)
//
//                    decoder.dateDecodingStrategy = .iso8601
//                    let articleResponse = try decoder.decode(ResponseArticle.self, from: data )
//                    completion(articleResponse.articles)
//
//
//                } catch {
//
//
//                    NSLog("Error parsing articles: \(error.localizedDescription)")
//                }
                //
                //
                //                do {
                //                    let articleResponse = try decoder.decode(ResponseArticle.self, from: data )
                //                    completion(articleResponse.articles)
                //                } catch {
                //                    NSLog("Error parsing articles: \(error.localizedDescription)")
                //                }
                
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available :(")
            }
            
        }
        
    }
}

