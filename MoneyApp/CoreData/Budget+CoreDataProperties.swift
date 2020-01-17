//
//  Budget+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 17.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var endDate: Int64
    @NSManaged public var name: String?
    @NSManaged public var startDate: Int64
    @NSManaged public var isFinished: Bool
    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var category: Category?
    @NSManaged public var wallet: Wallet?

}
