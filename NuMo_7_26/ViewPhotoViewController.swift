//
//  viewPhotoViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 11/9/15.
//  Copyright © 2015 kathrynmanning. All rights reserved.
//

import UIKit

class ViewPhotoViewController: UIViewController {

    var image:UIImage? = nil
    @IBOutlet weak var foodImage: UIImageView!
    
    override func viewDidLoad()
    {
        foodImage.image = image
    }
    
}
