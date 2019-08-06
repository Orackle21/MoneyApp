//
//  CategoryList.swift
//  MoneyApp
//
//  Created by Orackle on 06/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

class CategoryList{
    static let shared = CategoryList()
    var listOfAllCategories = [Category]()
    
    
    init(){
        addNewCategory(name: "Other", iconColors: [UIColor.magenta.cgColor, UIColor.cyan.cgColor], isSubcategory: false, canBeDeleted: false)
        addNewCategory(name: "Utilities", iconColors: [UIColor.red.cgColor, UIColor.blue.cgColor], isSubcategory: false, canBeDeleted: true)
        addNewCategory(name: "Transport", iconColors: [UIColor.orange.cgColor, UIColor.yellow.cgColor], isSubcategory: false, canBeDeleted: true)
        addNewCategory(name: "Food", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], isSubcategory: false, canBeDeleted: true)
    }
    
    func addNewCategory(name: String, iconColors: [CGColor], isSubcategory: Bool, canBeDeleted: Bool){
        let category = Category(name: name, gradients: iconColors, isSubcategory: isSubcategory, canBeDeleted: canBeDeleted)
        listOfAllCategories.append(category)
    }
    
    func moveCategory (from currentIndex: Int, to newIndex: Int) {
        let category = listOfAllCategories.remove(at: currentIndex)
        listOfAllCategories.insert(category, at: newIndex)
    }
    
    func removeCategory (with index: Int) {
        listOfAllCategories.remove(at: index)
    }
}
