//
//  NutrientGraphViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 8/1/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import Charts

class NutrientGraphViewController: UIViewController {

    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var nutrientTitle : String?
    var nutrientUnit : String?
    
    var nutrientId : Int?
    
    var nutrientGraphData = (labels: [String](), values: [Double]())
    
    //for target lines
    var nRDAs : Dictionary<Int, (Double)>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        
        println(nutrientTitle)
        titleLabel.text = nutrientTitle!
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveChart:")
        
        
        self.nRDAs = ModelManager.instance.getAllNutrientRDAs()
        
        lineChart.noDataText = "Loading Chart..."
        lineChart.infoFont = UIFont(name: "AvenirNextCondensed-Regular", size: 16.0)!
        lineChart.infoTextColor = UIColor.colorFromCode(0x0040ff)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.nutrientGraphData = ModelManager.instance.getChartDataForNutrient(self.nutrientId!, startDate : dateChosen, nOfDays : 7)
            dispatch_async(dispatch_get_main_queue()) {
                let labels = self.nutrientGraphData.labels.reverse()
                let values = self.nutrientGraphData.values.reverse()
                
                
                
                self.setChart(labels, values: values)
            }
        }
        
        

        //get week of nutrient data
        //self.nutrientGraphData = ModelManager.instance.getWeekDataForNutrient(self.nutrientId!, startDate : currentDate, nOfDays : 7)
        
        
        println(self.nutrientId)
        //self.nutrientGraphData = ModelManager.instance.getChartDataForNutrient(self.nutrientId!, startDate : dateChosen, nOfDays : 7)
//        
//        let labels = self.nutrientGraphData.labels.reverse()
//        let values = self.nutrientGraphData.values.reverse()
//        
//
//        
//        setChart(labels, values: values)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        var theUnit : String
        
        if nutrientUnit != nil{
            theUnit = nutrientUnit!
        } else {
            theUnit = ""
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "\(nutrientTitle!), \(theUnit)")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
  
        
        //use these to make a Target Line
        let target = nRDAs![nutrientId!]!
        println("Target! \(target)")
        let ll = ChartLimitLine(limit: target, label: "RDI")
        lineChart.rightAxis.addLimitLine(ll)
        
        
        
        //lineChartDataSet.colors = colors
        lineChart.borderColor = UIColor.colorFromCode(0x0040ff)
        //background around the graph
        lineChart.backgroundColor = UIColor.colorFromCode(0xAAAAAA)
        //background of just gridded area
        lineChart.gridBackgroundColor = UIColor.colorFromCode(0xffd8ff)
        //??
        //lineChart.infoTextColor = UIColor.colorFromCode(0xdd24df)
        lineChart.drawBordersEnabled = true
        lineChart.drawGridBackgroundEnabled = false
        lineChart.noDataText = "Loading Chart..."
        lineChart.infoFont = UIFont(name: "AvenirNextCondensed-Regular", size: 16.0)!
        lineChart.infoTextColor = UIColor.colorFromCode(0x0040ff)
        
        lineChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.descriptionText = ""
        lineChartDataSet.colors = [UIColor.colorFromCode(0x0040ff)]
        lineChartDataSet.circleColors = [UIColor.colorFromCode(0x0040ff)]

        lineChart.data = lineChartData
        
    }
    
    
    
    func saveChart(sender: UIBarButtonItem) {
       
        lineChart.saveToCameraRoll()
    }
    
    
    @IBAction func monthPressed(sender: AnyObject) {
        
        
        self.nutrientGraphData = ModelManager.instance.getOmegasChartData(dateChosen, nOfDays : 30)
        
        let labels = self.nutrientGraphData.labels.reverse()
        let values = self.nutrientGraphData.values.reverse()
        
        
        
        self.setChart(labels, values: values)
        
    }
    
    
    @IBAction func weekPressed(sender: AnyObject) {
        
        self.nutrientGraphData = ModelManager.instance.getOmegasChartData(dateChosen, nOfDays : 7)
        
        let labels = self.nutrientGraphData.labels.reverse()
        let values = self.nutrientGraphData.values.reverse()
        
        
        
        self.setChart(labels, values: values)
        
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
