//
//  CategoryModel.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

struct CategoryModel {
    private(set) var categoryTitle: String
    private(set) var categoryBackgroundColor: UIColor
    private(set) var categoryTitleColor: UIColor
    private(set) var categoryImage: String

    init(categoryTitle: String, categoryBackgroundColor: UIColor, categoryTitleColor: UIColor, categoryImage: String) {
        self.categoryTitle = categoryTitle
        self.categoryBackgroundColor = categoryBackgroundColor
        self.categoryTitleColor = categoryTitleColor
        self.categoryImage = categoryImage
    }

}
