//
//  SubCategory+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 26.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension SubCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCategory> {
        return NSFetchRequest<SubCategory>(entityName: "SubCategory")
    }

    @NSManaged public var parentCategory: Category?

}
