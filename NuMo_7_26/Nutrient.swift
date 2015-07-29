//
//  Nutrient.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 6/1/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//
//  This Nutrient struct holds a nutrient Id, unit, name, tagname and the amount of this nutrient in the cooresponding food
//  A better name for this struct would have been NutrientContentInAFood (associated with a food)

import Foundation

struct Nutrient {
    
   // var foodId : Int
    var nutrientId : Int
    var amountPerHundredGrams : Double
    var units : String
    var name : String
    var tagName : String
    
}