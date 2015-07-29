//
//  NutrientTableViewCell.swift
//  FoodSearchJson
//
//  Created by Kathryn Manning on 5/24/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

class NutrientTableViewCell: UITableViewCell {

    @IBOutlet weak var nutrientNameLabel: UILabel!
    @IBOutlet weak var percentNutrientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
