//
//  PieChartCollectionViewCell.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/28/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import Charts

class PieChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pieChartView: PieChartView!
    

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setNutrientLabel()
        
        
        //----!!!!test pie chart-----//
        
//        let months = ["Protein", "Fat", "Carb"]
//        let unitsSold = [20.0, 4.0, 6.0]
//        
//        
//        
//        setChart(months, values: unitsSold)
        
        //-----end test pie!!!!!-----//
    }
    
    func setData(title : String, amounts : [Double], labels : [String], colorsUse : [UIColor]) {
        
        pieChartView.centerText = title
        
        
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
        pieChartView.data = pieChartData
        
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
        
        pieChartView.legend.position = .BelowChartCenter
        pieChartView.drawSliceTextEnabled = false
        
        pieChartView.infoFont = UIFont(name: "AvenirNextCondensed-Regular", size: 16.0)!
        pieChartView.holeRadiusPercent = 0.75
        pieChartView.drawHoleEnabled = true
        pieChartView.holeColor = UIColor.colorFromCode(0x919191)
        //pieChartView.centerText = "Macronutrients"
        pieChartView.centerTextFont = UIFont(name: "AvenirNextCondensed-Medium", size: 16.0)!
        pieChartView.centerTextColor = UIColor.colorFromCode(0xffffff)
        pieChartView.descriptionText = ""
        pieChartDataSet.colors = colorsUse
        //pieChartDataSet.setDrawValues = false
    
    }

}
