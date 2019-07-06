//
//  Categories.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    let name: String?
    let iconGradients: [CGColor]?
    let isSubcategory: Bool?
   // let subcategoryOf: Category?
    
    init(name: String, gradients: [CGColor], isSubcategory: Bool) {
        self.name = name
        self.iconGradients = gradients
        self.isSubcategory = isSubcategory
    }
    
    
    }
    
    
    

