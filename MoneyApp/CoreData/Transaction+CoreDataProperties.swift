//
//  Transaction+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 22.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
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
    @NSManaged public var dateCreated: Date?
    @NSManaged public var month: Int64
    @NSManaged public var note: String?
    @NSManaged public var simpleDate: Int64
    @NSManaged public var year: Int64
    @NSManaged public var wallet: Wallet?
    @NSManaged public var category: Category?

}
