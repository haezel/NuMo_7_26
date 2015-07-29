//
//  NutrientItem.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/27/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import Foundation


class NutrientItem {
    
    var itemImage:String
    
    init(dataDictionary:Dictionary<String,String>) {
        itemImage = dataDictionary["itemImage"]!
    }
    
    class func newGalleryItem(dataDictionary:Dictionary<String,String>) -> NutrientItem {
        return NutrientItem(dataDictionary: dataDictionary)
    }
    
}