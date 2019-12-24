//
//  WalletContainer+CoreDataProperties.swift
//  MoneyApp
//
//  Created by Orackle on 24.12.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//
//

import Foundation
import CoreData


extension WalletContainer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletContainer> {
        return NSFetchRequest<WalletContainer>(entityName: "WalletContainer")
    }

    @NSManaged public var wallets: NSOrderedSet?

}

// MARK: Generated accessors for wallets
extension WalletContainer {

    @objc(insertObject:inWalletsAtIndex:)
    @NSManaged public func insertIntoWallets(_ value: Wallet, at idx: Int)

    @objc(removeObjectFromWalletsAtIndex:)
    @NSManaged public func removeFromWallets(at idx: Int)

    @objc(insertWallets:atIndexes:)
    @NSManaged public func insertIntoWallets(_ values: [Wallet], at indexes: NSIndexSet)

    @objc(removeWalletsAtIndexes:)
    @NSManaged public func removeFromWallets(at indexes: NSIndexSet)

    @objc(replaceObjectInWalletsAtIndex:withObject:)
    @NSManaged public func replaceWallets(at idx: Int, with value: Wallet)

    @objc(replaceWalletsAtIndexes:withWallets:)
    @NSManaged public func replaceWallets(at indexes: NSIndexSet, with values: [Wallet])

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: Wallet)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: Wallet)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSOrderedSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSOrderedSet)

}
