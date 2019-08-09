//
//  Categories.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

struct Category: Equatable {
   
    let name: String?
    let iconGradients: [CGColor]?
    let isSubcategory: Bool?
    let canBeDeleted: Bool?
    
    init(name: String, gradients: [CGColor], isSubcategory: Bool, canBeDeleted: Bool) {
        self.name = name
        self.iconGradients = gradients
        self.isSubcategory = isSubcategory
        self.canBeDeleted = canBeDeleted

    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}
