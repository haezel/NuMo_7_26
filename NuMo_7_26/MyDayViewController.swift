//
//  MyDayViewController.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 6/4/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

var dateChosen : String = "2015-06-30"

class MyDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let daysInMonths = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    let daysInYear = 365
    //hardcoded nutrients to show
    var nutrientsToShow = [204, 203, 208, 262, 291, 318, 621, 629, 675, 304, 305, 306, 307, 573, 601, 855]
    
    var itemOrNutrientFlag = "item"
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var itemNutrientSegControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //need to use a UI element to chose this String date
    //var dateChosen = "2015-06-30"
    
    //holds (FoodItems for the table, numberOfItems)
    var logInfo : ([FoodForTable], Int)?
    
    //holds (Nutrient, totalRightNow)
    var nutrientTotals : Dictionary<Int, (nutrient:Nutrient, total:Double)>?
    
    
    //--------Lifecycle Methods----------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //in order to use our custom nutrient cell nib
        var nib = UINib(nibName: "nutrientTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "nutrientCell")
        
        //customize back button text
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        
       // tableView.backgroundColor = UIColor.grayColor()
        tableView.tableFooterView = UIView(frame:CGRectZero)
       // tableView.separatorColor = UIColor.clearColor()
        
        //get rid of 1 cell space at top and bottom of tableview - not best solution
        self.automaticallyAdjustsScrollViewInsets = false
        
        let todaysDate = getTodaysDateString()
        if todaysDate == dateChosen
        {
            self.dateLabel.text = "Today"
        }
        else
        {
            self.dateLabel.text = dateChosen
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
        self.nutrientTotals = ModelManager.instance.getNutrientTotals(dateChosen)
    }
    
    //---------Helper Get Today's Date Method--------//
    
    func getTodaysDateString() -> String {
        
        var date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateInFormat = dateFormatter.stringFromDate(date)
        return dateInFormat
    }
    
    //--------Change Calendar Day Methods--------//
    //--------These need to be implemented better...only works for 30 day months...
  
    
    @IBAction func goBackADay(sender: AnyObject) {
    
        var currentDate = dateChosen
        var myStringArr = currentDate.componentsSeparatedByString("-")
        var oldyear = myStringArr[0].toInt()
        var oldmonth = myStringArr[1].toInt()
        var oldday = myStringArr[2].toInt()
        
        var newday = 100
        var newmonth = 100
        
        if oldday == 1
        {
            newday = 30
            newmonth = oldmonth! - 1
        }
        else
        {
            newday = oldday! - 1
            newmonth = oldmonth!
        }
        
        if newday < 10
        {
            dateChosen = "\(oldyear!)-0\(newmonth)-0\(newday)"
        }
        else
        //println("\(oldyear!)-\(newmonth)-\(newday)")
        {
            dateChosen = "\(oldyear!)-0\(newmonth)-\(newday)"
        }
        
        let todaysDate = getTodaysDateString()
        if todaysDate == dateChosen
        {
            self.dateLabel.text = "Today"
        }
        else {
            self.dateLabel.text = dateChosen
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func goForwardADay(sender: AnyObject) {
   
        var currentDate = dateChosen
        var myStringArr = currentDate.componentsSeparatedByString("-")
        var oldyear = myStringArr[0].toInt()
        var oldmonth = myStringArr[1].toInt()
        var oldday = myStringArr[2].toInt()
        
        var newday = 100
        var newmonth = 100
        
        if oldday == 30
        {
            newday = 1
            newmonth = oldmonth! + 1
        }
        else
        {
            newday = oldday! + 1
            newmonth = oldmonth!
        }
        if newday < 10
        {
            dateChosen = "\(oldyear!)-0\(newmonth)-0\(newday)"
        }
        //println("\(oldyear!)-\(newmonth)-\(newday)")
        else
        {
            dateChosen = "\(oldyear!)-0\(newmonth)-\(newday)"
        }
        
        let todaysDate = getTodaysDateString()
        if todaysDate == dateChosen
        {
            self.dateLabel.text = "Today"
        }
        else {
            self.dateLabel.text = dateChosen
        }
        self.tableView.reloadData()
    }
    
    //--------Table View Methods---------//
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if itemOrNutrientFlag == "item"
        {
            self.tableView.separatorColor = UIColor.colorFromCode(0xDBE6EC)
            //get the logged food items from the db
            self.logInfo =  ModelManager.instance.getLoggedItems(dateChosen)
            if self.logInfo != nil
            {
                let count = self.logInfo!.1
                return count
            }
            else //have not logged any foods
            {
                println("no foods are logged")
                return 0
            }
        }
        else if itemOrNutrientFlag == "nutrient"
        {
            self.tableView.separatorColor = UIColor.clearColor()
            self.nutrientTotals = ModelManager.instance.getNutrientTotals(dateChosen)
           
            return nutrientsToShow.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if itemOrNutrientFlag == "nutrient"
        {
            var cell : NutrientTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("nutrientCell") as! NutrientTableViewCell
            
            //grab nutrient from of array of nutrients to show
            var nutrientId = self.nutrientsToShow[indexPath.row]
            
            //grab associated element from dictionary of all nutrient totals
            //**** this dictionary should start out with all totals being 0
            //if there is no record in the nutrient total dictionary for this nutrientID
            //need to just say 0.0!
            var nutrientCellInfo = self.nutrientTotals![nutrientId]
            
            if nutrientCellInfo != nil {
            
                //grab the title String from nutrientTotals
                var title = nutrientCellInfo!.nutrient.name
                
                var unit = nutrientCellInfo!.nutrient.units
                var totalAmount = nutrientCellInfo!.total
                
                cell.nutrientNameLabel.text = title
                //println("**** \(totalAmount)")
                cell.percentNutrientLabel.text = String(format: "%.2f \(unit)", totalAmount)
            
            }
            else //there is no amount recorded yet for this nutrient
            {
                var emptyNutrient = ModelManager.instance.getANutrientInfo(nutrientId)
                cell.nutrientNameLabel.text = emptyNutrient.name
                cell.percentNutrientLabel.text = String("0.00 \(emptyNutrient.units)")
            }

            cell.backgroundColor = UIColor.clearColor()
    
            
            return cell
        }
        
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            
            let foodItem = self.logInfo!.0[indexPath.row]
            
            cell.textLabel?.text = foodItem.foodDesc
            cell.backgroundColor = UIColor.clearColor()
            
            var wholeNum : Int = Int(foodItem.wholeNumber)
            
            let frac : String = fracToString(foodItem.fraction)
            let measure = foodItem.measureDesc
            
            if wholeNum != 0
            {
                cell.detailTextLabel?.text = "\(wholeNum) \(frac) \(measure)"
            }
            else
            {
                cell.detailTextLabel?.text = "\(frac) \(measure)"
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //delete item from sql food_log table
            
            let time = self.logInfo!.0[indexPath.row].time
            
            ModelManager.instance.deleteItemFromFoodLog(dateChosen , time: time)
            
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if itemOrNutrientFlag == "nutrient" {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //for testing of custom nutrient cell
        if itemOrNutrientFlag == "nutrient" {
            return 54.0
        }
        else {
            return 43.0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if itemOrNutrientFlag == "nutrient"
        {
            println("flag was nutrient")
            self.performSegueWithIdentifier("goToNutrientDetail", sender: tableView)
        }
        else
        {
            println("flag was not nutrient")
            self.performSegueWithIdentifier("goToAdjustFoodAmount", sender: tableView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToNutrientDetail"
        {
            
        }
        else if segue.identifier == "goToAdjustFoodAmount"
        {
            let destinationVC = segue.destinationViewController as! PickAmountViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let chosenItemId = self.logInfo!.0[indexPath.row].foodId
            //now get the Food object for this id
            //from the allFoods[] global array...
            let searchById = allFoods.filter({f in f.id <= chosenItemId && f.id >= chosenItemId})
            
            let timeLogged = self.logInfo!.0[indexPath.row].time
            
            destinationVC.timePreviouslyLogged = timeLogged
            destinationVC.foodItem = searchById[0]
            destinationVC.toggleAdjustOrAdd = "adjust"
        }
    }
    
    
    //--------Unwind Segue Methods--------//
    
    @IBAction func cancelToMyDayViewController(segue:UIStoryboardSegue) {
        
    }
    
//    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
//        
//    }
    
    //---------Segmented Control Changed---------//
    
   
    @IBAction func itemNutrientChanged(sender: UISegmentedControl) {
    
        switch itemNutrientSegControl.selectedSegmentIndex
        {
        case 0:
            itemOrNutrientFlag = "item"
        case 1:
            itemOrNutrientFlag = "nutrient"
        default:
            break
        }
        tableView.reloadData()
        
    }
    
    //----------Helper Methods---------//
    
    func fracToString(fraction : Double) -> String
    {
        switch fraction
        {
        case 0.0:
            return ""
        case 0.125:
            return "1/8"
        case 0.25:
            return "1/4"
        case 0.333:
            return "1/3"
        case 0.5:
            return "1/2"
        case 0.666:
            return "2/3"
        case 0.75:
            return "3/4"
        default:
            return ""
        }
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
