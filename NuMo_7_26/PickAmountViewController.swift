//
//  PickAmountViewController.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 5/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import Charts

class PickAmountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var measurePicker: UIPickerView!

    @IBOutlet weak var addOrAdjustButton: UIBarButtonItem!
    
    @IBOutlet weak var titleItemChosen: UILabel!
    
    @IBOutlet weak var omegaChart: PieChartView!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    //@IBOutlet weak var cancelUpdate: UIButton!
    
    var wholeNumbers = ["—", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"]
    
    var fractionNumbers = ["—", "1/8", "1/4", "1/3", "1/2", "2/3", "3/4"]
    
    let nutrientsOmega6s = [672, 675, 685, 853, 855]
    let nutrientsOmega3s = [851, 852, 631, 629, 621]
    
    //holds nutrient totals. key is nutrient Id (Nutrient, totalRightNow)
    var nutrientContents : Dictionary<Int, (nutrient:Nutrient, total:Double)>?
    
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
        
        
        let id = self.foodItem!.id
        
        //---------testing new db function getNutrientContentForAmountOneFood
        self.nutrientContents = ModelManager.instance.getNutrientContentForAmountOneFood(id, amountInGrams: 100)
        
        //variables to hold totals
        let omega3 : Double = getOmega3()
        let omega6 : Double = getOmega6()
        
        
        let theOmegasAmounts = [omega6, omega3]
        
        
        
        let color2 = UIColor.colorFromCode(0xdf00ff)
        let color1 = UIColor.colorFromCode(0x8000ff)
        //let color2 = UIColor.colorFromCode(0x0994ff)
        
        let colors = [color1, color2]
        
        
        //cell.backgroundColor = UIColor.colorFromCode(0xc9c9c9)
        
        //cell.setData("Omega Ratio", amounts: [2.0,2.0], labels: ["Oh", "kay"])
        setData("Omega Ratio", amounts: theOmegasAmounts, labels: ["Omega 6","Omega 3 "], colorsUse: colors)
        
        
        
        
        //titleItemChosen.font = UIFont(name: titleItemChosen.font.fontName, size: 15)
        //titleItemChosen.numberOfLines = 0
        
        print("View with tag -1")
        print(self.view.viewWithTag(-1))
        
//        let navigationBar = (self.view.viewWithTag(-1) as! UINavigationBar)
//        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItemToLog")
//        navigationBar.topItem!.rightBarButtonItem = button
        
        
        self.measurePicker.dataSource = self;
        self.measurePicker.delegate = self;
        
        // Do any additional setup after loading the view.
        
        self.title = ""
        
        self.titleItemChosen.text = foodItem?.desc
        
        //let id : Int = foodItem!.id
        
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
        print(toggleAdjustOrAdd)
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
    
    //-----------Add Item or Update Item-----------//
    
    
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
            print("needs to update the amount in db")
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
            print(self.logItem?.amountConsumedGrams)
  
       

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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
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
            wholeNumberInt = Int((wholeNumber))!
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
        
        print("Chosen amount: \(chosenConsumedAmount) and weight is \(weightConsumed).")
        
        makeFoodLogItem(weightConsumed, whole: Double(wholeNumberInt), frac: fraction, measure: measureDesc)
        
    }
    
    //---------Create a FoodLog Object----------//
    //         
    //         and set as self.logItem
    
    func makeFoodLogItem(grams : Double, whole : Double, frac : Double, measure : String)
    {
    
        let id = self.foodItem!.id
        
        //---------testing new db function getNutrientContentForAmountOneFood
        self.nutrientContents = ModelManager.instance.getNutrientContentForAmountOneFood(id, amountInGrams: grams)
        
        
        caloriesLabel.text = String(format: "%.0f", self.nutrientContents![208]!.1)
        
        
        
        
        
        //---end test
        
        
        var timeInFormat = ""
        var dateInFormat = ""
        
        if toggleAdjustOrAdd == "add"
        {
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
    //        //get todays date in 2015-06-02 format
    //        var dateInFormat = dateFormatter.stringFromDate(date)
            //use globally chosen date 
            dateInFormat = dateChosen
            
            ////get todays time in 17:07:40 format
            let dateFormatter2 = NSDateFormatter()
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
    
    func getOmega3() -> Double {
        
        //variables to hold totals
        var omega3 : Double = 0.0
        
        
        //-------Omega-3 Calculation------//
        //    calculate total omega-3
        
        for nutrient in nutrientsOmega3s {
            
            //get nutrient object for the id
            var nutrientCellInfo = self.nutrientContents![nutrient]
            
            //if nutrient 851 doesnt exist use 619 instead.
            if nutrient == 851 {
                if nutrientCellInfo != nil {
                    omega3 += nutrientCellInfo!.total
                } else {
                    nutrientCellInfo = self.nutrientContents![619]
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
    
    func getOmega6() -> Double {
        
        
        var omega6 : Double = 0.0
        
        //-------Omega-6 Calculation------//
        // calculate total omega-6
        for nutrient in nutrientsOmega6s {
            
            //get nutrient object for the id
            var nutrientCellInfo = self.nutrientContents![nutrient]
            
            //if nutrient 675 doesnt exist use 619 instead.
            if nutrient == 675 {
                if nutrientCellInfo != nil {
                    omega6 += nutrientCellInfo!.total
                } else { //675 doesnt exist in db
                    nutrientCellInfo = self.nutrientContents![618]
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
                    nutrientCellInfo = self.nutrientContents![620]
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
    
    func setData(title : String, amounts : [Double], labels : [String], colorsUse : [UIColor]) {
        
        omegaChart.centerText = title
        
        
        let theLabels = labels
        let theValues = amounts
        
        //setChart(labels, values: amounts)
        setChart(theLabels, values: theValues, colorsUse: colorsUse)
    }
    
    func setChart(dataPoints: [String], values: [Double], colorsUse : [UIColor]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        omegaChart.data = pieChartData
        
        //        MAKES RANDOM COLORS
        //        var colors: [UIColor] = []
        //
        //        //use random color scheme
        //        for i in 0..<dataPoints.count {
        //            let red = Double(arc4random_uniform(256))
        //            let green = Double(arc4random_uniform(256))
        //            let blue = Double(arc4random_uniform(256))
        //
        //            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        //            colors.append(color)
        //        }
        
        
        
        //pieChartView.backgroundColor = UIColor.colorFromCode(0x000000)
        //pieChartView.
        
        //pieChartView.legend.setCustom(colors: [UIColor.colorFromCode(0xFFFFFF)], labels: ["FF"])
        omegaChart.legend.textColor = UIColor.colorFromCode(0x555555)
        
        omegaChart.data?.setValueTextColor(UIColor.clearColor())
        
        omegaChart.legend.enabled = false
    
        omegaChart.legend.position = .BelowChartCenter
        omegaChart.drawSliceTextEnabled = false
        omegaChart.userInteractionEnabled = false
        omegaChart.infoFont = UIFont(name: "AvenirNextCondensed-Regular", size: 16.0)!
        omegaChart.holeRadiusPercent = 0.75
        omegaChart.drawHoleEnabled = true
        omegaChart.holeColor = UIColor.colorFromCode(0xFFFFFF)
        //        pieChartView.centerText = "Macronutrients"
        
        //pieChartView.centerTextFont = UIFont(name: "AvenirNextCondensed-Medium", size: 16.0)!
        //pieChartView.centerTextColor = UIColor.colorFromCode(0xffffff)
        
        omegaChart.descriptionText = ""
        pieChartDataSet.colors = colorsUse
        //pieChartDataSet.setDrawValues = false
        
    }


}
