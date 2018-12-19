//
//  DataService.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class DataService {
    
    static let instance = DataService()
    
    private let categories = [
    CategoryModel(categoryTitle: "Restaurant", categoryBackgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), categoryTitleColor: .red, categoryImage: "restaurant"),
    CategoryModel(categoryTitle: "Hotel", categoryBackgroundColor: #colorLiteral(red: 0.9759346843, green: 0.5839473009, blue: 0.02618087828, alpha: 1), categoryTitleColor: .black, categoryImage: "hotel"),
    CategoryModel(categoryTitle: "Bank", categoryBackgroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), categoryTitleColor: .white, categoryImage: "bank"),
    CategoryModel(categoryTitle: "School", categoryBackgroundColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), categoryTitleColor: .white, categoryImage: "school"),
    CategoryModel(categoryTitle: "Mosque", categoryBackgroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), categoryTitleColor: .white, categoryImage: "mosque")
    ]
    
    func getCategories() -> [CategoryModel] {
        return categories
    }
}

