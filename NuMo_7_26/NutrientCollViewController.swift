//
//  NutrientCollViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/27/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import Charts

class NutrientCollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var myImages = [String]()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myImages = ["1.jpg",
            "2.jpg",
            "3.jpg",
            "4.jpg",
            "5.jpg"
        ]
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
        return myImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NutrientItemCollectionViewCell", forIndexPath: indexPath) as! NutrientItemCollectionViewCell
        
        //cell.setNutrientItemImage(myImages[indexPath.row])
        
        //create the image
        let image = UIImage(named: myImages[indexPath.row])
        //set it as the image!
        //cell.itemImageView.image = image
        
        return cell
        
    }
    
    //----------Delegate Methods-----------//
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //----------Delegate Methods-----------//
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        if (indexPath.row == 0) {
//            
//            let picDimensionW = self.view.frame.size.width
//            let picDimensionH = self.view.frame.size.width / 3.0
//            
//            return CGSizeMake(picDimensionW, picDimensionH)
//
//        }
        
        let picDimension = self.view.frame.size.width / 3.0
        
        return CGSizeMake(picDimension, picDimension)
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
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
