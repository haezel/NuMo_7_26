//
//  PickAmountViewController.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 5/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

class PickAmountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var measurePicker: UIPickerView!

    @IBOutlet weak var addOrAdjustButton: UIBarButtonItem!
    
    @IBOutlet weak var titleItemChosen: UILabel!
    
    //@IBOutlet weak var cancelUpdate: UIButton!
    
    var wholeNumbers = ["—", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    
    var fractionNumbers = ["—", "1/8", "1/4", "1/3", "1/2", "2/3", "3/4"]
    
    //item to hold currently chosen food and amount
    var logItem : FoodLog?
    var foodItem : Food?
    var measures : [Weight]?
    var nutrients : [Nutrient]?
    var timePreviouslyLogged : String?
    
    //var to hold selected date
    var date : String = ""
    
    var toggleAdjustOrAdd = "add"
    
    //---------LifeCycle Methods---------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("View with tag -1")
        println(self.view.viewWithTag(-1))
        
//        let navigationBar = (self.view.viewWithTag(-1) as! UINavigationBar)
//        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItemToLog")
//        navigationBar.topItem!.rightBarButtonItem = button
        
        
        self.measurePicker.dataSource = self;
        self.measurePicker.delegate = self;
        
        // Do any additional setup after loading the view.
        
        self.title = ""
        
        self.titleItemChosen.text = foodItem?.desc
        
        var id : Int = foodItem!.id
        getUnits(id)
        getNutrients(id)
        
//        to print out the nutrients found for the food.
//        for var i = 0; i < nutrients!.count; ++i {
//            let s : String = self.nutrients![i].name
//            let a = self.nutrients![i].amountPerHundredGrams
//            let u = self.nutrients![i].units
//            println("nutrient # \(i) is \(s) and there is \(a) \(u) of it in 100 grams")
//        }
        if toggleAdjustOrAdd == "add"
        {
            self.title = ""
//            var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItemToLog") //Use a selector
//            navigationItem.rightBarButtonItem = addButton
        }
        println(toggleAdjustOrAdd)
        if toggleAdjustOrAdd == "adjust"
        {
            self.title = "Adjust Amount"
            
//            var editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: nil, action: "addItemToLog") //Use a selector
//            navigationItem.rightBarButtonItem = editButton
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----------Add Item or Update Item-----------// !!!NEED TO IMPLEMENT UPDATE ITEM!!
    
    
    @IBAction func addItemToLog(sender: AnyObject) {

        if toggleAdjustOrAdd == "add"
        {
            // add currently chosen item and amounts to sql
            if self.logItem != nil
            {
                ModelManager.instance.addFoodItemToLog(self.logItem!)
                navigationController?.popViewControllerAnimated(true)
            }
            else //you havent specified an amount yet with the pickers
            {
                //pop up box that tells you to choose an amount
            }
        }
        else //we are trying to adjust an amount...
        {
            println("needs to update the amount in db")
            ModelManager.instance.updateFoodItemLogAmount(self.logItem!)
            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
            navigationController?.popViewControllerAnimated(true)

        }
    }

    //---------Segue Unwind---------//
    
//    @IBAction func cancelUpdatePressed(sender: AnyObject) {
//        
//        
//    }
    
    //---------UI Picker Data Source Methods----------//
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return (self.view.frame.size.width * 20 ) / 100
        }
        else if component == 1 {
            return (self.view.frame.size.width * 20 ) / 100
        }
        else {
            return (self.view.frame.size.width * 60 ) / 100
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return wholeNumbers.count
        }
        else if component == 1 {
            return fractionNumbers.count
        }
        else {
            return measures!.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return wholeNumbers[row]
        }
        else if component == 1 {
            return fractionNumbers[row]
        }
        else {
            return measures![row].measure
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            updateAmounts()
            println(self.logItem?.amountConsumedGrams)
  
       

    }
    
    //size the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 46.0
    }
    
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        
//        var titleData : String = ""
//        
//        if component == 0 {
//            titleData = wholeNumbers[row]
//        }
//        else if component == 1 {
//            titleData = fractionNumbers[row]
//        }
//        else {
//            titleData = measures![row].measure
//        }
//        
//        
//        
//        //let titleData = wholeNumbers[row]
//        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "AvenirNextCondensed-Bold", size: 13.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
//        return myTitle
//    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            
                pickerLabel = UILabel()
                
                //color  and center the label's background
                let hue = CGFloat(row)/CGFloat(measures!.count)
                //pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
            if component > 1 {
                pickerLabel.textAlignment = .Left
            }
            else {
               pickerLabel.textAlignment = .Center
            }
            
        }
        //let titleData = wholeNumbers[row]
        
        var titleData : String = ""
        
        if component == 0 {
            titleData = wholeNumbers[row]
        }
        else if component == 1 {
            titleData = fractionNumbers[row]
        }
        else {
            titleData = measures![row].measure
        }
        
        if component > 1 {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "AvenirNextCondensed-Regular", size: 19.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
            pickerLabel!.attributedText = myTitle
        }
        
        else {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "AvenirNextCondensed-Regular", size: 24.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel!.attributedText = myTitle
        }
        
        return pickerLabel
        
    }
    
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let titleData = measures![row].measure
//        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
//        return myTitle
//    }
    
    //--------Update Amount of Item Consumed in Grams--------//
    
    func updateAmounts()
    {   let wholeNumber = wholeNumbers[measurePicker.selectedRowInComponent(0)]
        var wholeNumberInt : Int = 0
        
        if wholeNumber != "—"
        {
            wholeNumberInt = (wholeNumber).toInt()!
        }
        
        else
        {
            wholeNumberInt = 0;
        }
        
        let fraction = fracToDouble(fractionNumbers[measurePicker.selectedRowInComponent(1)])
        
        let chosenConsumedAmount = Double(wholeNumberInt) + fraction
        
        let weightInGrams = measures![measurePicker.selectedRowInComponent(2)].weightInGrams
        
        //description of the measure in words
        let measureDesc = measures![measurePicker.selectedRowInComponent(2)].measure
        
        let amountPerMeasure = measures![measurePicker.selectedRowInComponent(2)].amountPer
        
        let weightConsumed = (weightInGrams/amountPerMeasure) * chosenConsumedAmount
        
        println("Chosen amount: \(chosenConsumedAmount) and weight is \(weightConsumed).")
        
        makeFoodLogItem(weightConsumed, whole: Double(wholeNumberInt), frac: fraction, measure: measureDesc)
        
    }
    
    //---------Create a FoodLog Object----------//
    //         
    //         and set as self.logItem
    
    func makeFoodLogItem(grams : Double, whole : Double, frac : Double, measure : String)
    {
        let id = self.foodItem!.id
        
        
        var timeInFormat = ""
        var dateInFormat = ""
        
        if toggleAdjustOrAdd == "add"
        {
            var date = NSDate()
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
    //        //get todays date in 2015-06-02 format
    //        var dateInFormat = dateFormatter.stringFromDate(date)
            //use globally chosen date 
            dateInFormat = dateChosen
            
            ////get todays time in 17:07:40 format
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "HH:mm:ss"
            timeInFormat = dateFormatter2.stringFromDate(date)
        }
        else //we are in adjust amount mode
        {
            timeInFormat = timePreviouslyLogged!
            dateInFormat = dateChosen
        }

        self.logItem = FoodLog(foodId : id, amountConsumedGrams : grams, date : dateInFormat, time : timeInFormat, wholeNumber : whole, fraction : frac, measure : measure)
        
    }
    
    func fracToDouble(fraction : String) -> Double
    {
        switch fraction
        {
            case "—":
                return 0.0
            case "1/8":
                return 0.125
            case "1/4":
                return 0.25
            case "1/3":
                return 0.333
            case "1/2":
                return 0.5
            case "2/3":
                return 0.666
            case "3/4":
                return 0.75
            default:
                return 0.0
        }
    }
    
    
    //--------Get SQLite Info--------//
    
    func getUnits(id : Int)
    {
        //measures is an array of Weights associated with one food item
        self.measures = ModelManager.instance.getMeasures(id)
    }
    
    func getNutrients(id : Int)
    {
        self.nutrients = ModelManager.instance.getNutrients(id)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
