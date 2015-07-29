//
//  FoodLogged.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 6/2/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//
//  FoodLog Struct Cooresponds to sqlite table food_log

import Foundation

struct FoodLog {
    
    var foodId : Int
    var amountConsumedGrams : Double
    var date : String
    var time : String
    var wholeNumber : Double
    var fraction : Double
    var measure : String
    
}