//
//  NutrientCollectionViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/27/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

let reuseIdentifier = "NutrientCell"

class NutrientCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var myImages = [String]()
    
    //var collectionView: UICollectionView?
    var screenWidth: CGFloat!
    var screenSize: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        myImages = ["1.jpg",
            "2.jpg",
            "3.jpg",
            "4.jpg",
            "5.jpg"
        ]
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        //collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "NutrientCell")
        collectionView!.backgroundColor = UIColor.greenColor()
        self.view.addSubview(collectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    //---------data source and delegate methods----------//
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        println("KKK***")
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(myImages.count)
        return myImages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NutrientCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
//        cell.layer.borderColor = UIColor.blackColor().CGColor
//        cell.layer.borderWidth = 0.5
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3

        
        // Configure the cell
        let image = UIImage(named: myImages[indexPath.row])
        cell.imageView.image = image
        
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
