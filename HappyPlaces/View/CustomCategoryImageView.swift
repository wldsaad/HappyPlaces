//
//  CustomCategoryImageView.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class CustomCategoryImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowRadius = 3
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 3, height: 3)
        
    }

}
