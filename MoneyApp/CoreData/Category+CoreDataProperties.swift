//
//  Category+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 11.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var isDeletable: Bool
    @NSManaged public var name: String?
    @NSManaged public var skin: Skin?
    @NSManaged public var isExpense: Bool
    @NSManaged public var subCategories: NSOrderedSet?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var wallet: Wallet?

}

// MARK: Generated accessors for subCategories
extension Category {

    @objc(insertObject:inSubCategoriesAtIndex:)
    @NSManaged public func insertIntoSubCategories(_ value: SubCategory, at idx: Int)

    @objc(removeObjectFromSubCategoriesAtIndex:)
    @NSManaged public func removeFromSubCategories(at idx: Int)

    @objc(insertSubCategories:atIndexes:)
    @NSManaged public func insertIntoSubCategories(_ values: [SubCategory], at indexes: NSIndexSet)

    @objc(removeSubCategoriesAtIndexes:)
    @NSManaged public func removeFromSubCategories(at indexes: NSIndexSet)

    @objc(replaceObjectInSubCategoriesAtIndex:withObject:)
    @NSManaged public func replaceSubCategories(at idx: Int, with value: SubCategory)

    @objc(replaceSubCategoriesAtIndexes:withSubCategories:)
    @NSManaged public func replaceSubCategories(at indexes: NSIndexSet, with values: [SubCategory])

    @objc(addSubCategoriesObject:)
    @NSManaged public func addToSubCategories(_ value: SubCategory)

    @objc(removeSubCategoriesObject:)
    @NSManaged public func removeFromSubCategories(_ value: SubCategory)

    @objc(addSubCategories:)
    @NSManaged public func addToSubCategories(_ values: NSOrderedSet)

    @objc(removeSubCategories:)
    @NSManaged public func removeFromSubCategories(_ values: NSOrderedSet)

}

// MARK: Generated accessors for transactions
extension Category {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Budget)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Budget)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
