//
//  Source.swift
//  News
//
//  Created by Andreea Hurjui on 08/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import Foundation

struct ResponseSource : Codable {
    
    let status: String
    let sources: [Source]
    
    struct Source: Codable {
        
        let id: String
        let name: String
        
    }
}
