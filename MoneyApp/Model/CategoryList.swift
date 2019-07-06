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
    static let list = CategoryList()
    var listOfAllCategories = [Category]()
    
    
    private init(){
        addNewCategory(name: "Food", iconColors: [UIColor.magenta.cgColor, UIColor.cyan.cgColor], isSubcategory: false)
        addNewCategory(name: "Utilities", iconColors: [UIColor.red.cgColor, UIColor.blue.cgColor], isSubcategory: false)
        addNewCategory(name: "Internet", iconColors: [UIColor.orange.cgColor, UIColor.yellow.cgColor], isSubcategory: false)
    }
    
    func addNewCategory(name: String, iconColors: [CGColor], isSubcategory: Bool){
        let category = Category(name: name, gradients: iconColors, isSubcategory: isSubcategory)
       listOfAllCategories.append(category)
        
    
    }
    
//    func removeCategory (with index: Int) {
//        listOfAllCategories.remove(at: index)
//    }
    
    func moveCategory (from currentIndex: Int, to newIndex: Int) {
        let category = listOfAllCategories.remove(at: currentIndex)
        listOfAllCategories.insert(category, at: newIndex)
    }
    
    
    
}
