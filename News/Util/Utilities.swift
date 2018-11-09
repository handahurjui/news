//
//  Utilities.swift
//  News
//
//  Created by Andreea Hurjui on 07/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
