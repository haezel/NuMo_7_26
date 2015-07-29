//
//  NutrientItemCollectionViewCell.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/27/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

class NutrientItemCollectionViewCell: UICollectionViewCell {
    
    //@IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var progressView: ProgressView!

    
//    func setNutrientItemImage(item : NutrientItem) {
//        itemImageView.image = UIImage(named: item.itemImage)
//    }

    
    func setThePercent(percent : Double)
    {
        progressView.setThePercentComplete(percent)
    }
    
    func setNutrientTitle(title : String)
    {
        progressView.setTheNutrientTitle(title)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setCorrectCellSize(cellSize : CGFloat)
    {
        progressView.cellSize = cellSize
    }
    
    //init function that creates a progressview with correct size
    
    func animateProgressView()
    {
        progressView.animateProgressView()
    }
    
    func createProgressLayer(cellSize : CGFloat)
    {
        //progressView.createProgressLayer(cellSize)
    }
    
    func createLabel()
    {
        progressView.createLabel()
    }
    
    func hideProgressView()
    {
        progressView.hideProgressView()
    }
}