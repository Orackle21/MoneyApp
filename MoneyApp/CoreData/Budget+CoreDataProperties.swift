//
//  Budget+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 22.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Transaction")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var currency: Currency?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var month: Int32
    @NSManaged public var note: String?
    @NSManaged public var simpleDate: Int64
    @NSManaged public var year: Int32
    @NSManaged public var category: Category?
    @NSManaged public var wallet: Wallet?

}
