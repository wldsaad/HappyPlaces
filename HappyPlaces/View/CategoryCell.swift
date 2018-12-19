//
//  CategoryCell.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    
    @IBOutlet weak var categoryBackground: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateView(category: CategoryModel){
        categoryBackground.backgroundColor = category.categoryBackgroundColor
        categoryLabel.text = category.categoryTitle
        categoryLabel.textColor = category.categoryTitleColor
        categoryImage.image = UIImage(named: category.categoryImage)
    }

}
