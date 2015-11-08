//
//  MyDayViewController.swift
//  usdaSqlPractice
//
//  Created by Kathryn Manning on 6/4/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

var dateChosen : String = "2015-06-30"

class MyDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    
    let daysInMonths = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    let daysInMonthsLeap = [0,31,29,31,30,31,30,31,31,30,31,30,31]
    let daysInYear = 365
    //hardcoded nutrients to show
    var nutrientsToShow = [208, 204, 203, 205, 209, 212, 210, 291, 303, 309, 301, 418, 401, 306, 307, 601, 269]
    
    var itemOrNutrientFlag = "item"
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var itemNutrientSegControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let nutrientCommonNames = [
        203 : "Protein",
        204 : "Fat",
        205 : "Carbohydrate",
        208 : "Calories",
        209 : "Starch",
        210 : "Sucrose",
        211 : "Glucose",
        212 : "Fructose",
        255 : "Water",
        262 : "Caffeine",
        269 : "Sugar",
        291 : "Fiber",
        301 : "Calcium",
        303 : "Iron",
        304 : "Magnesium",
        305 : "Phosphorus",
        306 : "Potassium",
        307 : "Sodium",
        309 : "Zinc",
        312 : "Copper",
        313 : "Fluoride",
        315 : "Manganese",
        317 : "Selenium",
        318 : "Vitamin A",
        321 : "Beta Carotene",
        322 : "Alpha Carotene",
        323 : "Vitamin E",
        417 : "Folate",
        418 : "Vitamin B-12",
        601 : "Cholesterol",
        605 : "Trans Fats",
        606 : "Saturated Fat",
        401 : "Vitamin C",
        324 : "Vitamin D"
    ]
    
    
    //need to use a UI element to chose this String date
    //var dateChosen = "2015-06-30"
    
    //holds (FoodItems for the table, numberOfItems)
    var logInfo : ([FoodForTable], Int)?
    
    //holds (Nutrient, totalRightNow)
    var nutrientTotals : Dictionary<Int, (nutrient:Nutrient, total:Double)>?
    
    //hold photo references for current day (filename,time logged)
    var photosToday : [(String,String)]?
    
    
    //--------Lifecycle Methods----------//
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        //in order to use our custom nutrient cell nib
        let nib = UINib(nibName: "nutrientTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "nutrientCell")
        
        //customize back button text
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        
       // tableView.backgroundColor = UIColor.grayColor()
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor = UIColor.clearColor()
        
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
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateInFormat = dateFormatter.stringFromDate(date)
        return dateInFormat
    }
    
    //--------Calendar Day Methods--------//
  
    
    @IBAction func goBackADay(sender: AnyObject) {
        
        let calendar = NSCalendar.currentCalendar()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(dateChosen)
        
        
        let components = NSDateComponents()
        components.day = -1
        
        print("-1 from \(dateChosen): \(calendar.dateByAddingComponents(components, toDate: date!, options: []))")
        print("-1 from \(dateChosen): \(dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!))")
        
        dateChosen = dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!)
        
        let todaysDate = getTodaysDateString()
        if todaysDate == dateChosen
        {
            self.dateLabel.text = "Today"
        }
        else if dateChosen == findRealYesterday(){
            self.dateLabel.text = "Yesterday"
        }
        else {
            self.dateLabel.text = dateChosen
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func goForwardADay(sender: AnyObject) {

        
        let calendar = NSCalendar.currentCalendar()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(dateChosen)
        
        
        let components = NSDateComponents()
        components.day = 1
        
        print("1 from \(dateChosen): \(calendar.dateByAddingComponents(components, toDate: date!, options: []))")
        print("1 from \(dateChosen): \(dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!))")
        
        dateChosen = dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!)
        
        let todaysDate = getTodaysDateString()
        if todaysDate == dateChosen
        {
            self.dateLabel.text = "Today"
        }
        else if dateChosen == findRealYesterday(){
            self.dateLabel.text = "Yesterday"
        }
        else {
            self.dateLabel.text = dateChosen
        }
        self.tableView.reloadData()

    }
    
    
    //returns actual yesterday's string date
    func findRealYesterday() -> String {
        
        let calendar = NSCalendar.currentCalendar()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(getTodaysDateString())
        
        
        let components = NSDateComponents()
        components.day = -1
        
        return dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date!, options: [])!)

    }
    
    //--------Table View Methods---------//
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if itemOrNutrientFlag == "item"
        {
            //self.tableView.separatorColor = UIColor.colorFromCode(0xDBE6EC)
            self.tableView.separatorColor = UIColor.clearColor()
            
            //START ADDING...
            var count = 0
            
            self.photosToday = ModelManager.instance.getPhotosForDate(dateChosen)
            //theres at least 1 reminder photo
            if self.photosToday != nil {
                count += (photosToday?.count)!
                print("\(count) photos are logged today")
            }
            
            
            //get the logged food items from the db
            self.logInfo =  ModelManager.instance.getLoggedItems(dateChosen)
            if self.logInfo != nil
            {
                //was:
                //let count = self.logInfo!.1
                count += self.logInfo!.1
                print("\(self.logInfo!.1) foods are logged")
                
            }

            //was an else here that returned 0 if no foods logged...
            
            print("\(count) total things are logged")
            return count

        }
        else if itemOrNutrientFlag == "nutrient"
        {
            //self.tableView.separatorColor = UIColor.colorFromCode(0xDBE6EC)
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
            let cell : NutrientTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("nutrientCell") as! NutrientTableViewCell
            
            //grab nutrient from of array of nutrients to show
            let nutrientId = self.nutrientsToShow[indexPath.row]
            
            //grab associated element from dictionary of all nutrient totals
            //**** this dictionary should start out with all totals being 0
            //if there is no record in the nutrient total dictionary for this nutrientID
            //need to just say 0.0!
            let nutrientCellInfo = self.nutrientTotals![nutrientId]
            
            if nutrientCellInfo != nil {
            
                //grab the title String from nutrientTotals
                
                let id = nutrientCellInfo!.nutrient.nutrientId
                var title = nutrientCommonNames[id]
                
                if title == nil {
                    let emptyNutrient = ModelManager.instance.getANutrientInfo(nutrientId)
                    title = emptyNutrient.name
                }
                
                //var title = nutrientCellInfo!.nutrient.name
                
                let unit = nutrientCellInfo!.nutrient.units
                let totalAmount = nutrientCellInfo!.total
                
                cell.nutrientNameLabel.text = title
                
                
                
//                let hue = CGFloat(indexPath.row)/CGFloat(nutrientsToShow.count)
//                cell.nutrientNameLabel.textColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.5, alpha: 1.0)
                //cell.nutrientNameLabel.textColor =
                //println("**** \(totalAmount)")
                cell.percentNutrientLabel.text = String(format: "%.2f \(unit)", totalAmount)
            
            }
            else //there is no amount recorded yet for this nutrient
            {
                let emptyNutrient = ModelManager.instance.getANutrientInfo(nutrientId)
                
                
                let id = emptyNutrient.nutrientId
                var title = nutrientCommonNames[id]
                
                if title == nil {
                    let emptyNutrient = ModelManager.instance.getANutrientInfo(nutrientId)
                    title = emptyNutrient.name
                }
                
                
                cell.nutrientNameLabel.text = title
                //cell.nutrientNameLabel.text = emptyNutrient.name
                
                cell.percentNutrientLabel.text = String("0.00 \(emptyNutrient.units)")
            }
            
            //---test other colors
            

//                let row = CGFloat(indexPath.row)
//                let section = CGFloat(indexPath.section)
//                //compute row as hue and section as saturation
//                let saturation  = 1.0 - row / CGFloat(nutrientsToShow.count)
//                let hue =  section / CGFloat(5)
//                let theColor = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
//            
//            cell.nutrientNameLabel.textColor = theColor
//            cell.percentNutrientLabel.textColor = theColor
            
            
            //----end test
            
            
            
            let hue = 1 - (CGFloat(indexPath.row)/CGFloat(nutrientsToShow.count))
            //print("THE HUE IS: \(hue)")
            cell.nutrientNameLabel.textColor = UIColor(hue: hue, saturation: 1.0, brightness: 0.9, alpha: 1.0)
            cell.percentNutrientLabel.textColor = UIColor(hue: hue, saturation: 1.0, brightness: 0.9, alpha: 1.0)

            cell.backgroundColor = UIColor.clearColor()
    
            
            return cell
        }
        //we are on item screen
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView!.image = nil
            
            var numOfPhotosToday = 0
            if photosToday != nil {
                numOfPhotosToday = (photosToday?.count)!
            }
                
            if indexPath.row < numOfPhotosToday {
                //make a reminder cell!
                  
                let photo = PhotoHelper()
                let path = photo.makeImagePath(photosToday![indexPath.row].0)

                let d = photo.loadImageFromPath(path)

                let newImage = resizeImage(d!, toTheSize: CGSizeMake(44, 44))
                let cellImageLayer: CALayer?  = cell.imageView!.layer
                cellImageLayer!.cornerRadius = 21.75  //cell.imageView!.frame.size.width / 2.0
                cellImageLayer!.masksToBounds = true
                cell.imageView!.image = newImage

                cell.textLabel?.text = "Reminder"
                cell.detailTextLabel?.text = "Meal"

            }
            
            else{
                print("MMMMMKKKKK")
                let foodItem = self.logInfo!.0[indexPath.row - numOfPhotosToday]
                
                cell.textLabel?.text = foodItem.foodDesc
                
                
                let wholeNum : Int = Int(foodItem.wholeNumber)
                
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
            }
            let hue = 1 - (CGFloat(indexPath.row)/CGFloat(nutrientsToShow.count))
            //let hue = 1 - (CGFloat(indexPath.row - numOfPhotosToday)/CGFloat(nutrientsToShow.count))

            cell.detailTextLabel?.textColor = UIColor(hue: hue, saturation: 1.0, brightness: 0.9, alpha: 1.0)
            cell.textLabel?.textColor = UIColor(hue: hue, saturation: 1.0, brightness: 0.9, alpha: 1.0)
            
            
//            if indexPath.row == 0 {
//                
//                let photo = PhotoHelper()
//                let path = photo.makeImagePath("kkk")
//                
//                let d = photo.loadImageFromPath(path)
//               
//                let newImage = resizeImage(d!, toTheSize: CGSizeMake(44, 44))
//                let cellImageLayer: CALayer?  = cell.imageView!.layer
//                cellImageLayer!.cornerRadius = 21.75  //cell.imageView!.frame.size.width / 2.0
//                cellImageLayer!.masksToBounds = true
//                cell.imageView!.image = newImage
//                
//                cell.textLabel?.text = "Sushi Lunch"
//                cell.detailTextLabel?.text = "Reminder"
//
//                
//                return cell
//            }
            print("HHHHHHMMMM")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var numOfPhotosToday = 0
        if photosToday != nil {
            numOfPhotosToday = (photosToday?.count)!
        }
        //for now photo cells are not highlightable
        if indexPath.row < numOfPhotosToday {
            return false
        }
        
        return true
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRectMake( 0, 0, width, height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //delete item from sql food_log table
            var numOfPhotosToday = 0
            if photosToday != nil {
                numOfPhotosToday = (photosToday?.count)!
            }
            
            if indexPath.row < numOfPhotosToday {
                //were deleting an image reminder
                print("delete image reminder from row: \(indexPath.row)")
                let time = self.photosToday![indexPath.row].1
                
                //delete from documents folder?! or will it just be overwritten....
                
                let isDeleted = ModelManager.instance.deletePhotoReminder(dateChosen, time: time)
                print("The photo reference was deleted: \(isDeleted)")
            }
            
            else {
                
                let time = self.logInfo!.0[indexPath.row - numOfPhotosToday].time
                
                ModelManager.instance.deleteItemFromFoodLog(dateChosen , time: time)
            }
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
            print("flag was nutrient")
            self.performSegueWithIdentifier("goToNutrientDetail", sender: tableView)
        }
        else
        {
            print("flag was not nutrient")
            
            var numOfPhotosToday = 0
            if photosToday != nil {
                numOfPhotosToday = (photosToday?.count)!
            }
            
            if indexPath.row < numOfPhotosToday {
                //for photo selections...
            }
            else {
                self.performSegueWithIdentifier("goToAdjustFoodAmount", sender: tableView)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToNutrientDetail"
        {
            
        }
        else if segue.identifier == "goToAdjustFoodAmount"
        {
            let destinationVC = segue.destinationViewController as! PickAmountViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            var numOfPhotosToday = 0
            if photosToday != nil {
                numOfPhotosToday = (photosToday?.count)!
            }
            
           
            let chosenItemId = self.logInfo!.0[indexPath.row - numOfPhotosToday].foodId
            //now get the Food object for this id
            //from the allFoods[] global array...
            let searchById = allFoods.filter({f in f.id <= chosenItemId && f.id >= chosenItemId})
            
            let timeLogged = self.logInfo!.0[indexPath.row - numOfPhotosToday].time
            
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
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        //create action sheet
        let optionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            print("from library")
            //shows the photo library
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            self.imagePicker.modalPresentationStyle = .Popover
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let cameraOption = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            print("take a photo")
            //shows the camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.imagePicker.modalPresentationStyle = .Popover
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        optionSheet.addAction(photoLibraryOption)
        optionSheet.addAction(cancelOption)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
            optionSheet.addAction(cameraOption)} else {
            print ("I don't have a camera.")
        }
        
        
        self.presentViewController(optionSheet, animated: true, completion: nil)
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //handle media here i.e. do stuff with photo
        
        print("imagePickerController called")
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //imageImage.image = chosenImage
        
        //save to database
        let intId = ModelManager.instance.addPhotoToDb()
        let stringId = String(intId)
        
        let photo = PhotoHelper()
        let path = photo.makeImagePath(stringId)
        photo.saveImage(chosenImage, path: path)
        
        let d = photo.loadImageFromPath(path)
        //imageImage.image = d!
        
        dismissViewControllerAnimated(true, completion: nil)
    }

}
