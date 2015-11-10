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
    let daysInMonths = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    
    var database : FMDatabase? = nil
    
    class var instance : ModelManager
    {
        sharedInstance.database = FMDatabase(path: Util.getPath("usda.sql3"))
        let path = Util.getPath("usda.sql3")
        
        print("!!!!!!!path: \(path)")
        return sharedInstance
    }
    
    
    func getAllFoodData()
    {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM food", withArgumentsInArray: nil)
        
        //var nutrientIdColumn: String = "short_desc"
        
        if (resultSet != nil) {
            while resultSet.next() {
                
                let id = resultSet.stringForColumn("id")
                let idInt = Int(id)!
                let desc = resultSet.stringForColumn("long_desc")
                let descR = String(desc)
                
                let foodItem : Food = Food(desc: descR, id: idInt)
                allFoods.append(foodItem)
                
            }
        }
        sharedInstance.database!.close()
    }
    
    //---------Check for added food items?!?!-----------//
    // call this when a custum item has been added to the database
    // adds the new food to the allFoods array
    
    func aFoodWasAdded(foodId : Int)
    {
        sharedInstance.database!.open()
        
        let query : String = "SELECT * FROM food WHERE id=\(foodId)"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: nil)
        
        //var nutrientIdColumn: String = "short_desc"
        
        if (resultSet != nil) {
            while resultSet.next() {
                
                let id = resultSet.stringForColumn("id")
                let idInt = Int(id)!
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
        let query : String = "SELECT * FROM weight WHERE food_id=\(foodId)"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: nil)
        
        var measures = [Weight]()
        
        if (resultSet != nil) {
            while resultSet.next() {
                
                let foodId = resultSet.stringForColumn("food_id")
                print(foodId)
                let idInt = Int(foodId)!
                let seq = resultSet.stringForColumn("seq")
                let seqInt = Int(seq)!
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
            print("Weight info for food id \(foodId) not found.")
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
        
        
        var nt = Dictionary<Int, (nutrient:Nutrient, total:Double)>()
        
        //will be an array of pairs of (foodId, amountConsumed)
        var arrayOfLogged = [(Int, Double)]()
        
        sharedInstance.database!.open()
        
        let query2 = "SELECT * FROM food_log WHERE date_logged=?"
        let resultSet2: FMResultSet! = sharedInstance.database!.executeQuery(query2, withArgumentsInArray: [date])
        
        if resultSet2 != nil
        {
            while resultSet2.next()
            {   let foodId = resultSet2.stringForColumn("food_id")
                print(foodId)
                let foodIdInt = Int(foodId)
                
                let amountConsumed = resultSet2.doubleForColumn("amount_consumed_grams")
                print(amountConsumed)
                
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
                    
                    let prevNutrient = nt[nutrientId]
                    
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
                let nutrientId = nutrient.nutrientId
                
                nt[nutrientId] = (nutrient, 0.0)
            }
        }
        
        
        return nt
    }
    
    
    //-----------Get an Array of tuples(Nutrient, TotalInAmountChosen) for one food-----------//
    //           returns an array of ALL nutrients
    
    func getNutrientContentForAmountOneFood(foodId : Int, amountInGrams: Double) -> Dictionary<Int, (nutrient:Nutrient, total:Double)> {
    
        let itsNutrients = getNutrients(foodId)
        
        var nutAmounts = Dictionary<Int, (nutrient:Nutrient, total:Double)>()

        //var nutAmounts = [(Nutrient, Double)]()
        
        for nutrient in itsNutrients
        {
            let nutrientId = nutrient.nutrientId
            let nutrientContentConsumed = (nutrient.amountPerHundredGrams/100.0) * amountInGrams
            
            nutAmounts[nutrientId] = (nutrient, nutrientContentConsumed)
        
        }
        
        
        return nutAmounts
        
    }
    
    
    //-----------Get an Array of Nutrients, Nutrient Amounts, and Nutrient Units for a particular food-----------//
    //                     -> and return the array of Nutrients
    //                     finds ALL nutrient info for the particular food                                       //
    //           would need to use JOIN on common nutrient to narrow down...                                     //
    
    func getNutrients(foodId : Int) -> [Nutrient]
    {
        sharedInstance.database!.open()
        let queryNutrition : String = "SELECT * FROM nutrition WHERE food_id=\(foodId)"
        var queryNutrient : String = ""
        let resultSetA: FMResultSet! = sharedInstance.database!.executeQuery(queryNutrition, withArgumentsInArray: nil)
        
        var nutrients = [Nutrient]()
        
        if (resultSetA != nil)
        {
            while resultSetA.next() //each associated nutrient
            {
                let foodId = resultSetA.stringForColumn("food_id")
                let idInt = Int(foodId)!
                let nutrientId = resultSetA.stringForColumn("nutrient_id")
                let nutrientIdInt = Int(nutrientId)!
                let amountPerHundredGrams = resultSetA.doubleForColumn("amount")
                var name : String = ""
                var units : String = ""
                var tagName : String = ""
                
                
                let queryNutrient : String = "SELECT * FROM nutrient WHERE id=\(nutrientId)"
                let resultSetB: FMResultSet! = sharedInstance.database!.executeQuery(queryNutrient, withArgumentsInArray: nil)
                
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
                    print("Nutrient Info for nutrient \(nutrientId) not found.")
                }
                
                //let theNutrient : Nutrient = Nutrient(foodId: idInt, nutrientId: nutrientIdInt, amountPerHundredGrams: amountPerHundredGrams, units: units, name: name, tagName: tagName)
                let theNutrient : Nutrient = Nutrient(nutrientId: nutrientIdInt, amountPerHundredGrams: amountPerHundredGrams, units: units, name: name, tagName: tagName)
                
                nutrients.append(theNutrient)
            }
            sharedInstance.database!.close()
            print("*k*k*k*")
            print(foodId)
            print(nutrients[0].amountPerHundredGrams)
            return nutrients
        }
        else
        {
            print("Nutrition info for food id \(foodId) not found.")
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
        
        print(item.amountConsumedGrams)
        print(item.wholeNumber)
        print(item.fraction)
        print(item.measure)
        print(item.date)
        print(item.time)
        print(item.foodId)

        
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
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: [date])
        
        var count : Int32 = 0
        if resultSet != nil
        {
            while resultSet.next()
            {
                count = resultSet.intForColumn("cnt")
                print("There are \(count) items logged on date \(date).")
            }
        }
        
        let query2 = "SELECT * FROM food_log WHERE date_logged=?"
        let resultSet2: FMResultSet! = sharedInstance.database!.executeQuery(query2, withArgumentsInArray: [date])
        
        if resultSet2 != nil
        {
            while resultSet2.next()
            {
                let foodId = resultSet2.stringForColumn("food_id")
                let foodIdInt : Int = Int(foodId)!
                
                let descResult : FMResultSet! = sharedInstance.database!.executeQuery("SELECT long_desc FROM food WHERE id=?", withArgumentsInArray: [foodId])
                
                var foodDesc = ""
                if descResult != nil
                {
                    while descResult.next()
                    {
                        foodDesc = descResult.stringForColumn("long_desc")
                    }
                }
                
                
                let time = resultSet2.stringForColumn("time_logged")
                print("Time of this item added: \(time)")
                let wholeNo = resultSet2.doubleForColumn("whole_number")
                
                let fraction = resultSet2.doubleForColumn("fraction")
                let measure = resultSet2.stringForColumn("measure_description")
                
                let foodLogged : FoodForTable = FoodForTable(foodId: foodIdInt, foodDesc: foodDesc, wholeNumber: wholeNo, fraction: fraction, measureDesc: measure, time: time)
                
                foodsForTable.append(foodLogged)
                
            }
        }
        
        sharedInstance.database!.close()
        
        let count2 : Int = Int(count)
        
        return (foodsForTable, count2)
        
    }
    
    //-------Delete an Item From Food Log--------//
    
    func deleteItemFromFoodLog(date: String, time : String) -> Bool
    {
        sharedInstance.database!.open()
        
        
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
        
        let result : FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray : nil)
        
        if result != nil
        {
            while result.next()
            {
                let nutrientId = result.stringForColumn("id")
                let nutrientIdInt = Int(nutrientId)!
                
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
    
    //---------Get Nutrient RDAs--------//
    
    func getAllNutrientRDAs() -> Dictionary<Int, (Double)> {
        
        var rdas = Dictionary<Int, (Double)>()
        
        sharedInstance.database!.open()
        
        let query = "SELECT * FROM nutrient_rdas"
        
        let result : FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: nil)
        
        if result != nil {
            
            while result.next()
            {
                let nutrientId = result.stringForColumn("id")
                let nutrientIdInt = Int(nutrientId)!
                
                let rda = result.doubleForColumn("daily_value")
                
                                
                rdas[nutrientIdInt] = rda
            }
        }
        
        
        sharedInstance.database!.close()
        return rdas
    
    }
    
    //---------Update Nutrient RDAs--------//
    
    func updateRDAs(new : [Int:Double]) -> [Bool] {
    
        sharedInstance.database!.open()
        
        var isUpdated = [Bool]()
        
        
        for update in new {
        
            let updated = sharedInstance.database!.executeUpdate("UPDATE nutrient_rdas SET daily_value=? WHERE id=?", withArgumentsInArray: [update.1, update.0])
            isUpdated.append(updated)
        }
        
        return isUpdated
    }
    
    
    
    //---------Get 1 Nutrient Info--------//
    
    func getANutrientInfo(nId : Int) -> Nutrient
    {
        sharedInstance.database!.open()
        
        let query = "SELECT * FROM nutrient WHERE id=?"
        
        let result : FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray : [nId])
        var nutrientIdInt : Int = 99999999
        var units : String = "empty"
        var name : String = "empty"
        var amountPerHundred = 0.0
        var tagName : String = "empty"
        
        if result != nil
        {
            while result.next()
            {
                let nutrientId = result.stringForColumn("id")
                nutrientIdInt = Int(nutrientId)!
                
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
    
    
    //-------Create Data for a period of time for A Nutrient--------//
    
    func getChartDataForNutrient(nId: Int, startDate: String, nOfDays : Int) -> (labels: [String], values: [Double]) {
    
        var oneDay = Dictionary<Int, (nutrient:Nutrient, total:Double)>()
        var allDays = [Dictionary<Int, (nutrient:Nutrient, total:Double)>]()
        
        var chartData = (labels: [String](), values: [Double]())
        
        
        //days from current to most past (this is backwards of what we want)
        var labels = [String]()
        var values = [Double]()
        
        
        
        var currentDate = startDate
        
        for i in 1...nOfDays {
            
            oneDay = getNutrientTotals(currentDate)
            
            allDays.append(oneDay)
            
            labels.append(currentDate)
            
            //currentDate is now the one before
            currentDate = getPreviousDate(currentDate)
        }
        print("HOW MAnY DayS")
        print(allDays.count)
        
        for i in allDays {
            
            var totalOfTheDay : Double
            
            //get the tuple for the nutrient id
            let tuple = i[nId]
            
            if tuple != nil {
                totalOfTheDay = tuple!.total
                values.append(totalOfTheDay)
            }
            else {
                print("No Value Exists for this nutrient on this day")
                values.append(0.0)
            }

        }
        
        chartData = (labels, values)
        
        return chartData
    }
    
    
    
    //OMEGAS
    func getOmegasChartData(startDate: String, nOfDays : Int) -> (labels: [String], values: [Double]) {
    
        let nutrientsOmega6s = [672, 675, 685, 853, 855]
        let nutrientsOmega3s = [851, 852, 631, 629, 621]
        
        var oneDay = Dictionary<Int, (nutrient:Nutrient, total:Double)>()
        //all nutrient data for all of the days desired
        var allDays = [Dictionary<Int, (nutrient:Nutrient, total:Double)>]()
        
        var chartData = (labels: [String](), values: [Double]())
        
        var labels = [String]()
        var values = [Double]()
        
        
        var currentDate = startDate
        
        for i in 1...nOfDays {
            
            oneDay = getNutrientTotals(currentDate)
            
            allDays.append(oneDay)
            
            labels.append(currentDate)
            
            //currentDate is now the one before
            currentDate = getPreviousDate(currentDate)
        }

        
        for i in allDays {
            
            var ratio : Double
            
            //variables to hold totals, get the daily totals for each omega
            let omega3 : Double = getOmega3(nutrientsOmega3s, nutrientTotals: i)
            let omega6 : Double = getOmega6(nutrientsOmega6s, nutrientTotals: i)
            
            
            if omega3 != 0.0 {
                ratio  = omega6/omega3
            } else  {//we would divide by zero
                ratio = omega6/0.01
            }
            values.append(ratio)
            
            
//            var totalOfTheDay : Double
//            
//            //get the tuple for the nutrient id
//            var tuple = i[nId]
//            
//            if tuple != nil {
//                totalOfTheDay = tuple!.total
//                values.append(totalOfTheDay)
//            }
//            else {
//                println("No Value Exists for this nutrient on this day")
//                values.append(0.0)
//            }
            
        }
        
        chartData = (labels, values)
        
        return chartData
        
    }
    
    
    
    //----------returns previous day date string----------//
    
    func getPreviousDate(currentDate: String) -> String {
        
        
        let calendar = NSCalendar.currentCalendar()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(currentDate)
        
        
        let components = NSDateComponents()
        components.day = -1
        
        print("-1 from \(currentDate): \(calendar.dateByAddingComponents(components, toDate: date!, options: []))")
        print("-1 from \(currentDate): \(dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!))")
        
        let theNewDate = dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!)
        
        return theNewDate
        
    }
    
    
    
//    func getNutrientsForOneItem(id : String) -> Dictionary<Int, (Double)> {
//        
//        sharedInstance.database!.open()
//        
//        var dict = Dictionary<Int, (Double)>()
//        
//        let query = "SELECT * FROM nutrition WHERE food_id=?"
//        var result : FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray : [id])
//        
//        
//        if result != nil {
//
//            for nutrient in nutrientsToShow {
//                
//                var nutrientId = result.stringForColumn("nutrient_id")
//                var nutrientIdInt = nutrientId.toInt()!
//                
//                amountPerGram = result.doubleForColumn("amount")
//            }
//        }
//   
//    
//    }
    func getOmega3(nutrientsOmega3s : [Int], nutrientTotals : Dictionary<Int, (nutrient:Nutrient, total:Double)>) -> Double {
        
        //variables to hold totals
        var omega3 : Double = 0.0
        
        
        //-------Omega-3 Calculation------//
        //    calculate total omega-3
        
        for nutrient in nutrientsOmega3s {
            
            //get nutrient object for the id
            var nutrientCellInfo = nutrientTotals[nutrient]
            
            //if nutrient 851 doesnt exist use 619 instead.
            if nutrient == 851 {
                if nutrientCellInfo != nil {
                    omega3 += nutrientCellInfo!.total
                } else {
                    nutrientCellInfo = nutrientTotals[619]
                    if nutrientCellInfo != nil {
                        omega3 += nutrientCellInfo!.total
                    }
                }
            }
                
                //do this for all the other nutrients
            else {
                if nutrientCellInfo != nil {
                    //if it exists, add it to total!
                    omega3 += nutrientCellInfo!.total
                }
            }
        }
        
        return omega3
    }
    
    func getOmega6(nutrientsOmega6s : [Int], nutrientTotals : Dictionary<Int, (nutrient:Nutrient, total:Double)>) -> Double {
        
        
        var omega6 : Double = 0.0
        
        //-------Omega-6 Calculation------//
        // calculate total omega-6
        for nutrient in nutrientsOmega6s {
            
            //get nutrient object for the id
            var nutrientCellInfo = nutrientTotals[nutrient]
            
            //if nutrient 675 doesnt exist use 619 instead.
            if nutrient == 675 {
                if nutrientCellInfo != nil {
                    omega6 += nutrientCellInfo!.total
                } else { //675 doesnt exist in db
                    nutrientCellInfo = nutrientTotals[618]
                    if nutrientCellInfo != nil {
                        omega6 += nutrientCellInfo!.total
                    }
                }
            }
                
                //if nutrient 855 doesnt exist use 619 instead.
            else if nutrient == 855 {
                if nutrientCellInfo != nil {
                    omega6 += nutrientCellInfo!.total
                } else { //855 doesnt exist in db
                    nutrientCellInfo = nutrientTotals[620]
                    if nutrientCellInfo != nil {
                        omega6 += nutrientCellInfo!.total
                    }
                }
            }
                
                //do this for all the other nutrients
            else {
                if nutrientCellInfo != nil {
                    //if it exists, add it to total!
                    omega6 += nutrientCellInfo!.total
                }
            }
        }
        return omega6
    }
    
    
    
    
    
    
    
    
    //--------CREATING FOOD ENTRY FUNCTIONS---------//
    
    
    func createFoodEntry(groupAndName : (Int, String), serving : String, nutrients : [Int : Double]) -> Int {
        
        sharedInstance.database!.open()
        
        let query = "SELECT COUNT(*) as cnt FROM food WHERE id>99000"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsInArray: nil)
        
        var count : Int32 = 0
        if resultSet != nil
        {
            while resultSet.next()
            {
                count = resultSet.intForColumn("cnt")
                print("There are \(count) custom food items.")
            }
        }
        
        let uniqueId : Int = 99001 + Int(count)
        print(uniqueId)
        
        
        //insert the food into the food table
        
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO food (id, food_group_id, long_desc, short_desc, refuse, nitrogen_factor, protein_factor, fat_factor, calorie_factor) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsInArray: [uniqueId, groupAndName.0, groupAndName.1, groupAndName.1, 0, 0.0, 0.0, 0.0, 0.0])
        
        if isInserted == true {
            
            print("The item was added: \(isInserted)")
        
            //instant delete for testing
//            let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM food WHERE id=\(99001)", withArgumentsInArray: nil)
//            
//            println("The item was then deleted: \(isDeleted)")
            
            //WE KNOW THE ITEM WAS ADDED SUCCESSFULLY! 
            //NOW WE WANT TO MAKE A CORRESPONDING weight TABLE ENTRY!
            
            let isWeightInserted = sharedInstance.database!.executeUpdate("INSERT INTO weight (food_id, seq, amount_unitmod, measure_description, gram_weight) VALUES (?,?,?,?,?)", withArgumentsInArray: [uniqueId, 1, 1.0, serving, 100.0])
            
            if isWeightInserted == true {
                print("The weight was added: \(isWeightInserted)")
                
                
                //WE KNOW THE ITEM WAS ADDED TO THE WEIGHT TABLE SUCCESSFULLY!
                //NOW WE WANT TO ADD THE NUTRIENTS TO THE NUTRITION TABLE
                
                //var areNutrientsAddedSuccessfully = [Bool]()
                
                for nutrient in nutrients {
                    
                    let isNutrientAdded = sharedInstance.database!.executeUpdate("INSERT INTO nutrition (food_id, nutrient_id, amount, num_data_points, source_code) VALUES (?,?,?,?,?)", withArgumentsInArray: [uniqueId, nutrient.0, nutrient.1, 0, "na"])
                    
                    //areNutrientsAddedSuccessfully.append(isNutrientAdded)
                    print("Nutrient added: \(isNutrientAdded)")
                }
                
                
                
                
        
                
                
                
                
//                let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM weight WHERE food_id=\(99001)", withArgumentsInArray: nil)
//    
//                println("The weight was then deleted: \(isDeleted)")
//                
//                
//                let isDeleted2 = sharedInstance.database!.executeUpdate("DELETE FROM food WHERE id=\(99001)", withArgumentsInArray: nil)
//                
//                println("The item was then deleted: \(isDeleted2)")
//        
//                let isDeleted3 = sharedInstance.database!.executeUpdate("DELETE FROM nutrition WHERE food_id=\(99001)", withArgumentsInArray: nil)
//        
//                println("The nutrients have been deleted: \(isDeleted3)")
            
            }
        
        } else {
            print("Failed to put item into food table")
        }

        
        
        
        
        sharedInstance.database!.close()
        
        //return the food id for the new item
        return uniqueId
    }
    
    
    //----------Add Photo Reminder to database methods----------//
    
    func addPhotoToDb() -> Int {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //use globally chosen date
        let dateInFormat = dateChosen
        
        ////get todays time in 17:07:40 format
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "HH:mm:ss"
        let timeInFormat = dateFormatter2.stringFromDate(date)
        
        sharedInstance.database!.open()
    
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO photos (date_logged, time_logged) VALUES (?,?)", withArgumentsInArray: [dateInFormat, timeInFormat])
        
        print("was the photo inserted? \(isInserted)")
        
        
        let theId: Int = Int(sharedInstance.database!.lastInsertRowId())
        
        sharedInstance.database!.close()
        print("The ID was apparently \(theId)")
        
        
        return theId
        
    }
    
    //--------------Get Photos for a date------------//
    
    func getPhotosForDate(theDate: String) -> [(String, String)]? {
    
        var arrayOfPhotos = [(String,String)]()
        
        sharedInstance.database!.open()
        
        let query2 = "SELECT * FROM photos WHERE date_logged=?"
        let resultSet2: FMResultSet! = sharedInstance.database!.executeQuery(query2, withArgumentsInArray: [theDate])
        
        
        
        if resultSet2 != nil
        {
            print("Something in the result set for photos")
            while resultSet2.next()
            {   let picId = resultSet2.stringForColumn("id")
               
                let timeLogged = resultSet2.stringForColumn("time_logged")
                
                let idAndTime = (picId!,timeLogged!)
                print(idAndTime)
                
                arrayOfPhotos.append(idAndTime)
            }
            return arrayOfPhotos
        }
        return nil
    }
    
    // delete a photo on a date and time
    
    func deletePhotoReminder(date: String, time: String) -> Bool {
    
        sharedInstance.database!.open()
        
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM photos WHERE time_logged=? AND date_logged=?", withArgumentsInArray: [time, date])
        
        sharedInstance.database!.close()
        
        return isDeleted
        
    }

}
