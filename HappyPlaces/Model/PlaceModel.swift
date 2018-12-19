//
//  PlaceModel.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import Foundation

struct PlaceModel {
    private(set) public var title: String
    private(set) public var distance: Double
    
    init(title: String, distance: Double) {
        self.title = title
        self.distance = distance
    }

}
