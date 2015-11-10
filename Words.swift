//
//  Words.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 11/9/15.
//  Copyright © 2015 kathrynmanning. All rights reserved.
//
import Foundation

extension String {
    func words() -> [String] {
        
        let range = Range<String.Index>(start: self.startIndex, end: self.endIndex)
        var words = [String]()
        
        self.enumerateSubstringsInRange(range, options: NSStringEnumerationOptions.ByWords) { (substring, _, _, _) -> () in
            words.append(substring!)
        }
        
        return words
    }
}
