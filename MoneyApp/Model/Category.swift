//
//  Categories.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

class Category: NSObject {
   
    let name: String?
    let iconGradients: [CGColor]?
    let isSubcategory: Bool?
    let canBeDeleted: Bool?
    let isSubcategoryOf: Category?
    
    init(name: String, gradients: [CGColor], isSubcategory: Bool, canBeDeleted: Bool, isSubcategoryOf: Category?) {
        self.name = name
        self.iconGradients = gradients
        self.isSubcategory = isSubcategory
        self.canBeDeleted = canBeDeleted
        self.isSubcategoryOf = isSubcategoryOf
    }
    
    
}
