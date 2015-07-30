//
//  TheNutrientCollectionViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/27/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import Charts


class TheNutrientCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var nutrientsToShow = [204, 203, 208, 262, 291, 318, 621, 629, 675, 304, 305, 306, 307, 323, 601, 855]
    
    var nutrientsOmega6s = [672, 675, 685, 853, 855]
    var nutrientsOmega3s = [851, 852, 631, 629, 621]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var cellDimension : CGFloat?
    
    //holds nutrient totals. key is nutrient Id (Nutrient, totalRightNow)
    var nutrientTotals : Dictionary<Int, (nutrient:Nutrient, total:Double)>?
    
    //hold rda's. key is nutrient Id (recommended amount in proper unit)
    var nutrientRDAs : Dictionary<Int, (Double)>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //register a pie chart cell
        //collectionView.registerClass(NSClassFromString("PieChartCollectionViewCell"),forCellWithReuseIdentifier:"PieChartCollectionViewCell")
        //in order to use our custom nutrient cell nib
        var nib = UINib(nibName: "PieChartCollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "PieChartCollectionViewCell")
        
        self.nutrientRDAs = makePlayRDAs()
        
    }
    
    
    func makePlayRDAs() -> Dictionary<Int, (Double)> {
    
        var nt = Dictionary<Int, (Double)>()
        
        nt[204] = 65.0
        nt[203] = 50.0
        nt[208] = 2000.0
        nt[262] = 400.0
        nt[291] = 25.0
        nt[318] = 250.0
        nt[621] = 0.220
        nt[629] = 0.220
        nt[675] = 0.5
        nt[304] = 300.0
        nt[305] = 700.0
        nt[306] = 4700.0
        nt[307] = 2300.0
        nt[323] = 15.0
        nt[601] = 300.0
        nt[855] = 0.5
        
        return(nt)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------Data Source Methods----------//
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.nutrientTotals = ModelManager.instance.getNutrientTotals(dateChosen)
        
        //add one for top macros and omega-6/omega-3 ratio!
        return nutrientsToShow.count + 2

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PieChartCollectionViewCell", forIndexPath: indexPath) as! PieChartCollectionViewCell
            println("Cell Pie Created!")
            
            // proteins-carbs-fats cell
            if indexPath.row == 0 {
                
                
                let color1 = UIColor.colorFromCode(0x3485bf)
                let color2 = UIColor.colorFromCode(0x0994ff)
                let color3 = UIColor.colorFromCode(0x555555)
                
                let colors = [color1, color2, color3]
                
                //cell.backgroundColor = UIColor.colorFromCode(0xc9c9c9)
                
                cell.setData("Macronutrients", amounts: [23.0,34.0,51.0], labels: ["Pro","Fat","Carb"], colorsUse : colors)
            }
            
            // omega ratio cell
            if indexPath.row == 1 {
                
                //variables to hold totals
                var omega3 : Double = 0.0
                var omega6 : Double = 0.0
                
                
                //-------Omega-3 Calculation------//
                //    calculate total omega-3
                
                for nutrient in nutrientsOmega3s {
                    
                    //get nutrient object for the id
                    var nutrientCellInfo = self.nutrientTotals![nutrient]
                    
                    //if nutrient 851 doesnt exist use 619 instead.
                    if nutrient == 851 {
                        if nutrientCellInfo != nil {
                            omega3 += nutrientCellInfo!.total
                        } else {
                            nutrientCellInfo = self.nutrientTotals![619]
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
                
                
                
                
                //-------Omega-6 Calculation------//
                // calculate total omega-6
                for nutrient in nutrientsOmega6s {
                    
                    //get nutrient object for the id
                    var nutrientCellInfo = self.nutrientTotals![nutrient]
                    
                    //if nutrient 675 doesnt exist use 619 instead.
                    if nutrient == 675 {
                        if nutrientCellInfo != nil {
                            omega6 += nutrientCellInfo!.total
                        } else { //675 doesnt exist in db
                            nutrientCellInfo = self.nutrientTotals![618]
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
                            nutrientCellInfo = self.nutrientTotals![620]
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
                
             
                
                let theOmegasAmounts = [omega6, omega3]
                let theLabels = ["Omega-6","Omega-3"]
            
                
                let color2 = UIColor.colorFromCode(0x3485bf)
                let color1 = UIColor.colorFromCode(0xffba00)
                //let color2 = UIColor.colorFromCode(0x0994ff)
                
                let colors = [color1, color2]
                
                
                //cell.backgroundColor = UIColor.colorFromCode(0xc9c9c9)
                
                //cell.setData("Omega Ratio", amounts: [2.0,2.0], labels: ["Oh", "kay"])
                cell.setData("Omega Ratio", amounts: theOmegasAmounts, labels: ["Omega 6","Omega 3 "], colorsUse: colors)

            }
            
            return cell
        }
        
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NutrientItemCollectionViewCell", forIndexPath: indexPath) as! NutrientItemCollectionViewCell
            println("Cell Nutrient Circle Created!")
        

        
        
            //grab nutrient from of array of nutrients to show
            //subtract one due to top cell being not in nutrientsToShow array
            var nutrientId = self.nutrientsToShow[indexPath.row - 2]
            
            //grab associated element from dictionary of all nutrient totals
            //**** this dictionary should start out with all totals being 0
            //if there is no record in the nutrient total dictionary for this nutrientID
            //need to just say 0.0!
            var nutrientCellInfo = self.nutrientTotals![nutrientId]
            
            if nutrientCellInfo != nil {
                
                //grab the title String from nutrientTotals
                var title = nutrientCellInfo!.nutrient.name
                
                var unit = nutrientCellInfo!.nutrient.units
                var totalAmount = nutrientCellInfo!.total //the total in the correct unit
                
                cell.setNutrientTitle(title)
                
                var thePercent = totalAmount/self.nutrientRDAs![nutrientId]!
                
                cell.setThePercent(thePercent)
                //println("**** \(totalAmount)")
                //cell.percentNutrientLabel.text = String(format: "%.2f \(unit)", totalAmount)
                
            }
            else //there is no amount recorded yet for this nutrient
            {
                var emptyNutrient = ModelManager.instance.getANutrientInfo(nutrientId)
                cell.setNutrientTitle(emptyNutrient.name)
                cell.setThePercent(0.0)
                //cell.percentNutrientLabel.text = String("0.00 \(emptyNutrient.units)")
            }

        
//            if (indexPath.row % 5 == 0){
//                cell.backgroundColor = UIColor.colorFromCode(0xecd3f4)
//            }
//            if (indexPath.row % 5 == 1){
//                cell.backgroundColor = UIColor.colorFromCode(0xf8face)
//            }
//            if (indexPath.row % 5 == 2){
//                cell.backgroundColor = UIColor.colorFromCode(0xa8e3b3)
//            }
//            if (indexPath.row % 5 == 2){
//                cell.backgroundColor = UIColor.colorFromCode(0x9edfd8)
//            }
            
            cell.animateProgressView()
            
            return cell
        
        }
        
        
        
//        
//        cell.setNutrientTitle("Magnesium")
//        cell.setThePercent(0.86)
//        if (indexPath.row % 3 == 0){
//            cell.backgroundColor = UIColor.colorFromCode(0xecd3f4)
//        }
//        
//        cell.animateProgressView()
//        
//        return cell
        
    }
    
    
    //----------Collection View Delegate Methods-----------//
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //----------Layout Delegate Methods-----------//
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let screenSize = UIScreen.mainScreen().bounds
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
        
        //use similar to get cells of different sizes.
        if indexPath.row == 0 || indexPath.row == 1
        {
            //return CGSize(width: screenWidth, height: screenWidth/3)
            return CGSize(width: self.view.frame.size.width/2.0, height: self.view.frame.size.width/1.7)
        }
        
        let cellWidthDimension = self.view.frame.size.width / 2.0
        self.cellDimension = cellWidthDimension
        
        println("cell dimension decided")
       
        collectionView.reloadData()
        
        return CGSizeMake(cellWidthDimension, cellWidthDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return(0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return(0)
    }
    
    
    //---------Helper Get Today's Date Method--------//
    
    func getTodaysDateString() -> String {
        
        var date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateInFormat = dateFormatter.stringFromDate(date)
        return dateInFormat
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