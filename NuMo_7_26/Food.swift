//
//  Food.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 5/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import Foundation

class Food : NSObject {
    
    let desc : String
    let id : Int
    
    init(desc : String, id : Int) {
        self.desc = desc
        self.id = id
    }
}