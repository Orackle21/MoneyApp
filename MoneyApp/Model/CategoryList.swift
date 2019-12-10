//
//  CategoryList.swift
//  MoneyApp
//
//  Created by Orackle on 06/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

class CategoryList {
    var listOfAllCategories = [Category]()
    
    
    init(){
        addNewCategory(name: "Others", iconColors: [UIColor.magenta.cgColor, UIColor.cyan.cgColor], canBeDeleted: false, isSubcategoryOf: nil)
        
        addNewCategory(name: "Utilities", iconColors: [UIColor.red.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: nil)
            addNewCategory(name: "Phone", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
            addNewCategory(name: "Water", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
            addNewCategory(name: "Electricity", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
            addNewCategory(name: "Internet", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
        
        addNewCategory(name: "Transport", iconColors: [UIColor.orange.cgColor, UIColor.yellow.cgColor],  canBeDeleted: true, isSubcategoryOf: nil)
            addNewCategory(name: "Taxi", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[2])
            addNewCategory(name: "Bus", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[2])
            addNewCategory(name: "Subway", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[2])
            addNewCategory(name: "parking", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[2])
        
        
        addNewCategory(name: "Food", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: nil)
            addNewCategory(name: "Restaurant", iconColors: [UIColor.blue.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[3])
            addNewCategory(name: "Beverages", iconColors: [UIColor.green.cgColor, UIColor.green.cgColor], canBeDeleted: true, isSubcategoryOf: listOfAllCategories[3])
        addNewCategory(name: "Shopping", iconColors: [UIColor.green.cgColor, UIColor.blue.cgColor], canBeDeleted: true, isSubcategoryOf: nil)
            
    }
    
    func addNewCategory(name: String, iconColors: [CGColor], canBeDeleted: Bool, isSubcategoryOf: Category?){
        let category = Category(name: name, gradients: iconColors, canBeDeleted: canBeDeleted, isSubcategoryOf: isSubcategoryOf)
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
