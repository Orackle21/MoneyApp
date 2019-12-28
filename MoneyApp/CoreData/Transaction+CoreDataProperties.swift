//
//  Transaction+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 28.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var currency: Currency?
    @NSManaged public var date: Date?
    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var note: String?
    @NSManaged public var year: Int32
    @NSManaged public var dateCreated: Date?
    @NSManaged public var category: Category?
    @NSManaged public var wallet: Wallet?

}
