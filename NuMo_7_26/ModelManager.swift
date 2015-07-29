//
//  ModelManager.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 5/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import Foundation

let sharedInstance = ModelManager()

class ModelManager : NSObject
{
    var database : FMDatabase? = nil
    
    class var instance : ModelManager
    {
        sharedInstance.database = FMDatabase(path: Util.getPath("usda.sql3"))
        var path = Util.getPath("usda.sql3")
        
        println("!!!!!!!path: \(path)")
        return sharedInstance
    }
    
    
    func getAllFoodData()
    {
        sharedInstance.database!.open()
        var resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM food", withArgumentsInArray: nil)
        
        //var nutrientIdColumn: String = "short_desc"
        
        if (resultSet != nil) {
            while resultSet.next() {
                
                let id = resultSet.stringForColumn("id")
                let idInt = id.toInt()!
                let desc = resultSet.stringForColumn("long_desc")
                let descR = String(desc)
                
                let foodItem : Food = Food(desc: descR, id: idInt)
                allFoods.append(foodItem)
                
            }
        }
        sharedInstance.database!.close()
    }
    
    //-----------Get an Array of Weights for a particular food------------//
    
    func getMeasures(foodId : Int) -> [Weight]
    {
        sharedInstance.database!.open()
        var query : String = "SELECT * FROM weight WHERE food_id=\(foodId)"
        var resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: nil)
        
        var measures = [Weight]()
        
        if (resultSet != nil) {
            while resultSet.next() {
                
                let foodId = resultSet.stringForColumn("food_id")
                println(foodId)
                let idInt = foodId.toInt()!
                let seq = resultSet.stringForColumn("seq")
                let seqInt = seq.toInt()!
                let amount = resultSet.doubleForColumn("amount_unitmod")
                let measure = resultSet.stringForColumn("measure_description")
                let weightGrams = resultSet.doubleForColumn("gram_weight")
                
                let weightInfo : Weight = Weight(foodId: idInt, sequence: seqInt, amountPer: amount, measure: measure, weightInGrams: weightGrams)
                
                measures.append(weightInfo)
            }
            sharedInstance.database!.close()
            return measures
        }
        else
        {
            println("Weight info for food id \(foodId) not found.")
        }
        sharedInstance.database!.close()
        return measures
    }
    
    //-----------Get an Array of all Nutrients and their total amount consumed for all foods-----------//
    //
    //           returns an dictionary of key nutrientId and values: Nutrients, total amounts
    //
    
    func getNutrientTotals(date : String) -> Dictionary<Int, (nutrient:Nutrient, total:Double)>
    {
        //var loggedItems = (getLoggedItems()).0
        
        var nt = Dictionary<Int, (nutrient:Nutrient, total:Double)>()
        
        //will be an array of pairs of (foodId, amountConsumed)
        var arrayOfLogged = [(Int, Double)]()
        
        sharedInstance.database!.open()
        
        let query2 = "SELECT * FROM food_log WHERE date_logged=?"
        var resultSet2: FMResultSet! = sharedInstance.database!.executeQuery(query2, withArgumentsInArray: [date])
        
        if resultSet2 != nil
        {
            while resultSet2.next()
            {   let foodId = resultSet2.stringForColumn("food_id")
                println(foodId)
                let foodIdInt = foodId.toInt()
                
                let amountConsumed = resultSet2.doubleForColumn("amount_consumed_grams")
                println(amountConsumed)
                
                arrayOfLogged.append((foodIdInt!, amountConsumed))
            }
        }
        
        sharedInstance.database!.close()
        
        if arrayOfLogged.count > 0
        {
            for item in arrayOfLogged
            {
                let itsNutrients = getNutrients(item.0)
                
                
                for nutrient in itsNutrients
                {
                    let nutrientId = nutrient.nutrientId
                    
                    let nutrientContentConsumed = (nutrient.amountPerHundredGrams/100.0) * item.1
                    
                    var previousTotal = 0.0
                    
                    var prevNutrient = nt[nutrientId]
                    
                    if prevNutrient != nil
                    {
                        previousTotal = prevNutrient!.total
                    }
                    
                    let total = previousTotal + nutrientContentConsumed
                    
                    nt[nutrientId] = (nutrient, total)
                }
            }
        }
            
        else //food log is empty so we need to just return a dict nt of Id<Nutrient, 0.0>
        {
            let allNutrients = getAllNutrients()
            
            for nutrient in allNutrients
            {
                var nutrientId = nutrient.nutrientId
                
                nt[nutrientId] = (nutrient, 0.0)
            }
        }
        
        
        return nt
    }
    
    
    
    //-----------Get an Array of Nutrients, Nutrient Amounts, and Nutrient Units for a particular food-----------//
    //                     -> and return the array of Nutrients
    //           currently finds ALL nutrient info for the particular food - not just common nutrients           //
    //           would need to use JOIN on common nutrient to narrow down...                                     //
    
    func getNutrients(foodId : Int) -> [Nutrient]
    {
        sharedInstance.database!.open()
        var queryNutrition : String = "SELECT * FROM nutrition WHERE food_id=\(foodId)"
        var queryNutrient : String = ""
        var resultSetA: FMResultSet! = sharedInstance.database!.executeQuery(queryNutrition, withArgumentsInArray: nil)
        
        var nutrients = [Nutrient]()
        
        if (resultSetA != nil)
        {
            while resultSetA.next() //each associated nutrient
            {
                let foodId = resultSetA.stringForColumn("food_id")
                let idInt = foodId.toInt()!
                let nutrientId = resultSetA.stringForColumn("nutrient_id")
                let nutrientIdInt = nutrientId.toInt()!
                let amountPerHundredGrams = resultSetA.doubleForColumn("amount")
                var name : String = ""
                var units : String = ""
                var tagName : String = ""
                
                
                let queryNutrient : String = "SELECT * FROM nutrient WHERE id=\(nutrientId)"
                var resultSetB: FMResultSet! = sharedInstance.database!.executeQuery(queryNutrient, withArgumentsInArray: nil)
                
                if (resultSetB != nil)
                {
                    while resultSetB.next()
                    {
                        name = resultSetB.stringForColumn("name")
                        units = resultSetB.stringForColumn("units")
                        tagName = resultSetB.stringForColumn("tagname")
                        
                    }
                }
                else
                {
                    println("Nutrient Info for nutrient \(nutrientId) not found.")
                }
                
                //let theNutrient : Nutrient = Nutrient(foodId: idInt, nutrientId: nutrientIdInt, amountPerHundredGrams: amountPerHundredGrams, units: units, name: name, tagName: tagName)
                let theNutrient : Nutrient = Nutrient(nutrientId: nutrientIdInt, amountPerHundredGrams: amountPerHundredGrams, units: units, name: name, tagName: tagName)
                
                nutrients.append(theNutrient)
            }
            sharedInstance.database!.close()
            return nutrients
        }
        else
        {
            println("Nutrition info for food id \(foodId) not found.")
        }
        sharedInstance.database!.close()
        return nutrients
    }
    
    //---------Add an Item to food_log table---------//
    
    func addFoodItemToLog(item : FoodLog) -> Bool
    {
        
        sharedInstance.database!.open()
        
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO food_log (food_id, amount_consumed_grams, date_logged, time_logged, whole_number, fraction, measure_description) VALUES (?,?,?,?,?,?,?)", withArgumentsInArray: [item.foodId, item.amountConsumedGrams, item.date, item.time, item.wholeNumber, item.fraction, item.measure])
        
        sharedInstance.database!.close()
        return isInserted
    }
    
    //----------Update amount of Item in foodLog table-----------//
    
    func updateFoodItemLogAmount(item : FoodLog) {
    
        sharedInstance.database!.open()
        
        println(item.amountConsumedGrams)
        println(item.wholeNumber)
        println(item.fraction)
        println(item.measure)
        println(item.date)
        println(item.time)
        println(item.foodId)

        
//        let query = "UPDATE food_log SET amount_consumed_grams=?, whole_number=?, fraction=? WHERE date_logged=? AND time_logged=?"
//        let isUpdated = sharedInstance.database!.executeUpdate(query, withArgumentsInArray: [item.amountConsumedGrams, item.wholeNumber, item.fraction, item.measure, item.date, item.time])
//        println("should have updated \(isUpdated)")
//        sharedInstance.database!.close()
//        return isUpdated
        
        deleteItemFromFoodLog(item.date, time: item.time)
        addFoodItemToLog(item)
        
    }
    
    // gets all of the logged food_log items for date provided
    // returns a tuple of (array of foodForTable items, number of items)
    
    func getLoggedItems(date : String) -> ([FoodForTable], Int)
    {
        
        sharedInstance.database!.open()
        
        var foodsForTable = [FoodForTable]()
        
        let query = "SELECT COUNT(*) as cnt FROM food_log WHERE date_logged=?"
        var resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: [date])
        
        var count : Int32 = 0
        if resultSet != nil
        {
            while resultSet.next()
            {
                count = resultSet.intForColumn("cnt")
                println("There are \(count) items logged on date \(date).")
            }
        }
        
        let query2 = "SELECT * FROM food_log WHERE date_logged=?"
        var resultSet2: FMResultSet! = sharedInstance.database!.executeQuery(query2, withArgumentsInArray: [date])
        
        if resultSet2 != nil
        {
            while resultSet2.next()
            {
                let foodId = resultSet2.stringForColumn("food_id")
                let foodIdInt : Int = foodId.toInt()!
                
                var descResult : FMResultSet! = sharedInstance.database!.executeQuery("SELECT long_desc FROM food WHERE id=?", withArgumentsInArray: [foodId])
                
                var foodDesc = ""
                if descResult != nil
                {
                    while descResult.next()
                    {
                        foodDesc = descResult.stringForColumn("long_desc")
                    }
                }
                
                
                let time = resultSet2.stringForColumn("time_logged")
                println("Time of this item added: \(time)")
                let wholeNo = resultSet2.doubleForColumn("whole_number")
                
                let fraction = resultSet2.doubleForColumn("fraction")
                let measure = resultSet2.stringForColumn("measure_description")
                
                let foodLogged : FoodForTable = FoodForTable(foodId: foodIdInt, foodDesc: foodDesc, wholeNumber: wholeNo, fraction: fraction, measureDesc: measure, time: time)
                
                foodsForTable.append(foodLogged)
                
            }
        }
        
        sharedInstance.database!.close()
        
        var count2 : Int = Int(count)
        
        return (foodsForTable, count2)
        
    }
    
    //-------Delete an Item From Food Log--------//
    
    func deleteItemFromFoodLog(date: String, time : String) -> Bool
    {
        sharedInstance.database!.open()
        
        //eventually needs to take into account date_logged as well
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM food_log WHERE time_logged=? AND date_logged=?", withArgumentsInArray: [time, date])
        
        sharedInstance.database!.close()
        
        return isDeleted
    }
    
    
    //---------Get an array of all of the Nutrients---------//
    
    func getAllNutrients() -> [Nutrient]
    {
        var nutrients = [Nutrient]()
        
        sharedInstance.database!.open()
        
        let query = "SELECT * FROM nutrient"
        
        var result : FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray : nil)
        
        if result != nil
        {
            while result.next()
            {
                let nutrientId = result.stringForColumn("id")
                let nutrientIdInt = nutrientId.toInt()!
                
                let units = result.stringForColumn("units")
                let name = result.stringForColumn("name")
                
                let tagName = ""
                let amountPerHundred = 0.0
                
                let theNutrient : Nutrient = Nutrient(nutrientId: nutrientIdInt, amountPerHundredGrams: amountPerHundred, units: units, name: name, tagName: tagName)
                
                nutrients.append(theNutrient)
                
            }
        }
        sharedInstance.database!.close()
        return nutrients
    }
    
    //---------Get 1 Nutrient Info--------//
    
    func getANutrientInfo(nId : Int) -> Nutrient
    {
        sharedInstance.database!.open()
        
        let query = "SELECT * FROM nutrient WHERE id=?"
        
        var result : FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray : [nId])
        var nutrientIdInt : Int = 99999999
        var units : String = "empty"
        var name : String = "empty"
        var amountPerHundred = 0.0
        var tagName : String = "empty"
        
        if result != nil
        {
            while result.next()
            {
                var nutrientId = result.stringForColumn("id")
                nutrientIdInt = nutrientId.toInt()!
                
                units = result.stringForColumn("units")
                name = result.stringForColumn("name")
                
                tagName = ""
                amountPerHundred = 0.0
            
            }
        }
        sharedInstance.database!.close()
        
        let theNutrient = Nutrient(nutrientId: nutrientIdInt, amountPerHundredGrams: amountPerHundred, units: units, name: name, tagName: tagName)
        return theNutrient
    }
    
}
