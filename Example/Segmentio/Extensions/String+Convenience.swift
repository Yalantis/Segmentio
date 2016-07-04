//
//  String+Convenience.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import Foundation

extension String {
    
    func stringFromCamelCase() -> String {
        var string = self
        string = string.stringByReplacingOccurrencesOfString(
            "([a-z])([A-Z])",
            withString: "$1 $2",
            options: .RegularExpressionSearch,
            range: Range<String.Index>(string.startIndex..<string.endIndex)
        )
        
        string.replaceRange(startIndex...startIndex, with: String(self[startIndex]))
        
        return String(string.characters.prefix(1)).capitalizedString + String(string.lowercaseString.characters.dropFirst())
    }
    
}