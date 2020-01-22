//
//  Wallet+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 28.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension Wallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wallet> {
        return NSFetchRequest<Wallet>(entityName: "Wallet")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var currency: Currency?
    @NSManaged public var isSelected: Bool
    @NSManaged public var name: String?
    @NSManaged public var skin: Skin?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var categories: NSSet?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var walletContainer: WalletContainer?

}

// MARK: Generated accessors for categories
extension Wallet {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension Wallet {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Budget)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Budget)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
