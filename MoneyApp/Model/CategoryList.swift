////
////  CategoryList.swift
////  MoneyApp
////
////  Created by Orackle on 06/07/2019.
////  Copyright © 2019 Orackle. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class CategoryList {
//    var listOfAllCategories = [Category]()
//    
//    
//    init(){
//        addNewCategory(name: "Others", skin: Skin(name: "dusk", color: "Dusk", icon: "atm"), canBeDeleted: false, isSubcategoryOf: nil)
//        
//        addNewCategory(name: "Utilities", skin: Skin(name: "dusk", color: "Field", icon: "bus"), canBeDeleted: true, isSubcategoryOf: nil)
//            addNewCategory(name: "Phone", skin: Skin(name: "dusk", color: "Lollipop", icon: "cart"), canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
//            addNewCategory(name: "Water", skin: Skin(name: "dusk", color: "Midnight", icon: "food"), canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
//            addNewCategory(name: "Electricity", skin: Skin(name: "dusk", color:"Old Gold", icon: "health"), canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
//            addNewCategory(name: "Internet", skin: Skin(name: "dusk", color: "Sunrise", icon: "restaurant"), canBeDeleted: true, isSubcategoryOf: listOfAllCategories[1])
//        
//        addNewCategory(name: "Transport", skin: Skin(name: "dusk", color: "Terracota", icon: "taxi"),  canBeDeleted: true, isSubcategoryOf: nil)
//            addNewCategory(name: "Taxi", skin: Skin(name: "dusk", color: "Wave", icon: "taxi"), canBeDeleted: true, isSubcategoryOf: listOfAllCategories[2])
//
//        
//            
//    }
//    
//    func addNewCategory(name: String, skin: Skin, canBeDeleted: Bool, isSubcategoryOf: Category?){
//        let category = Category(name: name, skin: skin, canBeDeleted: canBeDeleted, isSubcategoryOf: isSubcategoryOf)
//        listOfAllCategories.append(category)
//    }
//    
//    func moveCategory (from currentIndex: Int, to newIndex: Int) {
//        let category = listOfAllCategories.remove(at: currentIndex)
//        listOfAllCategories.insert(category, at: newIndex)
//    }
//    
//    func removeCategory (with index: Int) {
//        listOfAllCategories.remove(at: index)
//    }
//}
